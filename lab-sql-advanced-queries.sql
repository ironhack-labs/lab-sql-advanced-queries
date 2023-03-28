-- 1.List each pair of actors that have worked together.
WITH actors1 AS (
  SELECT a.actor_id, a.first_name, a.last_name, fa.film_id
  FROM sakila.actor a
  JOIN sakila.film_actor fa USING (actor_id)
),
actors2 AS (
  SELECT a.actor_id, a.first_name, a.last_name, fa.film_id
  FROM sakila.actor a
  JOIN sakila.film_actor fa USING (actor_id)
)
SELECT a1.actor_id, a1.first_name, a1.last_name, a2.actor_id, a2.first_name, a2.last_name
FROM actors1 a1
JOIN actors2 a2 USING (film_id)
WHERE a1.actor_id <> a2.actor_id & a1.film_id = a2.film_id
ORDER BY 1;


-- 2. For each film, list actor that has acted in more films.
-- 2.1 Temp table with film count per actor
CREATE TEMPORARY TABLE film_count_per_actors
SELECT fa.actor_id, a.first_name, a.last_name, COUNT(fa.film_id) as num_of_films
FROM sakila.film_actor fa
JOIN sakila.actor a USING (actor_id)
GROUP BY actor_id;

SELECT * FROM film_count_per_actors;

-- 2.2 CTE with rank -- 2.3 get all cells filtered by rank
WITH actors_rank AS (
SELECT *,
RANK() OVER (PARTITION BY num_of_films ORDER BY num_of_films DESC) as rnk
FROM film_count_per_actors
)
SELECT *
FROM actors_rank
ORDER BY rnk;



