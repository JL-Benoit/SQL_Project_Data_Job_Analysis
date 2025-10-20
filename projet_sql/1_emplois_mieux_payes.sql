/*
Question: What are the highest paying data analyst jobs?
- Identify the top 10 highest-paid remote data analyst positions.
- Focus only on roles with a listed salary (no NULL values).
- Objective: highlight the best-paid opportunities for data analysts, providing an overview of the role’s market health and attractiveness.
*/

SELECT
    job_id,
    company_dim.name AS company_name,
    job_title_short,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_title_short = 'Data Analyst' AND 
    job_location = 'France' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;



/*
However, the data for France with the condition “salary_year_avg IS NOT NULL” does not allow us to accurately reflect the French market.
So, we modified the query by removing the condition “salary_year_avg IS NOT NULL” to obtain better visibility.
*/

SELECT
    job_id,
    company_dim.name AS company_name,
    job_title_short,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_title_short = 'Data Analyst' AND 
    job_location = 'France' 
ORDER BY
    salary_year_avg DESC
LIMIT 100;