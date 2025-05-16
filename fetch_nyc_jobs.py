import pandas as pd
import requests
from datetime import datetime
import os

# NYC Open Data API URL
API_URL = "https://data.cityofnewyork.us/resource/kpav-sd4t.json"
params = {"$limit": 1000}  # Adjust limit if needed

response = requests.get(API_URL, params=params)

if response.status_code == 200:
    data = response.json()
    df = pd.DataFrame(data)

    # Create "output" folder if it doesn't exist
    os.makedirs("output", exist_ok=True)

    # Save with today's date
    today = datetime.today().strftime('%Y-%m-%d')
    file_path = f"output/nyc_jobs_{today}.csv"
    df.to_csv(file_path, index=False)
    print(f"✅ Saved NYC jobs to {file_path}")
else:
    print(f"❌ Failed to fetch data: {response.status_code}")
