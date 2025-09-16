# Simple Bank Project

## Database Schema Design

The database schema for this project was designed using [dbdiagrams.io](https://dbdiagrams.io/) and consists of the following tables:

### Tables

1. **accounts** - Stores user account information
   - id (PK)
   - owner
   - balance
   - currency
   - created_at

2. **entries** - Records all balance changes
   - id (PK)
   - account_id (FK)
   - amount (can be positive or negative)
   - created_at

3. **transfers** - Records money transfers between accounts
   - id (PK)
   - from_account_id (FK)
   - to_account_id (FK)
   - amount (only positive values)
   - created_at

The schema includes appropriate indexes and foreign key constraints to maintain data integrity and optimize query performance.

## Setup Instructions

### Golang Setup
1. Install Go from the [official website](https://golang.org/dl/)
2. Set up your GOPATH environment variable
3. Verify installation with `go version`

### VSCode Setup
1. Install Visual Studio Code
2. Install Go extension for VSCode
3. Install recommended Go tools when prompted
4. Configure settings for Go development

### Docker Setup
1. Install Docker
2. Check running containers with `docker ps`
3. List all containers (including stopped ones) with `docker ps -a`
4. View available images with `docker image ls`
5. Pull Postgres image with `docker pull postgres:12-alpine`
6. Run Postgres container:
   ```
   docker run --name simple_bank -e POSTGRES_PASSWORD=secret -e POSTGRES_USER=root -p 5432:5432 -d postgres:12-alpine
   ```
7. Access PostgreSQL shell:
   ```
   docker exec -t simple_bank psql
   ```
8. View container logs:
   ```
   docker logs simple_bank
   ```
9. Stop the container:
   ```
   docker stop simple_bank
   ```
10. Start the container:
   ```
   docker start simple_bank
   ```
11. Access container shell:
   ```
   docker exec -it simple_bank /bin/sh
   ```
12. Create a new database (run this command after accessing the shell):
   ```
   createdb --username=root --owner=root simple_bank
   ```
13. Connect to the simple_bank database:
   ```
   psql simple_bank
   ```
14. Drop the database (if needed):
   ```
   dropdb simple_bank
   ```
15. Exit PostgreSQL shell:
   ```
   \q
   ```
16. Exit container shell:
   ```
   exit
   ```
17. Remove container (when no longer needed):
   ```
   docker rm simple_bank
   ```

### TablePlus Setup
1. Download and install TablePlus from [official website](https://tableplus.com/)
2. Create a new connection with the following details:
   - Name: simple_bank
   - Host: localhost
   - Port: 5432
   - User: root
   - Password: secret
   - Database: simple_bank
3. Connect and use the GUI to manage your database
4. Execute the database schema SQL:
   - Open the SQL tab in TablePlus
   - Copy and paste all code from `Simple bank.sql` file
   - Run the SQL commands to create tables, indexes, and constraints

### Database Migration
1. Install golang-migrate:
   ```
   brew install golang-migrate
   ```
2. Create a migrations directory:
   ```
   mkdir -p db/migration
   ```
3. Create migration files:
   ```
   migrate create -ext sql -dir db/migration -seq init_schema
   ```
4. Add SQL code to the migration files:
   - For the **up migration** (`000001_init_schema.up.sql`):
     - Copy all SQL statements from `Simple bank.sql`
     - Ensure all columns have NOT NULL constraints where appropriate
     - Verify all foreign key relationships are correctly defined
     - Include all indexes and comments from the original schema
   - For the **down migration** (`000001_init_schema.down.sql`):
     - Add DROP TABLE statements in the reverse order of creation to handle dependencies
     - Example:
       ```sql
       DROP TABLE IF EXISTS transfers;
       DROP TABLE IF EXISTS entries;
       DROP TABLE IF EXISTS accounts;
       ```
     - Note: The order is important due to foreign key constraints
5. Run migrations:
   ```
   migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up
   ```

### Makefile
The project includes a Makefile to automate common tasks for development and database management. Using these commands simplifies the workflow and ensures consistency across development environments.

1. **Start PostgreSQL container**:
   ```
   make postgres
   ```
   This command starts a new PostgreSQL container using Docker with the following configuration:
   - Container name: simple_bank
   - Port mapping: 5432:5432
   - Username: root
   - Password: secret
   - PostgreSQL version: 12-alpine (lightweight image)
   
   Actual command:
   ```
   docker run --name simple_bank -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine
   ```

2. **Create database**:
   ```
   make createdb
   ```
   This command connects to the running PostgreSQL container and creates a new database named 'simple_bank' with 'root' as both the username and owner. The database is created empty and ready for migrations.
   
   Actual command:
   ```
   docker exec -it simple_bank createdb --username=root --owner=root simple_bank
   ```

3. **Drop database**:
   ```
   make dropdb
   ```
   This command completely removes the 'simple_bank' database from the PostgreSQL server. Use with caution as this will delete all data in the database.
   
   Actual command:
   ```
   docker exec -it simple_bank dropdb simple_bank
   ```

4. **Run migrations up**:
   ```
   make migrateup
   ```
   This command applies all pending database migrations in the 'db/migration' directory to create or update the database schema. It uses the golang-migrate tool to track which migrations have been applied and runs any new ones in sequence.
   
   Actual command:
   ```
   migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up
   ```

5. **Run migrations down**:
   ```
   make migratedown
   ```
   This command reverts all applied migrations, effectively returning the database to its initial empty state. This is useful for resetting the database during development or testing.
   
   Actual command:
   ```
   migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down
   ```

## Database Access

### Generating CRUD from SQL

There are several approaches to database access in Go, each with different trade-offs:

#### 1. database/sql (Standard Library)

**Pros:**
- Part of the standard library, no external dependencies
- Full control over SQL queries
- Lightweight and performant

**Cons:**
- Very verbose, requires a lot of boilerplate code
- Manual mapping between SQL and Go types
- No compile-time SQL validation
- Error-prone with manual string manipulation

**Example:**
```go
func GetAccount(id int64) (Account, error) {
    var account Account
    err := db.QueryRow("SELECT id, owner, balance, currency, created_at FROM accounts WHERE id = $1", id).Scan(
        &account.ID,
        &account.Owner,
        &account.Balance,
        &account.Currency,
        &account.CreatedAt,
    )
    return account, err
}
```

#### 2. GORM (ORM Library)

**Pros:**
- Intuitive API with method chaining
- Automatic migrations
- Hooks, validations, and callbacks
- Associations and relationships

**Cons:**
- Performance overhead due to reflection
- Magic/implicit behavior can be confusing
- SQL queries are generated at runtime
- Less control over the exact SQL being executed

**Example:**
```go
func GetAccount(id int64) (Account, error) {
    var account Account
    result := db.First(&account, id)
    return account, result.Error
}
```

#### 3. sqlx (Enhanced database/sql)

**Pros:**
- Extends the standard library with convenience functions
- Reduces boilerplate through struct tag mapping
- Maintains performance close to database/sql
- Still allows writing raw SQL

**Cons:**
- No compile-time SQL validation
- Less feature-rich than full ORMs
- Still requires manual SQL writing

**Example:**
```go
func GetAccount(id int64) (Account, error) {
    var account Account
    err := db.Get(&account, "SELECT * FROM accounts WHERE id = $1", id)
    return account, err
}
```

#### 4. sqlc (SQL Compiler)

**Pros:**
- Write SQL, generate type-safe Go code
- Compile-time SQL validation
- No runtime reflection, very performant
- Type-safe queries with proper nullability

**Cons:**
- Requires a separate build step
- Less flexible for dynamic queries
- Steeper learning curve initially

**Example:**
```sql
-- queries.sql
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

### Our Choice: sqlc

For this project, we'll use **sqlc** because it offers:
- Type safety with compile-time SQL validation
- High performance without reflection
- Clear separation between SQL and Go code
- Excellent developer experience with generated code

## SQLC Setup and Usage

### Installation

```bash
brew install sqlc
```

Verify installation:
```bash
sqlc version
```

### Project Initialization

1. Create a sqlc configuration file:
```bash
sqlc init
```

2. Edit the generated `sqlc.yaml` file:
```yaml
version: "1"
packages:
  - name: "db"
    path: "./db/sqlc"
    queries: "./db/query/"
    schema: "./db/migration/"
    engine: "postgresql"
    emit_json_tags: true
    emit_prepared_queries: false
    emit_interface: false
    emit_exact_table_names: false
```

3. Create a directory for SQL queries:
```bash
mkdir -p db/query
```

### Writing Queries

Create query files in the `db/query` directory:

**account.sql**
```sql
-- name: CreateAccount :one
INSERT INTO accounts (
  owner,
  balance,
  currency
) VALUES (
  $1, $2, $3
) RETURNING *;

-- name: GetAccount :one
SELECT * FROM accounts
WHERE id = $1 LIMIT 1;

-- name: ListAccounts :many
SELECT * FROM accounts
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateAccount :one
UPDATE accounts
SET balance = $2
WHERE id = $1
RETURNING *;

-- name: DeleteAccount :exec
DELETE FROM accounts
WHERE id = $1;
```

**entry.sql**
```sql
-- name: CreateEntry :one
INSERT INTO entries (
  acccount_id,
  amount
) VALUES (
  $1, $2
) RETURNING *;

-- name: GetEntry :one
SELECT * FROM entries
WHERE id = $1 LIMIT 1;

-- name: ListEntries :many
SELECT * FROM entries
WHERE acccount_id = $1
ORDER BY id
LIMIT $2
OFFSET $3;

-- name: UpdateEntry :one
UPDATE entries
SET amount = $2
WHERE id = $1
RETURNING *;

-- name: DeleteEntry :exec
DELETE FROM entries
WHERE id = $1;
```

**transfer.sql**
```sql
-- name: CreateTransfer :one
INSERT INTO transfers (
  from_acccount_id,
  to_acccount_id,
  amount
) VALUES (
  $1, $2, $3
) RETURNING *;

-- name: GetTransfer :one
SELECT * FROM transfers
WHERE id = $1 LIMIT 1;

-- name: ListTransfers :many
SELECT * FROM transfers
WHERE 
  from_acccount_id = $1 OR
  to_acccount_id = $2
ORDER BY id
LIMIT $3
OFFSET $4;

-- name: UpdateTransfer :one
UPDATE transfers
SET amount = $2
WHERE id = $1
RETURNING *;

-- name: DeleteTransfer :exec
DELETE FROM transfers
WHERE id = $1;
```

### Generating Code

Generate Go code from SQL queries using either of these methods:

1. Direct command:
```bash
sqlc generate
```

2. Using the Makefile (recommended):
```bash
make sqlc
```

This will create Go files in the `db/sqlc` directory with type-safe functions for each query:
- **models.go**: Contains the struct definitions for your database tables
- **db.go**: Contains the database connection interface
- **account.sql.go**: Contains the generated CRUD functions for accounts

### Using Generated Code

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
	conn, err := sql.Open("postgres", "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable")
	if err != nil {
		log.Fatal("cannot connect to db:", err)
	}

	queries := db.New(conn)

	// Create an account
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

### Add to Makefile

Update the Makefile to include sqlc commands:

```makefile
sqlc:
	sqlc generate

.PHONY: postgres createdb dropdb migrateup migratedown sqlc
```

## Project Overview
This project implements a simple banking system. More details about features and implementation will be added as the project progresses.
