#!/usr/bin/env bash

set -euo pipefail

DB_NAME="food_erp_test"

echo "=== Food Production ERP Setup ==="

for command in psql createdb cmake; do
    if ! command -v "$command" >/dev/null 2>&1; then
        echo "Error: $command is not installed."
        exit 1
    fi
done

if ! psql -d postgres -Atqc "SELECT 1" >/dev/null 2>&1; then
    echo "Error: Cannot connect to PostgreSQL."
    exit 1
fi

if psql -d postgres -Atqc "SELECT 1 FROM pg_database WHERE datname = '$DB_NAME'" | grep -qx 1; then
    echo "Database already exists: $DB_NAME"
else
    echo "Creating database: $DB_NAME"
    createdb "$DB_NAME"
fi

SCHEMA_EXISTS=$(psql -d "$DB_NAME" -Atqc "SELECT to_regclass('public.products') IS NOT NULL")

if [ "$SCHEMA_EXISTS" = "f" ]; then
    echo "Creating database schema..."
    psql -v ON_ERROR_STOP=1 -d "$DB_NAME" -f DB/schema.sql

    echo "Inserting initial data..."
    psql -v ON_ERROR_STOP=1 -d "$DB_NAME" -f DB/seed.sql
else
    echo "Database schema already exists. Skipping initialization."
fi

echo "Building application..."

cmake -S . -B build
cmake --build build

echo "Starting Food Production ERP..."

DB_NAME="$DB_NAME" ./build/food-erp