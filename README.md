# Console Gaming Subscription Database

A MySQL 8.0 database for a console gaming service: players, accounts, subscription tiers, game licences, billing and customer support. The schema has 10 tables normalised to Third Normal Form (3NF), and the script includes sample data and 10 analytical queries. Final project for the Relational DBMS course at SRH University.

## Entity-relationship diagram

<img width="691" height="467" alt="Entity-relationship diagram of the 10 tables" src="https://github.com/user-attachments/assets/fe0de80b-ba3e-4a60-89a3-9adb907f00de" />

## Schema

- **10 tables:** Player, Console, SubscriptionTier, Publisher, Game, Account, Account_Games, Transaction, SupportAgent, SupportTicket
- **Normalised to 3NF** to avoid redundant data; the report contains the functional dependencies and normalisation steps
- **Integrity constraints:** primary and foreign keys, `UNIQUE` (e-mails, usernames, tier names), and `CHECK` constraints (no negative prices or amounts, valid ticket statuses)
- **One licence per game per account:** enforced by the composite primary key of `Account_Games`, plus a `BEFORE INSERT` trigger that returns a clear error message

## Queries

| # | Question answered | Technique |
|---|---|---|
| Q1 | Revenue per subscription tier | `JOIN`, `GROUP BY` |
| Q2 | Most-owned games, ranked within each genre | CTE, `RANK()` window function |
| Q3 | High-spending accounts that also bought in January 2024 | Correlated subqueries |
| Q4 | Billing status per account (active, overdue, never billed) | `LEFT JOIN`, `CASE` |
| Q5 | Publishers with several games and their price range | `HAVING`, `MIN`/`MAX` |
| Q6 | Tickets by status or by agent e-mail domain | `LIKE` pattern matching |
| Q7 | Lifetime spend per account | View |
| Q8 | Games owned by a given account | Stored procedure |
| Q9 | Block duplicate game licences | Trigger with `SIGNAL` |
| Q10 | Running total of billing per account | `SUM() OVER` window function |

## How to run

1. Install MySQL Server 8.0+ and a client such as MySQL Workbench.
2. Open `Schema_Queries.sql` and run the whole script. It drops and recreates the `ConsoleGamingSubscriptions` database, creates the tables in foreign-key order, inserts the sample data and runs every query.
3. To see the trigger work, run the commented-out `INSERT` at the end of the file on its own. It is expected to fail with *"Account already owns a license for this game"*.

## Report

`Databases_Project_Report.pdf` covers the requirements analysis, the ER model (Crow's Foot notation), functional dependencies, the normalisation to 3NF, and a discussion of performance at scale, ACID compliance and the CAP theorem.

## Technologies

MySQL 8.0 · MySQL Workbench · Lucidchart (ER modelling)
