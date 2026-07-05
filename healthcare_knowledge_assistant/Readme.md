# Healthcare Knowledge Assistant

This project uses MySQL database scripts to create and populate the healthcare appointment database.

## 1. Create the database and tables

Run the main SQL file first:

```bash
mysql -u root -p < patient_records_appointments.sql
```

Enter your MySQL password when prompted.

This script creates the database structure, including the required tables for patient records and appointments.

## 2. Insert sample data

After the tables are created, run the seed file:

```bash
mysql -u root -p < seed.sql
```

Enter your MySQL password again when prompted.

This script inserts sample data into the database.

## Notes

Make sure MySQL Server is running before running these commands.

Run the commands from the project folder:

```bash
cd healthcare_knowledge_assistant
```

Then run:

```bash
mysql -u root -p < patient_records_appointments.sql
mysql -u root -p < seed.sql
```

If `seed.sql` does not contain a `USE database_name;` statement, run it like this instead:

```bash
mysql -u root -p your_database_name < seed.sql
```