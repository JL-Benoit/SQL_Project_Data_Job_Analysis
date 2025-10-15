/*
Question : Quelles compétences sont requises pour les emplois d’analyste de données/data les mieux rémunérés ?
- Utiliser les 10 postes d’analyste de données/data les mieux payés issus de la première requête.
- Ajouter les compétences spécifiques exigées pour ces postes.
- Objectif : Permettre de voir en détail quelles compétences sont recherchées dans les emplois les mieux payés, 
et d’aider les candidats à savoir sur quoi se concentrer pour viser les meilleurs salaires.
*/

WITH top_paying_jobs AS (
    SELECT
        job_id,
        company_dim.name AS company_name,
        job_title_short,
        salary_year_avg
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE 
        job_title_short = 'Data Analyst' AND 
        job_location = 'France' 
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)
SELECT 
    top_paying_jobs.*,
    skills_dim.skills
FROM 
    top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY 
    salary_year_avg DESC;




/*
Les données disponibles en France avec la condition "salary_year_avg IS NOT NULL" ne permettent pas d’obtenir une analyse exploitable.
Nous avons donc ajusté notre approche : plutôt que de nous focaliser sur les compétences associées aux postes les mieux rémunérés,
nous avons choisi d’analyser les compétences les plus recherchées sur le marché français et nous avons extrait le top 5.
*/

WITH top_paying_jobs AS (
    SELECT
        job_id,
        company_dim.name AS company_name,
        job_title_short,
        salary_year_avg
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE 
        job_title_short = 'Data Analyst' 
        AND job_location = 'France'
    ORDER BY
        salary_year_avg DESC
)
SELECT 
    skills_dim.skills,
    COUNT(DISTINCT top_paying_jobs.job_id) AS job_count
FROM 
    top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY 
    skills_dim.skills
ORDER BY 
    job_count DESC
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