create database nyc_jobs_database;

use nyc_jobs_database;

create table job_postings_table (
    Job_ID INT,
    Agency VARCHAR(200),
    Posting_Date DATE
    );
    
SELECT YEAR(Posting_Date) AS Year, COUNT(*) AS Job_Ad_Count
FROM job_postings_table
GROUP BY YEAR(Posting_Date)
ORDER BY Year;