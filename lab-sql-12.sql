use sakila;

-- 1

SELECT DISTINCT CONCAT(a1.first_name, ' ', a1.last_name) AS actor1, 
                CONCAT(a2.first_name, ' ', a2.last_name) AS actor2
FROM actor a1
JOIN film_actor fa1 ON a1.actor_id = fa1.actor_id
JOIN film f1 ON f1.film_id = fa1.film_id
JOIN film_actor fa2 ON f1.film_id = fa2.film_id
JOIN actor a2 ON fa2.actor_id = a2.actor_id
WHERE a1.actor_id < a2.actor_id;

-- 2

SELECT fa.film_id, MAX(fa.actor_id) as actor_id
FROM film_actor fa
JOIN (
    SELECT film_id, actor_id, COUNT(*) as actor_count 
    FROM film_actor 
    GROUP BY film_id, actor_id
) fa_count ON fa.film_id = fa_count.film_id AND fa.actor_id = fa_count.actor_id
GROUP BY fa.film_id
ORDER BY fa.film_id;

