-- Lab | SQL Advanced queries

-- List each pair of actors that have worked together.

WITH actor_pairs AS (
    SELECT 
        fa1.actor_id AS actor1_id, 
        fa2.actor_id AS actor2_id
    FROM 
        sakila.film_actor fa1
        JOIN sakila.film_actor fa2 ON fa1.film_id = fa2.film_id AND fa1.actor_id < fa2.actor_id
)
SELECT 
    ap.actor1_id, 
    a1.first_name AS actor1_first_name, 
    a1.last_name AS actor1_last_name, 
    ap.actor2_id, 
    a2.first_name AS actor2_first_name, 
    a2.last_name AS actor2_last_name
FROM 
    actor_pairs ap
    JOIN sakila.actor a1 ON ap.actor1_id = a1.actor_id
    JOIN sakila.actor a2 ON ap.actor2_id = a2.actor_id
ORDER BY 
    actor1_first_name;


-- For each film, list actor that has acted in more films.

-- 1. temporary table with film count per actor
-- 2. CTE with rank
-- 3. get all columns, filter by rank

WITH cte_film_actor AS (
  SELECT fa.actor_id, COUNT(f.film_id) AS num_films,
         RANK() OVER (PARTITION BY fa.actor_id ORDER BY COUNT(f.film_id) DESC) AS rnk
  FROM sakila.film_actor fa
  JOIN sakila.film f ON f.film_id = fa.film_id
  GROUP BY fa.actor_id
)
SELECT f.title AS film_title, CONCAT(a.first_name, ' ', a.last_name) AS actor_name
FROM sakila.film f
JOIN sakila.film_actor fa ON fa.film_id = f.film_id
JOIN cte_film_actor cfa ON cfa.actor_id = fa.actor_id
JOIN sakila.actor a ON a.actor_id = cfa.actor_id
WHERE cfa.rnk = 1;