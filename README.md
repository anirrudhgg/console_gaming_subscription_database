# Console Gaming Subscription Database

## Overview
A fully normalized MySQL 8.0 database (3NF) managing console subscriptions, game licensing, and billing with automated duplicate-charge prevention. It also handles user accounts, subscription tiers, and financial transactions for a gaming service.

## Features & Implementation
* **Schema Design:** 10 discrete entities normalized to Third Normal Form (3NF) to eliminate data redundancy.
* **Integrity Constraints:** Utilizes primary/foreign keys, UNIQUE constraints, and CHECK constraints to maintain strict data integrity.
* **Automated Logic:** Includes a custom `BEFORE INSERT` trigger to automatically block duplicate game license purchases.
* **Advanced Querying:** Implements complex SQL techniques including window functions, Common Table Expressions (CTEs), Subqueries, Views, and Stored Procedures for business intelligence reporting.
* **Performance & Scale:** Designed with considerations for ACID compliance, row-level locking, and the CAP theorem.

## Repository Contents
* `schema_and_queries.sql`: The complete MySQL script including table creation, constraint definitions, realistic sample data insertion, and 10 advanced analytical queries.
* `Database_Design_Report.pdf`: Comprehensive documentation covering requirements analysis, Entity-Relationship (Crow's Foot) diagrams, functional dependencies, normalization proofs, and database performance evaluations.

## Technologies Used
* MySQL 8.0
* Lucidchart (ER Modeling)

## How to Run
1. Ensure you have MySQL Server (8.0+) and a client like MySQL Workbench installed.
2. Clone this repository or download `schema_and_queries.sql`.
3. Open the file in your MySQL client and execute the entire script. 
4. The script will automatically drop/recreate the `ConsoleGamingSubscriptions` database, build the tables in foreign-key-safe order, insert sample data, and output the analytical query results.

## Entity-Relationship Diagram
<img width="691" height="467" alt="image" src="https://github.com/user-attachments/assets/fe0de80b-ba3e-4a60-89a3-9adb907f00de" />

*Developed as the final project for the Relational DBMS course at SRH University.*
