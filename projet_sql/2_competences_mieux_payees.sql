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
Changons notre localisation de "France" et tentons "Anywhere" (Partout). Cela nous permettrait de voir des emplois en télétravail dans le monde entier,
possible depuis la France.
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
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
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
Le resultat est clair, les compétences les mieux rémunérés en télétravail depuis la France sont les suivantes:

1. SQL (Apparait 12 fois)
2. Python (Apparait 11 fois)
3. Tableau (Apparait 8 fois)
4. R (Apparait 5 fois)
5. Excel (Apparait 3 fois)

Nous devrions donc nous concentrer sur ces compétences pour tenter de décrocher les emplois d’analyste de données/data les mieux rémunérés !
*/