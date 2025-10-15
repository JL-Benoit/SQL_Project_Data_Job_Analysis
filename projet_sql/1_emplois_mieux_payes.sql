/*
Question : Quels sont les emplois d’analyste de données / data les mieux rémunérés ?
- Identifier le top 10 des postes d’analyste de données / data les mieux rémunérés en télétravail.
- Se concentrer uniquement sur les postes avec un salaire renseigné (aucune valeur NULL).
- Objectif : mettre en lumière les opportunités les mieux rémunérées pour les analystes de données,
offrant une vue d’ensemble sur la santé et l’attractivité du poste sur le marché de l’emploi.
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



/*Cependant, la data en France avec la condition "salary_year_avg IS NOT NULL" ne nous permet pas de voir correctement le marché Francais. 
Donc le query est modifié en enlevant la condition "salary_year_avg IS NOT NULL" pour avoir un meilleur visuel. 
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
LIMIT 10;