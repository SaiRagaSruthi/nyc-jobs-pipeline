import pandas as pd
import logging
import os

# Setup logging
os.makedirs("logs", exist_ok=True)
logging.basicConfig(filename="logs/cleaning.log", level=logging.INFO)

def clean_data(df):
    logging.info(f"Initial shape: {df.shape}")
    
    # Remove missing values
    df = df.dropna()
    logging.info(f"After dropna: {df.shape}")
    
    # Remove duplicates
    df = df.drop_duplicates()
    logging.info(f"After drop_duplicates: {df.shape}")
    
    return df

# Load and clean the latest file
today = pd.Timestamp.today().strftime('%Y-%m-%d')
input_path = f"output/nyc_jobs_{today}.csv"
df = pd.read_csv(input_path)

df_cleaned = clean_data(df)
df_cleaned.to_csv(f"output/cleaned_nyc_jobs_{today}.csv", index=False)

logging.info(f"Saved cleaned file to: output/cleaned_nyc_jobs_{today}.csv")
