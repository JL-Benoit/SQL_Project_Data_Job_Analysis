/*
Les données disponibles en France avec la condition "salary_year_avg IS NOT NULL" ne permettent pas d’obtenir une analyse exploitable.
Nous avons donc ajusté notre approche : plutôt que de nous focaliser sur les compétences associées aux postes les mieux rémunérés,
nous avons choisi d’analyser les compétences les plus recherchées sur le marché français et nous avons extrait le top 5.
*/

WITH remote_job_skills AS (
    SELECT 
        skill_id,
        COUNT(*) AS skill_count
    FROM 
        skills_job_dim AS skills_to_job
    INNER JOIN 
        job_postings_fact AS job_postings ON job_postings.job_id = skills_to_job.job_id
    WHERE 
        job_postings.job_work_from_home = TRUE 
        AND job_postings.job_title_short = 'Data Analyst'
    GROUP BY 
        skill_id
)
SELECT 
    skills.skill_id,
    skills AS skill_name,
    skill_count
FROM 
    remote_job_skills
INNER JOIN 
    skills_dim AS skills ON skills.skill_id = remote_job_skills.skill_id
ORDER BY
    skill_count DESC
LIMIT 5;



/*
Le resultat est clair, les compétences les plus recherchées sur le marché français sont les suivantes:
1. SQL
2. Python
3. Power BI
4. Excel
5. Tableau

Nous devrions donc nous concentrer sur ces compétences pour tenter de decrocher un emploi d’analyste de données/data !
*/