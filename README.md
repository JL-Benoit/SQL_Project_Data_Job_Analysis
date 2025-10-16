# Introduction
Ceci est mon premier projet en SQL. J’ai principalement appris SQL grâce à ce projet, mais aussi en suivant le cours associé sur la chaîne YouTube de **[Luke Barousse](https://www.youtube.com/watch?v=7mz73uXD9DA&t=12840s)**.
Le cours s’appuie sur une base de données créée par Luke Barousse, ayant beaucoup d'informations sur le marché du travail pour les postes liés à la data en **2023** *( postes, salaires, lieux, compétences clés, etc.)*.\


En me concentrant spécifiquement sur le poste d’analyste de données/data, ce projet explore :
- **les postes les mieux rémunérés**
- **les compétences les plus recherchées**
- **les compétences associées à un salaire élevé.**


🕵️ A la recherche de mes requêtes ? C'est ici : [projet_sql](/projet_sql/)

*Disclaimer : Mes requêtes sont en anglais car la base de donnees est en anglais.*



# Un peu d'histoire
Autrefois graphiste, puis photographe freelance spécialisé en photographie animalière, je me réoriente aujourd’hui vers une activité qui me correspond davantage :\
**l’analyse de données/data.**

Débutant dans ce domaine, je me forme aux compétences clés pour devenir analyste de données, notamment SQL. Mais comment savoir exactement quelles compétences acquérir pour progresser efficacement ?\
La réponse : en analysant les données elles-mêmes… et c’est exactement ce que je fais **<ins>grâce à SQL !</ins>**

À travers mes requêtes, j’ai cherché à répondre aux questions suivantes :
- *Quels postes d’analyste de données offrent les meilleurs salaires ?*
- *Quelles compétences sont nécessaires pour ces postes bien rémunérés ?*
- *Quelles compétences sont les plus demandées chez les analystes de données ?*
- *Quelles compétences sont associées à des salaires élevés ?*
- *Quelles compétences sont les plus stratégiques à développer pour progresser dans ce domaine ?*



# 🪚 Outils utilisés
Pour explorer le marché des emplois d’analyste de données, j’ai utilisé : 
- **SQL** pour interroger la base et extraire des insights clés
- **PostgreSQL** pour gérer les données
- **Visual Studio Code** pour exécuter mes requêtes
- **Git & GitHub** pour le partage de mon travail.


# Analyse !
Chaque requête de ce projet avait pour objectif d’explorer un aspect spécifique du marché des emplois d’analyste de données. Voici comment j’ai abordé chaque question :

### 1. Quels sont les emplois d’analyste de données/data les mieux rémunérés ?
Pour identifier les postes les mieux rémunérés, j’ai filtré les offres d’analyste de données en fonction du salaire annuel moyen et de la localisation, en me concentrant sur les postes en télétravail. Cette requête met en évidence les opportunités les plus lucratives dans le domaine.

Cependant, la data sur les salaires en France est absente, et ne nous permet pas de voir correctement le marché Français. 
Donc nous avons modifié la requête en enlevant la condition du salaire pour avoir un meilleur visuel. 

```sql 
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
```
Que pouvons‑nous en tirer ?\
Malheureusement, les données concernant la France sont peu fournies, ce qui n’est pas surprenant puisque cette base est principalement concentrée sur les États‑Unis.
On peut tout de même voir que les postes sont presque tous en CDI !

### 2. Quelles compétences sont requises pour les emplois d’analyste de données/data les mieux rémunérés ?
Pour comprendre quelles compétences sont requises pour les postes les mieux rémunérés, j’ai utilisé une jointure (JOIN) entre les offres d’emploi et les données sur les compétences, ce qui permet d’identifier celles que les employeurs privilégient pour les postes à haute rémunération.

Une fois de plus, les données concernant la France sont peu fournies, ce qui n’est pas surprenant puisque cette base est principalement concentrée sur les États‑Unis.\
 Donc j'ai changé la localisation de "France" et j'ai tenté la localisation "Anywhere" (Partout). Cela nous permettrait de voir des emplois en télétravail dans le monde entier, possible depuis la France.
```sql
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
```
Le resultat est clair, les compétences les mieux rémunérés en télétravail depuis la France sont les suivantes:

1. SQL (Apparait 12 fois)
2. Python (Apparait 11 fois)
3. Tableau (Apparait 8 fois)
4. R (Apparait 5 fois)
5. Excel (Apparait 3 fois)

Il faudrait donc se concentrer sur ces compétences pour tenter de décrocher les emplois d’analyste de données/data les mieux rémunérés !

### 3. Quelles sont les compétences les plus demandées pour les analystes de données/data ?
Cette prochaine requête a permis d’identifier les compétences les plus souvent demandées dans les offres d’emploi, orientant ainsi l’attention vers les domaines les plus recherchés.

```sql
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
```
Les 5 compétences les plus demandées sur le marché du travail global sont :
1. SQL (Apparait 92628 fois)
2. Excel (Apparait 67031 fois)
3. Python (Apparait 57326 fois)
4. Tableau (Apparait 46554 fois)
5. Power BI (Apparait 39468 fois)

Cependant nous voulons affiner la recherche pour un emploi en France. Je changes donc la requête en ajoutant la condition suivante :
```sql
AND job_postings_fact.job_location = 'France' 
```
Ce qui nous donne : 
```sql
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
```
Cette nouvelle requête nous donne les 5 compétences les plus demandées sur le marché du travail en France. Ces compétences sont :
1. SQL (Apparait 726 fois)
2. Python (Apparait 534 fois)
3. Power BI (Apparait 447 fois)
4. Excel (Apparait 372 fois)
5. sas (Apparait 318 fois)

*Finalement, des informations intéressantes a analyser !*\
Nous pouvons en conclure que, parmi les 5 compétences les plus demandées sur le marché du travail global **-et-** celles les plus demandées en France, les compétences sur lesquelles je devrais me concentrer sont :

**1. SQL**\
**2. Python**\
**3. Excel**\
**4. et 5.** Un outil de Business intelligence comme **Power BI** ou Tableau

Ainsi, nous voyons qu’il est possible de nous concentrer sur moins de cinq compétences essentielles, ce qui me fera gagner du temps lors de ma formation !

### 4. Quelles sont les compétences les mieux rémunérées ?
L’exploration des salaires moyens associés aux différentes compétences a permis de révéler quelles compétences sont les mieux rémunérées.
```sql
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
```
Voici un aperçu des résultats concernant les compétences les mieux rémunérées pour les analystes de données :
- **Forte demande en compétences Big Data et Machine Learning :** Les salaires les plus élevés sont attribués aux analystes maîtrisant les technologies de Big Data *(PySpark, Couchbase)*, les outils de machine learning *(DataRobot, Jupyter)* et les bibliothèques Python *(Pandas, NumPy)*. Cela reflète la forte valorisation, par le secteur, des compétences en traitement de données et en modélisation prédictive.

- **Maîtrise du développement et du déploiement logiciel :** La connaissance des outils de développement et de déploiement *(GitLab, Kubernetes, Airflow)* montre une convergence lucrative entre l’analyse de données et l’ingénierie, avec une forte demande pour les compétences facilitant l’automatisation et la gestion efficace des pipelines de données.

- **Expertise en cloud computing :** La familiarité avec les outils cloud et d’ingénierie des données *(Elasticsearch, Databricks, GCP)* souligne l’importance croissante des environnements d’analyse basés sur le cloud, suggérant qu’une maîtrise du cloud augmente significativement le potentiel de rémunération dans le domaine de la data.


### 5. Quelles sont les compétences les plus intéressantes à apprendre ?
Autrement dit, celles qui sont à la fois **très demandées** et **bien rémunérées.**\
En combinant les informations sur la demande et les salaires, cette requête visait à identifier les compétences à la fois très demandées et bien rémunérées, afin de définir les priorités stratégiques en matière de développement des compétences.

```sql
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
```

Les compétences les plus stratégiques pour les analystes de données en 2023 se répartissent comme suit :

- **Langages de programmation les plus demandés :**\
Python et R se distinguent par leur forte demande *(236 et 148 occurrences respectivement)*. Malgré cette popularité, leurs salaires moyens *(environ 101 000$ pour Python et 100 000$ pour R)* montrent que ces compétences sont très valorisées, mais aussi largement répandues sur le marché. 

- **Outils et technologies cloud :**\
Les compétences liées à Snowflake, Azure, AWS ou BigQuery affichent une forte demande et des salaires élevés. Cela souligne l’importance croissante des plateformes cloud et des technologies Big Data dans l’analyse de données moderne.

- **Outils de Business Intelligence et de visualisation :**\
Des outils comme Tableau et Looker, avec respectivement 230 et 49 mentions, et des salaires moyens d’environ 99 000$ et 104 000$, mettent en avant le rôle essentiel de la visualisation et de la BI pour transformer les données en insights exploitables.

- **Technologies de bases de données :**\
La demande pour les compétences en bases de données traditionnelles et NoSQL *(Oracle, SQL Server, NoSQL)*, avec des salaires moyens compris entre 97 000$ et 105 000$, montre que la maîtrise du stockage, de la gestion et de la récupération des données reste indispensable.


# 💡 Ce que j'ai appris 

- J’ai appris les bases de SQL ainsi que la logique qui structure ce langage.
- Je me suis familiarisé avec la création et la gestion de bases de données sous **PostgreSQL.**
- J’ai découvert la puissance de SQL pour trier, filtrer et comparer efficacement des millions de lignes de données, et pour rendre l’information plus claire et exploitable.
- J’ai appris à utiliser **Visual Studio Code** pour rédiger et exécuter mes requêtes SQL.
- Je me suis initié à **GitHub** afin de partager mes analyses et documenter mes projets.

# Conclusion
Informations générales issus de l’analyse:

1. **Postes d’analyste de données les mieux rémunérés :**\
Il existe des postes d’analyste de données en télétravail, mais les données salariales pour la France restent insuffisantes. On peut néanmoins constater que la quasi-totalité des postes sont en CDI !

2. **Compétences pour les postes les mieux rémunérés :**\
 Les emplois bien rémunérés exigent une maîtrise avancée de SQL, ce qui en fait une compétence clé pour accéder aux plus hauts salaires.

3. **Compétences les plus demandées :**\
 SQL est également la compétence la plus recherchée sur le marché des analystes de données, la rendant indispensable pour les candidats.

4. **Compétences associées à des salaires élevés :**\
 Des compétences spécialisées comme SVN et Solidity sont liées aux salaires moyens les plus élevés, soulignant la valeur des expertises de niche.

5. **Compétences optimales pour la valeur sur le marché :**\
 SQL domine à la fois en termes de demande et de salaire moyen, ce qui en fait <ins>l’une des compétences les plus stratégiques à acquérir</ins> pour maximiser sa valeur sur le marché du travail.

 # 🤔 En ce qui me concerne

 Ce projet m’a permis de renforcer mes compétences en SQL tout en identifiant les compétences les plus demandées et les mieux rémunérées pour guider l’apprentissage et la recherche d’emploi en tant qu’analyste de données.

 **La suite :**\
 Je vais continuer de m'exercer sur SQL et orienter mon apprentissage vers d'autres compétences tel que Python, Power BI et eventuellement des compétences spécialisées !