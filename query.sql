SELECT company_id, name
FROM company_dim
WHERE company_id IN (
SELECT company_id
FROM job_postings_fact
WHERE job_no_degree_mention = true
);

SELECT DISTINCT job_postings_fact.company_id, name
FROM company_dim
RIGHT JOIN job_postings_fact ON company_dim.company_id = job_postings_fact.company_id
WHERE job_no_degree_mention = true
ORDER BY job_postings_fact.company_id;



/*
This query counts, for each skill, the number of work-from-home job
postings, ranks the skills in descending order by that count
using DENSE_RANK, and returns the top five skills along with
their IDs, names, and job counts.
*/

WITH high_s AS(
SELECT skill_id, COUNT(skills_job_dim.job_id) no_of_jobs
FROM skills_job_dim
INNER JOIN job_postings_fact ON skills_job_dim.job_id = job_postings_fact.job_id

AND job_title_short = 'Data Analyst'
GROUP BY skill_id
)

SELECT DENSE_RANK() OVER(ORDER BY no_of_jobs DESC) rank,
high_s.skill_id, skills, high_s.no_of_jobs
FROM skills_dim
INNER JOIN high_s ON skills_dim.skill_id = high_s.skill_id
LIMIT 5;

