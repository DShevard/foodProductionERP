# Food Production ERP

A console-based ERP system for managing food production, recipes, raw materials, warehouse stock, and production orders.

The application is written in C++17 and uses PostgreSQL for persistent data storage and transaction-based production processing.

## Tech Stack

- C++17
- PostgreSQL
- libpq
- CMake
- Bash
- Git / GitHub

## Features

- View products and raw materials
- View warehouse stock
- View and create production orders
- Calculate required raw materials from recipes
- Check raw material availability
- Automatically consume raw materials during production
- Automatically add finished products to warehouse stock
- Complete production orders using PostgreSQL transactions
- Configure database name through environment variables
- Automated database initialization, build, and launch

## Architecture

```text
         Console Interface
                 |
                 v
         C++ Application
                 |
                 v
          Business Logic
                 |
                 v
               libpq
                 |
                 v
            PostgreSQL
```

The application separates database operations from ERP business logic.

PostgreSQL is responsible for storing products, recipes, inventory, and production orders.

## Project Structure

```text
foodProductionERP/
├── CMakeLists.txt
├── README.md
├── .gitignore
├── setup.sh
├── DB/
│   ├── schema.sql
│   ├── seed.sql
│   └── production.sql
└── src/
    ├── main.cpp
    ├── database.cpp
    ├── database.h
    ├── erp.cpp
    └── erp.h
```

## Requirements

Before running the application, make sure the following tools are installed:

- C++17-compatible compiler
- CMake
- PostgreSQL
- PostgreSQL client tools (`psql`, `createdb`)
- PostgreSQL development libraries (`libpq`)
- Bash

The application can be built on macOS and Linux.

PostgreSQL must be running, and the current database user must have permission to create databases.

## Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/DShevard/foodProductionERP.git
cd foodProductionERP
```

### 2. Run the setup script

```bash
./setup.sh
```

The script automatically:

1. Checks the required tools.
2. Verifies the PostgreSQL connection.
3. Creates the `food_erp_test` database if it does not exist.
4. Initializes the database schema and inserts test data when needed.
5. Configures and builds the C++ application using CMake.
6. Launches the ERP application.

**Note:** The script does not reinstall dependencies or overwrite an existing initialized database.

Once the setup is complete, the application starts automatically.

### 3. Use the application

```text
=== Food Production ERP ===
1. Show products
2. Show raw materials
3. Show stock
4. Show production orders
5. Create production order
6. Complete production order
0. Exit
```

To launch the application again without running the setup script:

```bash
DB_NAME=food_erp_test ./build/food-erp
```

## Manual Setup

Alternatively, the application can be configured manually.

### 1. Create the database

```bash
createdb food_erp_test
```

### 2. Apply the database schema

```bash
psql food_erp_test -f DB/schema.sql
```

### 3. Insert sample data

```bash
psql food_erp_test -f DB/seed.sql
```

### 4. Build the application

```bash
cmake -S . -B build
cmake --build build
```

### 5. Run

```bash
DB_NAME=food_erp_test ./build/food-erp
```

If `DB_NAME` is not set, the application asks for a database name during startup.

## Database Structure

The database contains seven main entities:

- Products
- Raw materials
- Recipes
- Recipe items
- Raw material stock
- Product stock
- Production orders

Recipes define which raw materials and quantities are required to manufacture each product.

## Production Workflow

```text
       Production Order
               |
               v
       Find Product Recipe
               |
               v
    Calculate Required Materials
               |
               v
       Check Warehouse Stock
               |
        +------+------+
        |             |
   Sufficient     Insufficient
        |             |
        v             v
   Consume Raw     Reject Order
   Materials       Completion
        |
        v
   Add Finished
   Products to Stock
        |
        v
   Mark Order as
      COMPLETED
```

Production processing uses PostgreSQL transactions to ensure that related database changes are committed atomically.

If the operation fails, the transaction can be rolled back to prevent partial inventory updates.

## Example Usage

### Create a production order

```text
Choose: 5

=== Create Production Order ===

Product ID: 1
Quantity: 100

Production order created. ID: 4
```

### Complete a production order

```text
Choose: 6

=== Complete Production Order ===

Order ID: 4

Production order completed successfully!
```

Upon successful completion, the application updates raw material stock, finished product stock, and production order status.

## Configuration

The application reads the database name from the `DB_NAME` environment variable.

Example:

```bash
export DB_NAME=food_erp_test
./build/food-erp
```

Or:

```bash
DB_NAME=food_erp_test ./build/food-erp
```

The automated setup script uses `food_erp_test` as its database name.

## Purpose

This project demonstrates practical application of:

- C++ application architecture
- PostgreSQL database integration
- SQL queries and relational data modeling
- Database transactions
- ERP business logic
- Inventory management
- CMake build automation
- Shell scripting

The primary goal is to implement a small but functional ERP system that models real-world food production workflows.