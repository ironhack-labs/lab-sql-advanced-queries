
-- 1. List each pair of actors that have worked together.
WITH cte_actor AS (
    SELECT
        a.actor_id AS actor_id,
        fa.film_id AS film_id,
        CONCAT(a.first_name, ' ', a.last_name) AS actor_name
    FROM
        sakila.film_actor fa
    LEFT JOIN
        sakila.actor a ON fa.actor_id = a.actor_id
)

SELECT
    ct1.actor_id AS actor1_id,
    ct1.actor_name AS actor1_name,
    ct1.film_id,
    ct2.actor_id AS actor2_id,
    ct2.actor_name AS actor2_name
FROM
    cte_actor ct1
INNER JOIN
    cte_actor ct2 ON ct1.film_id = ct2.film_id AND ct1.actor_id <> ct2.actor_id
ORDER BY
    ct1.film_id ASC;

-- 2. For each film, list actor that has acted in more films.
select * from sakila.film_actor;
select * from sakila.film;

WITH cte_actor2 AS (
   SELECT
		CONCAT(a.first_name, ' ', a.last_name) AS actor_name,
        a.actor_id AS actor_id,
        fa.film_id AS film_id,
        f.title as title,
        count(f.title) over(partition by a.actor_id) as count_film_per_actor
FROM
	sakila.film_actor fa
LEFT JOIN
	sakila.actor a ON fa.actor_id = a.actor_id
left join 
	sakila.film f on f.film_id = fa.film_id
)
select
	title,
    actor_name
from 
	cte_actor2
where
	count_film_per_actor > 1
	