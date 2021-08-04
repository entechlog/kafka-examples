SELECT "GENDER_KEY", "GENDER_COUNT", 'Kafka' AS "SOURCE"
	FROM demo.users_gender_count;

SELECT "gender" AS GENDER_KEY, COUNT(*) AS "GENDER_COUNT", 'Postgres' as "SOURCE"
	FROM demo.users
GROUP BY GENDER;