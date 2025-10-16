/*
Question : Quelles sont les compétences les mieux rémunérées ?
- Examiner le salaire moyen associé à chaque compétence pour les postes d’analyste de données/data.
- Se concentrer sur les rôles avec des salaires spécifiés, quel que soit l’emplacement.
- Objectif : Révéler comment différentes compétences influencent les niveaux de salaire des 
analystes de données/data et aider à identifier les compétences les plus "rentables" à acquérir.
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


/*
Nous pouvons voir que :
- Les postes d’analystes de données/data les mieux rémunérés combinent les compétences d'ingénierie des données, 
apprentissage automatique et compétences cloud — des outils comme PySpark, Databricks et Airflow dominent le classement.
- Les compétences de base en Python (Pandas, NumPy, Scikit-learn) restent essentielles, 
mais leur valeur augmente lorsqu’elles sont associées à des plateformes Big Data ou cloud.
- La maîtrise des outils DevOps (GitLab, Bitbucket, Jenkins) démontre une forte collaboration avec les équipes d’ingénierie et augmente les salaires.
- L’expertise cloud (GCP, Kubernetes) devient indispensable pour les postes à distance bien rémunérés.
*/