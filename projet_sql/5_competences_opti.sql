/*
Question : Quelles sont les compétences les plus intéressantes à apprendre 
(autrement dit, celles qui sont à la fois très demandées et bien rémunérées) ?
- Identifier les compétences les plus recherchées sur le marché et associées à des salaires élevés pour les postes d’analyste de données/data.
- Se concentrer sur les emplois à distance dont les salaires sont clairement indiqués.
Objectif : Repérer les compétences qui offrent à la fois une bonne sécurité d’emploi (forte demande) et de meilleures perspectives financières (salaires élevés). 
Cette approche fournit des pistes stratégiques pour orienter notre développement de carrière dans le domaine de l’analyse de données/data.
*/

WITH skills_demand AS (
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM 
        job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_postings_fact.job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL AND
        job_postings_fact.job_work_from_home = TRUE
    GROUP BY 
            skills_dim.skill_id
), avg_salary AS (
    SELECT 
        skills_job_dim.skill_id,
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
           skills_job_dim.skill_id 
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM
    skills_demand
INNER JOIN avg_salary ON skills_demand.skill_id = avg_salary.skill_id
WHERE 
    demand_count > 10
ORDER BY 
    avg_salary DESC,
    demand_count DESC;
    
/*
C'est un sacré bout de code qui nous permet de trouver ce que les compétences les plus recherchées sur le marché 
et associées à des salaires élevés pour les postes d’analyste de données/data. Nous pouvons le simplifier.
*/

SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg),0) AS avg_salary
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_fact.job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_postings_fact.job_work_from_home = TRUE
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) >10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;


/*
Les compétences qui offrent à la fois une bonne sécurité d’emploi (forte demande) et de meilleures perspectives financières (salaires élevés) sont très différentes.
Celles qui sont les plus demandées sont les compétences précédemment mentionnées, telles que SQL, Python et Tableau, tandis que les compétences associées aux salaires les plus élevés concernent le cloud, comme AWS et Azure.
Un jour, ce serait une bonne idée de se lancer et d’apprendre ces compétences !
*/