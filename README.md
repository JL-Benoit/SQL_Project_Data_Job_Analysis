# Introduction
This is my first SQL project. I mainly learned SQL through this project, but also by following the associated course on **[Luke Barousse's](https://www.youtube.com/watch?v=7mz73uXD9DA&t=12840s)**.
YouTube channel.
The course is based on a database he created, containing extensive information about the job market for data related roles in 2023 (positions, salaries, locations, key skills, etc.).

By focusing specifically on data analyst roles, this project explores:
- the highest-paying positions.
- the most in-demand skills.
- the skills associated with high salaries.
</br>

🕵️ Looking for my SQL queries? They’re here: [projet_sql](/projet_sql/)


# Some background information
Formerly a graphic designer and freelance photographer specializing in wildlife photography, I am now transitioning towards a career that suits me better: **data analysis!**

As a beginner in this field, I’m training in the key skills needed to become a data analyst, especially SQL. But how can I know exactly which skills to acquire in order to progress optimally and efficiently?
The answer: by analyzing the data itself… and that’s exactly what I’m doing <ins>**with SQL!**</ins>

Through my queries, I sought to answer the following questions:
- *Which data analyst positions offer the best salaries?*
- *What skills are required for these high-paying roles?*
- *Which skills are most in demand among data analysts?*
- *Which skills are associated with higher salaries?*
- *Which skills are the most strategic to develop to advance in this field?*


# 🪚 Tools used
To explore the job market for data analyst roles, I used:
- **SQL** to query the database and extract key insights.
- **PostgreSQL** to manage the data.
- **Visual Studio Code** to run my queries.
- **GitHub** to share my work.


# Analysis time !
Each query in this project was designed to explore a specific aspect of the data analyst job market. Here’s how I approached each question:

### 1. Which data analyst jobs offer the highest salaries?

To identify the best paying positions, I filtered data analyst job listings based on average annual salary and location, focusing on remote positions. This query highlights the most lucrative opportunities in the field.

However, salary data for France is missing, which prevents an accurate view of the French market.
So, I modified the query by removing the salary condition to get a clearer picture.

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
</br>

What can we take away from this?\
Unfortunately, the data concerning France is quite limited, which isn’t surprising, as this database mainly focuses on the United States.
Still, we can see that nearly all jobs are full time positions!
</br>


### 2. What skills are required for the highest-paying data analyst jobs?

To understand which skills are needed for the **best paying roles**, I used a JOIN between the job listings and the skills data. This made it possible to identify which skills employers prioritize for high salary positions.

Once again, the data related to France is quite limited, unsurprising given the U.S. focus of the dataset.
So, I changed the location from “France” to “Anywhere” to include remote jobs worldwide, which could also be done from France.
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
The results are clear!\
 The highest-paying remote skills (accessible from anywhere, including France) are:
1. **SQL** (appears 12 times)
2. **Python** (appears 11 times)
3. **Tableau** (appears 8 times)
4. **R** (appears 5 times)
5. **Excel** (appears 3 times)

And so it would seem focusing on these skills would be the best strategy to land the highest paying data analyst jobs!
</br>

### 3. What are the most in-demand skills for data analysts?

This next query helped identify the skills **most frequently requested** in job postings, highlighting the skills or tools most sought after by employers.

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
The 5 most in demand skills on the global job market are:
1. SQL (appears 92,628 times)
2. Excel (appears 67,031 times)
3. Python (appears 57,326 times)
4. Tableau (appears 46,554 times)
5. Power BI (appears 39,468 times)

However, we want to narrow down the search to jobs located in France.
I modified the query by adding the following condition:

```sql
AND job_postings_fact.job_location = 'France' 
```
Which gives us : 
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
This new query gives us the 5 most in demand skills on the job market in France. These skills are:
1. SQL (appears 726 times)
2. Python (appears 534 times)
3. Power BI (appears 447 times)
4. Excel (appears 372 times)
5. SAS (appears 318 times)

*Finally, some interesting data to analyze!*\
We can conclude that, among the top 5 most in demand skills globally and those most in demand in France, the skills I should focus on are:

1. **SQL**
2. **Python**
3. **Excel**
4. & 5. A Business Intelligence tool like **Power BI** or **Tableau**

<ins>This shows me which core skills I should focus on, which will save me time during my training!</ins>
</br>

### 4. Which skills are the highest-paying?

Exploring the average salaries associated with different skills helped reveal which skills are the most highly compensated.
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
Here’s an overview of the results regarding the highest paying skills for data analysts:

- **High demand for Big Data and Machine Learning skills:** The highest salaries go to analysts proficient in Big Data technologies *(PySpark, Couchbase)*, machine learning tools *(DataRobot, Jupyter)*, and Python libraries *(Pandas, NumPy)*. This reflects the strong industry value placed on data processing and predictive modeling skills.

- **Proficiency in software development and deployment:** Knowledge of development and deployment tools *(GitLab, Kubernetes, Airflow)* highlights a lucrative overlap between data analysis and engineering, with high demand for skills that enable automation and efficient management of data pipelines.

- **Expertise in cloud computing:** Familiarity with cloud and data engineering tools *(Elasticsearch, Databricks, GCP)* underscores the growing importance of cloud based analytics environments, suggesting that cloud proficiency significantly increases earning potential in the data field.
</br>


### 5. Which skills are the most strategic to learn?

In other words, those that are both highly in demand <ins>**and**</ins> well paid.
By combining information on demand and salaries, this query aimed to identify skills that are both highly sought after and well compensated, helping define strategic priorities for skill development.

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

The most strategic skills for data analysts in 2023 are distributed as follows:

- **Most in-demand programming languages:**
Python and R stand out for their high demand *(236 and 148 occurrences, respectively)*. Despite their popularity, their average salaries *(around $101,000 for Python and $100,000 for R)* indicate that these skills are highly valued, but also widely available in the market.

- **Cloud tools and technologies:**
Skills related to Snowflake, Azure, AWS, or BigQuery show both high demand and high salaries. This highlights the growing importance of cloud platforms and Big Data technologies in modern data analysis.

- **Business Intelligence and visualization tools:**
Tools like Tableau and Looker, with 230 and 49 mentions respectively, and average salaries of around $99,000 and $104,000, underscore the essential role of BI and visualization in turning data into actionable insights.

- **Database technologies:**
Demand for skills in traditional and NoSQL databases *(Oracle, SQL Server, NoSQL)*, with average salaries ranging from $97,000 to $105,000, shows that expertise in storing, managing, and retrieving data remains indispensable.
</br>
</br>

# Conclusion
So what are the general insights from this analysis? Let's see:

- **Highest paying data analyst positions:**
Remote data analyst roles exist, but salary data for France is insufficient. However, nearly all jobs in France are full-time contracts (CDI)!

- **Skills for the highest paying roles:**
Well paid jobs require advanced SQL proficiency, making it a key skill to access top salaries.

- **Most in demand skills:**
SQL is also the most sought after skill in the data analyst market, making it essential for candidates.

- **Skills associated with high salaries:**
Specialized skills like SVN and Solidity are linked to the highest average salaries, highlighting the value of niche expertise.

- **Optimal skills for market value:**
SQL dominates in both demand and average salary, making it <ins>**one of the most strategic skills to acquire**</ins> to maximize market value.
</br>


# 💡 What I've Learned

- I learned the basics of SQL and the logic that structures this language.
- I became familiar with creating and managing databases using PostgreSQL.
- I discovered the power of SQL to efficiently sort, filter, and compare millions of rows of data, making information clearer and more actionable.
- I learned to use Visual Studio Code to write and run SQL queries.
- I started using GitHub to share my analyses and document my projects.
</br>

# 🤔 Personal Takeaways

This project allowed me to strengthen my SQL skills while identifying the most in-demand and highest-paying skills, guiding my learning and job search as a data analyst.

*So what's next for me?*\
I'll continue practicing SQL and be focusing my time learning other skills such as Python, Power BI, and some specialized skills in the future!