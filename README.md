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
3. View available images with `docker image ls`
4. Pull Postgres image with `docker pull postgres:12-alpine`
5. Run Postgres container:
   ```
   docker run --name simple_bank -e POSTGRES_PASSWORD=secret -e POSTGRES_USER=root -p 5432:5432 -d postgres:12-alpine
   ```
6. Access PostgreSQL shell:
   ```
   docker exec -t simple_bank psql
   ```
7. View container logs:
   ```
   docker logs simple_bank
   ```

### TablePlus Setup
1. Download and install TablePlus from [official website](https://tableplus.com/)
2. Create a new connection with the following details:
   - Name: simple_bank
   - Host: localhost
   - Port: 5432
   - User: root
   - Password: secret
   - Database: root
3. Connect and use the GUI to manage your database
4. Execute the database schema SQL:
   - Open the SQL tab in TablePlus
   - Copy and paste all code from `Simple bank.sql` file
   - Run the SQL commands to create tables, indexes, and constraints

## Project Overview
This project implements a simple banking system. More details about features and implementation will be added as the project progresses.
