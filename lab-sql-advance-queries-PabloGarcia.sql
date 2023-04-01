-- 1. List each pair of actors (concatenate name and surname) that have worked together.
CREATE VIEW pair_of_actors AS
SELECT CONCAT(a1.first_name, ' ', a1.last_name) as Actor_1, 
       CONCAT(a2.first_name, ' ', a2.last_name) as Actor_2
FROM film_actor fa1
JOIN film_actor fa2 ON fa1.film_id = fa2.film_id AND fa1.actor_id < fa2.actor_id
JOIN actor a1 ON fa1.actor_id = a1.actor_id
JOIN actor a2 ON fa2.actor_id = a2.actor_id
ORDER BY a1.first_name;
SELECT * FROM pair_of_actors;

-- 2. For each film, list actor that appeared in that film that has appeared in the most films overall. film_id, actor_id that appeared
-- Step 1: Temp table with film count per actor


-- Step2: CTE with rank
-- WITH film_count_rank AS (SELECT actor_id, film_count, rank() OVER (ORDER BY film_count DESC) as rnk FROM film_count)
-- SELECT * FROM film_count_rank;

-- Step 3: Get all cols filter by rank. For each film, list actor that appeared in that film that has appeared in the most films overall
CREATE TEMPORARY TABLE film_count
SELECT actor_id, COUNT(film_id) as film_count 
FROM sakila.film_actor
GROUP BY actor_id;
WITH film_count_rank AS (
  SELECT actor_id, film_count, RANK() OVER (ORDER BY film_count DESC) AS rnk
  FROM film_count
)
SELECT B.title, C.first_name, C.last_name FROM sakila.film_actor A
JOIN sakila.film B USING(film_id)
JOIN sakila.actor C USING(actor_id)
WHERE actor_id = (SELECT actor_id FROM film_count_rank WHERE rnk = (SELECT MAX(rnk) FROM film_count_rank))
ORDER BY B.title;