# Flask-sqlite3 application
## Tasks
### 1. Make normalization of initial animals table
#### Result contains the following tables
- animal_type - new table with animal type values
- breed - new table with animal breed value
- colors - new table with colors values
- animals_colors_new - new table for many-to-many relation between animals and colors
- outcome - new table with outcome information
- animals_new - final new table with general animals info and relations to other tables
### 2. Make Flask application to get animal info by id

## Files in project
- animal_db - sqlite3 database
- db_normalization.sql - sql queries to create new tables and insert data
- functions.py - python code to get information from the database
- main.py - main file to run Flask application
- requirements.txt - project dependencies description