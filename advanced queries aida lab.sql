-- 1 List each pair of actors that have worked together.
-- 2 For each film, list actor that has acted in more films.

use sakila;

-- 1
SELECT 
    CONCAT(a1.first_name, ' ', a1.last_name) AS 'ACTOR 1',
    CONCAT(a2.first_name, ' ', a2.last_name) AS 'ACTOR 2'
FROM 
    sakila.film_actor AS fa1
JOIN sakila.film_actor AS fa2 ON fa1.film_id = fa2.film_id AND fa1.actor_id < fa2.actor_id
JOIN sakila.actor AS a1 ON fa1.actor_id = a1.actor_id
JOIN sakila.actor AS a2 ON fa2.actor_id = a2.actor_id
LIMIT 2; 

-- 2
SELECT
  actor_id,
  COUNT(film_id) AS num_films,
  RANK() OVER (ORDER BY COUNT(film_id) DESC) AS actor_rank
FROM
  film_actor
GROUP BY
  actor_id
ORDER BY
  actor_rank;
