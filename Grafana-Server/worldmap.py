import pandas as pd
from influxdb import InfluxDBClient

# Initialize InfluxDB client
client = InfluxDBClient(host="localhost", port=8086)

# Check if the InfluxDB connection works and list databases
try:
    databases = client.get_list_database()
    print("Databases available:", databases)
except Exception as e:
    print(f"Error connecting to InfluxDB: {e}")
    exit(1)

# Switch to the 'covid19' database (ensure it exists)
try:
    client.switch_database("covid19")
except Exception as e:
    print(f"Error switching to database 'covid19': {e}")
    exit(1)

# Load CSV data from 'countries.csv'
file_path = "countries.csv"  
try:
    df = pd.read_csv(file_path)
    print(f"CSV loaded successfully, shape: {df.shape}")
except FileNotFoundError:
    print(f"File not found: {file_path}")
    exit(1)
except pd.errors.EmptyDataError:
    print("The file is empty.")
    exit(1)
except Exception as e:
    print(f"Error reading CSV file: {e}")
    exit(1)

# Clean the data (if necessary)
df.dropna(inplace=True)
print(f"Data cleaned, new shape: {df.shape}")

# Insert data into InfluxDB
for row_ind, row in df.iterrows():
    json_body = [{
        "measurement": "Covidmap",
        "tags": {"Country": row['Location']},  
        "fields": {
            "name": row['Location'],  
            "latitude": float(row['Latitude']),  
            "longitude": float(row['Longitude']),  
            "confirmed_cases": float(row['Confirmed Covid19 Cases']),  
        }
    }]

    # Try writing points to InfluxDB
    try:
        success = client.write_points(json_body)
        if success:
            print(f"Successfully inserted row {row_ind + 1} of {df.shape[0]}: {row['Location']}")
        else:
            print(f"Failed to insert row {row_ind + 1}")
    except Exception as e:
        print(f"Error inserting row {row_ind + 1}: {e}")

print("Data insertion completed.")
