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

## Project Overview
This project implements a simple banking system. More details about features and implementation will be added as the project progresses.
