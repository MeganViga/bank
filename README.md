# Simple Bank Project

> **Note:** For a more detailed, traditional documentation format, please refer to [Notes.md](Notes.md)

## 📊 Database Schema Design

> *Designed using [dbdiagrams.io](https://dbdiagrams.io/)*

```
📁 TABLES
│
├── 📋 accounts
│   ├── id (PK)
│   ├── owner
│   ├── balance
│   ├── currency
│   └── created_at
│
├── 📋 entries
│   ├── id (PK)
│   ├── account_id (FK → accounts.id)
│   ├── amount (+ or -)
│   └── created_at
│
└── 📋 transfers
    ├── id (PK)
    ├── from_account_id (FK → accounts.id)
    ├── to_account_id (FK → accounts.id)
    ├── amount (only positive)
    └── created_at
```

**Features:**
- ✅ Foreign key constraints for data integrity
- ✅ Indexes for optimized query performance
- ✅ Timestamp tracking for all records

## 🛠️ Setup Instructions

```
📦 DEVELOPMENT ENVIRONMENT
│
├── 🔷 Golang Setup
│   ├── Install Go from https://golang.org/dl/
│   ├── Set up GOPATH environment variable
│   └── Verify with `go version`
│
├── 📝 VSCode Setup
│   ├── Install Visual Studio Code
│   ├── Install Go extension
│   ├── Install recommended Go tools
│   └── Configure Go development settings
│
├── 🐳 Docker Setup
│   ├── Basic Commands
│   │   ├── `docker ps` - Check running containers
│   │   ├── `docker ps -a` - List all containers
│   │   ├── `docker image ls` - View available images
│   │   └── `docker pull postgres:12-alpine` - Pull Postgres image
│   │
│   ├── Container Management
│   │   ├── 🟢 Start: `docker run --name simple_bank -e POSTGRES_PASSWORD=secret -e POSTGRES_USER=root -p 5432:5432 -d postgres:12-alpine`
│   │   ├── 🔴 Stop: `docker stop simple_bank`
│   │   ├── 🟢 Restart: `docker start simple_bank`
│   │   └── 🗑️ Remove: `docker rm simple_bank`
│   │
│   └── Container Access
│       ├── 💻 Shell: `docker exec -it simple_bank /bin/sh`
│       ├── 📊 PostgreSQL: `docker exec -t simple_bank psql`
│       └── 📜 Logs: `docker logs simple_bank`
│
├── 🗃️ Database Management
│   ├── Inside Container Shell
│   │   ├── Create DB: `createdb --username=root --owner=root simple_bank`
│   │   ├── Connect to DB: `psql simple_bank`
│   │   ├── Drop DB: `dropdb simple_bank`
│   │   ├── Exit PostgreSQL: `\q`
│   │   └── Exit Shell: `exit`
│   │
│   └── TablePlus GUI
│       ├── Download from https://tableplus.com/
│       ├── Connection Settings
│       │   ├── Name: simple_bank
│       │   ├── Host: localhost
│       │   ├── Port: 5432
│       │   ├── User: root
│       │   ├── Password: secret
│       │   └── Database: simple_bank
│       │
│       └── Usage
│           ├── Connect to database
│           ├── Open SQL tab
│           ├── Paste schema from `Simple bank.sql`
│           └── Execute SQL commands
```

## 💾 Database Migration

```
📚 MIGRATION WORKFLOW
│
├── 💻 Installation
│   └── `brew install golang-migrate`
│
├── 📁 Setup
│   ├── Create directory: `mkdir -p db/migration`
│   └── Create files: `migrate create -ext sql -dir db/migration -seq init_schema`
│
├── 📝 Migration Files
│   ├── Up Migration (000001_init_schema.up.sql)
│   │   ├── Copy SQL from `Simple bank.sql`
│   │   ├── Add NOT NULL constraints
│   │   ├── Verify foreign keys
│   │   └── Include indexes and comments
│   │
│   └── Down Migration (000001_init_schema.down.sql)
│       ├── Add DROP TABLE statements in reverse order
│       └── Example:
│           ```sql
│           DROP TABLE IF EXISTS transfers;
│           DROP TABLE IF EXISTS entries;
│           DROP TABLE IF EXISTS accounts;
│           ```
│
└── 🔄 Run Migrations
    └── `migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up`
```

## 💬 Makefile Commands

```
⚙️ AUTOMATION COMMANDS
│
├── 🐳 Docker
│   ├── `make postgres`
│   │   ├── Starts PostgreSQL container
│   │   └── Command: docker run --name simple_bank -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine
│   │
│   ├── `make createdb`
│   │   ├── Creates simple_bank database
│   │   └── Command: docker exec -it simple_bank createdb --username=root --owner=root simple_bank
│   │
│   └── `make dropdb`
│       ├── Removes simple_bank database
│       └── Command: docker exec -it simple_bank dropdb simple_bank
│
├── 💾 Migrations
│   ├── `make migrateup`
│   │   ├── Applies all pending migrations
│   │   └── Command: migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up
│   │
│   └── `make migratedown`
│       ├── Reverts all migrations
│       └── Command: migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down
│
└── 💻 Code Generation
    └── `make sqlc`
        ├── Generates Go code from SQL
        └── Command: sqlc generate
```

## 📝 Database Access

```
🔍 GO DATABASE ACCESS OPTIONS
│
├── 🔵 database/sql (Standard Library)
│   ├── ✅ Pros
│   │   ├── Part of standard library
│   │   ├── Full SQL control
│   │   └── Lightweight & performant
│   │
│   ├── ❌ Cons
│   │   ├── Very verbose
│   │   ├── Manual type mapping
│   │   ├── No compile-time validation
│   │   └── Error-prone string manipulation
│   │
│   └── 💻 Example
│       ```go
│       func GetAccount(id int64) (Account, error) {
│           var account Account
│           err := db.QueryRow("SELECT id, owner, balance, currency, created_at FROM accounts WHERE id = $1", id).Scan(
│               &account.ID,
│               &account.Owner,
│               &account.Balance,
│               &account.Currency,
│               &account.CreatedAt,
│           )
│           return account, err
│       }
│       ```
│
├── 🔵 GORM (ORM Library)
│   ├── ✅ Pros
│   │   ├── Intuitive API with method chaining
│   │   ├── Automatic migrations
│   │   ├── Hooks, validations, callbacks
│   │   └── Associations & relationships
│   │
│   ├── ❌ Cons
│   │   ├── Performance overhead (reflection)
│   │   ├── Magic/implicit behavior
│   │   ├── Runtime SQL generation
│   │   └── Less control over SQL
│   │
│   └── 💻 Example
│       ```go
│       func GetAccount(id int64) (Account, error) {
│           var account Account
│           result := db.First(&account, id)
│           return account, result.Error
│       }
│       ```
│
├── 🔵 sqlx (Enhanced database/sql)
│   ├── ✅ Pros
│   │   ├── Extends standard library
│   │   ├── Reduces boilerplate
│   │   ├── Good performance
│   │   └── Raw SQL support
│   │
│   ├── ❌ Cons
│   │   ├── No compile-time validation
│   │   ├── Less feature-rich than ORMs
│   │   └── Manual SQL writing
│   │
│   └── 💻 Example
│       ```go
│       func GetAccount(id int64) (Account, error) {
│           var account Account
│           err := db.Get(&account, "SELECT * FROM accounts WHERE id = $1", id)
│           return account, err
│       }
│       ```
│
└── 🔵 sqlc (SQL Compiler) ⭐ OUR CHOICE
    ├── ✅ Pros
    │   ├── Type-safe generated Go code
    │   ├── Compile-time SQL validation
    │   ├── No runtime reflection
    │   └── Proper nullability handling
    │
    ├── ❌ Cons
    │   ├── Requires separate build step
    │   ├── Less flexible for dynamic queries
    │   └── Initial learning curve
    │
    └── 💻 Example
        SQL:
        ```sql
        -- name: GetAccount :one
        SELECT * FROM accounts
        WHERE id = $1 LIMIT 1;
        ```
        
        Generated Go code:
        ```go
        func (q *Queries) GetAccount(ctx context.Context, id int64) (Account, error) {
            // Type-safe implementation generated by sqlc
        }
        ```
```

**Why we chose sqlc:**
- ✨ Type safety with compile-time validation
- 🚀 High performance without reflection
- 🖊️ Clean separation between SQL and Go code
- 👍 Excellent developer experience

## 💻 SQLC Setup and Usage

```
🔧 SQLC WORKFLOW
│
├── 💻 Installation
│   ├── Install: `brew install sqlc`
│   └── Verify: `sqlc version`
│
├── 📝 Project Setup
│   ├── Create config: `sqlc init`
│   ├── Edit sqlc.yaml:
│   │   ```yaml
│   │   version: "1"
│   │   packages:
│   │     - name: "db"
│   │       path: "./db/sqlc"
│   │       queries: "./db/query/"
│   │       schema: "./db/migration/"
│   │       engine: "postgresql"
│   │       emit_json_tags: true
│   │       emit_prepared_queries: false
│   │       emit_interface: false
│   │       emit_exact_table_names: false
│   │   ```
│   └── Create directories: `mkdir -p db/query`
│
├── 📝 SQL Queries
│   ├── account.sql
│   │   ├── CreateAccount :one
│   │   ├── GetAccount :one
│   │   ├── ListAccounts :many
│   │   ├── UpdateAccount :one
│   │   └── DeleteAccount :exec
│   │
│   ├── entry.sql
│   │   ├── CreateEntry :one
│   │   ├── GetEntry :one
│   │   ├── ListEntries :many
│   │   ├── UpdateEntry :one
│   │   └── DeleteEntry :exec
│   │
│   └── transfer.sql
│       ├── CreateTransfer :one
│       ├── GetTransfer :one
│       ├── ListTransfers :many
│       ├── UpdateTransfer :one
│       └── DeleteTransfer :exec
│
├── 🔄 Code Generation
│   ├── Direct: `sqlc generate`
│   ├── Makefile: `make sqlc` (recommended)
│   └── Generated Files
│       ├── models.go (struct definitions)
│       ├── db.go (connection interface)
│       └── *sql.go (CRUD functions)
│
└── 💻 Usage Example
    ```go
    package main
    
    import (
        "context"
        "database/sql"
        "log"
    
        "github.com/yourusername/simple-bank/db/sqlc"
        _ "github.com/lib/pq"
    )
    
    func main() {
        // Connect to database
        conn, err := sql.Open("postgres", "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable")
        if err != nil {
            log.Fatal("cannot connect to db:", err)
        }
    
        // Create queries object
        queries := db.New(conn)
    
        // Execute a query
        account, err := queries.CreateAccount(context.Background(), db.CreateAccountParams{
            Owner:    "John Doe",
            Balance:  100,
            Currency: "USD",
        })
        if err != nil {
            log.Fatal("cannot create account:", err)
        }
    
        log.Printf("Created account: %+v\n", account)
    }
    ```
```

## 📊 Project Overview

This project implements a simple banking system with the following features:

- 💳 Account management
- 💰 Money transfers between accounts
- 📈 Transaction history tracking
- 🔒 Data integrity with foreign key constraints

More details about features and implementation will be added as the project progresses.
```

## Project Overview
This project implements a simple banking system. More details about features and implementation will be added as the project progresses.
