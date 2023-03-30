-- 1. List each pair of actors that have worked together.
SELECT a.first_name, a.last_name, b.first_name, b.last_name
from sakila.actor a
JOIN sakila.film_actor fa ON a.actor_id = fa.actor_id
JOIN sakila.film_actor fb ON fa.film_id = fb.film_id
JOIN sakila.actor b ON fb.actor_id = b.actor_id
WHERE a.actor_id <> b.actor_id;



-- 2. For each film, list actor that has acted in more films.

USE sakila;

create or replace view total_films_actor as (
SELECT a.actor_id, a.first_name, a.last_name, count(fa.film_id) as total_films
FROM sakila.actor a
JOIN sakila.film_actor fa ON fa.actor_id = a.actor_id
GROUP BY a.actor_id, a.first_name);

WITH actor_with_more_films_for_each_film as(
SELECT f.film_id,f.title,ta.actor_id,ta.first_name,ta.last_name, ta.total_films
FROM sakila.film f
JOIN sakila.film_actor fa ON f.film_id = fa.film_id
JOIN total_films_actor ta ON fa.actor_id = ta.actor_id
GROUP BY 1,2,3,4,5,6)


SELECT t.rk,t.title,t.first_name,t.last_name,t.total_films
FROM ( 
SELECT
rank() over(partition by title order by total_films desc) as rk,
title, 
first_name, 
last_name, 
total_films
FROM actor_with_more_films_for_each_film) t
WHERE rk = 1
;


