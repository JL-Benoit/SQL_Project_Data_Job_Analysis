/*
Question: What are the most in demand skills for data analysts?
- Join the job postings table using an INNER JOIN.
- Identify the top 5 most requested skills for a data analyst.
- Focus on all job listings.
Objective: determine the top 5 most in demand skills in the job market, providing valuable insights into the skills most sought after by employers.
*/

SELECT 
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_fact.job_title_short = 'Data Analyst'
GROUP BY 
        skills_dim.skills
ORDER BY demand_count DESC
LIMIT 5;

/*
The 5 most requested skills in the job market are:
1. SQL (appears 92,628 times)
2. Excel (appears 67,031 times)
3. Python (appears 57,326 times)
4. Tableau (appears 46,554 times)
5. Power BI (appears 39,468 times)

However, I would like to refine the search to focus on jobs in France.
*/


SELECT 
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_fact.job_title_short = 'Data Analyst' AND
    job_postings_fact.job_location = 'France' 
GROUP BY 
        skills_dim.skills
ORDER BY demand_count DESC
LIMIT 5;
