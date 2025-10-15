/*
Question : Quelles sont les compétences les plus demandées pour les analystes de données/data ?
- Joindre les offres d'emploi à la table en utilisant un INNER JOIN, similaire à la requête 2.
- Identifier les 5 compétences les plus demandées pour un analyste de données/data.
- Se concentrer sur toutes les offres d'emploi.
- Objectif : obtenir les 5 compétences les plus demandées sur le marché du travail, 
fournissant ainsi des informations précieuses sur les compétences les plus recherchées par les employeurs.
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
Les 5 compétences les plus demandées sur le marché du travail sont :
1. SQL (Apparait 92628 fois)
2. Excel (Apparait 67031 fois)
3. Python (Apparait 57326 fois)
4. Tableau (Apparait 46554 fois)
5. Power BI (Apparait 39468 fois)

Cependant nous voulons affiner la recherche pour un emploi en France.
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

/*
Les 5 compétences les plus demandées sur le marché du travail en France sont :
1. SQL (Apparait 726 fois)
2. Python (Apparait 534 fois)
3. Power BI (Apparait 447 fois)
4. Excel (Apparait 372 fois)
5. sas (Apparait 318 fois)

Nous pouvons en conclure que, parmi les 5 compétences les plus demandées sur le marché du travail mondial et celles les plus demandées en France, 
les compétences sur lesquelles nous devrions nous concentrer sont :
1. SQL
2. Python
3. Excel
4 et 5. Un outil de Business intelligence comme Power BI ou Tableau

Ainsi, nous voyons qu’il est possible de nous concentrer sur moins de cinq compétences essentielles, ce qui constitue une information précieuse !
*/