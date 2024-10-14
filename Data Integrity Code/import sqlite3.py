import pandas as pd
import os
from sqlalchemy import create_engine

# MySQL database connection configuration
db_config = {
    'user': 'root',
    'password': 'your_new_password',
    'host': 'localhost',
    'port': 3306,
    'database': 'traxidy'
}

# Create SQLAlchemy engine
connection_string = f"mysql+pymysql://{db_config['user']}:{db_config['password']}@{db_config['host']}:{db_config['port']}/{db_config['database']}"
engine = create_engine(connection_string)

# Query to get the list of tables in the database
tables_query = "SHOW TABLES;"
tables_df = pd.read_sql(tables_query, engine)

# Directory to save the exported CSV files
csv_directory = 'D:/Northeastern/Traxidy'
os.makedirs(csv_directory, exist_ok=True)

# Lists to track missing tables and mismatches
missing_tables = []
mismatch_report = []
correct_tables = []
row_count_discrepancies = 0

# Export each table to a CSV file and ensure data types and encoding consistency
for table in tables_df.iloc[:, 0]:
    query = f"SELECT * FROM {table};"
    df = pd.read_sql(query, engine)

    # Ensure that the CSV schema matches the database schema
    csv_file_path = os.path.join(csv_directory, f'{table}.csv')

    # Get columns and their data types from the database
    columns_query = f"SHOW COLUMNS FROM {table};"
    columns_df = pd.read_sql(columns_query, engine)
    db_columns = list(columns_df['Field'])  # Exact column names from DB
    
    # Cast columns to match database types
    db_dtypes = dict(zip(columns_df['Field'], columns_df['Type']))
    for column, dtype in db_dtypes.items():
        if 'int' in dtype:
            df[column] = df[column].astype('int64', errors='ignore')
        elif 'float' in dtype or 'decimal' in dtype:
            df[column] = df[column].astype('float64', errors='ignore')
        elif 'datetime' in dtype:
            df[column] = pd.to_datetime(df[column], errors='coerce')

    # Fill missing values with NA to ensure consistency
    df.fillna(value=pd.NA, inplace=True)
    
    # Save each table's data into a separate CSV with UTF-8 encoding
    df.to_csv(csv_file_path, index=False, encoding='utf-8')

    # Validate row counts
    row_count_db = df.shape[0]
    row_count_csv = pd.read_csv(csv_file_path).shape[0]

    if row_count_db != row_count_csv:
        mismatch_report.append(f"Row count mismatch in '{table}': DB has {row_count_db} rows, CSV has {row_count_csv} rows.")
        row_count_discrepancies += 1
    else:
        correct_tables.append(table)

    # Check for column mismatches
    csv_df = pd.read_csv(csv_file_path, encoding='utf-8')
    if set(db_columns) != set(csv_df.columns):
        mismatch_report.append(f"Column mismatch in '{table}': DB has columns {db_columns} vs. CSV has columns {list(csv_df.columns)}")
    else:
        # Reorder columns in CSV to match the DB, if necessary
        csv_df = csv_df[db_columns]
        csv_df.to_csv(csv_file_path, index=False, encoding='utf-8')  # Save with correct column order

# Output the report of mismatches
if mismatch_report:
    print("Mismatch Report:")
    for mismatch in mismatch_report:
        print(mismatch)
else:
    print("All tables, rows, and columns are the same as the DB tables.")

# Final summary report
print(f"\n--- Summary Report ---")
print(f"Total mismatches found: {len(mismatch_report)}")
print(f"Total row count discrepancies: {row_count_discrepancies}")
