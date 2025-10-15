/*
Question : Quelles sont les compétences les plus demandées pour les analystes de données/data ?
- Joindre les offres d'emploi à la table en utilisant un INNER JOIN, similaire à la requête 2.
- Identifier les 5 compétences les plus demandées pour un analyste de données.
- Se concentrer sur toutes les offres d'emploi.
- Objectif : obtenir les 5 compétences les plus demandées sur le marché du travail, 
fournissant ainsi des informations précieuses sur les compétences les plus recherchées par les employeurs.
*/

SELECT *
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
LIMIT 5;

/*

*/