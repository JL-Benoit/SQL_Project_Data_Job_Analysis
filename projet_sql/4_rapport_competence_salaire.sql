/*
Question: What are the highest paying skills?
- Analyze the average salary associated with each skill for data analyst roles.
- Focus on positions with specified salaries, regardless of location.
Objective: reveal how different skills influence salary levels for data analysts and help identify the most “profitable” skills to acquire.
*/

SELECT 
    skills_dim.skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_fact.job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_postings_fact.job_work_from_home = TRUE
GROUP BY 
        skills_dim.skills
ORDER BY avg_salary DESC
LIMIT 25;
