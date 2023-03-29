-- Instructions

-- 1. List each pair of actors that have worked together.

SELECT a.first_name, a.last_name, b.first_name, b.last_name
FROM sakila.actor a
JOIN sakila.film_actor fa ON a.actor_id = fa.actor_id
JOIN sakila.film_actor fb ON fa.film_id = fb.film_id
JOIN sakila.actor b ON fb.actor_id = b.actor_id
WHERE a.actor_id <> b.actor_id;


-- 2. For each film, list actor that has acted in more films.
use sakila;
create or replace view total_films_per_actor as(
SELECT a.actor_id,a.first_name, a.last_name, COUNT(*) AS total_films
FROM sakila.film_actor fa
join sakila.actor a on fa.actor_id = a.actor_id
group by 1,2
);

create or replace view final_table as (
SELECT f.title, ta.first_name, ta.last_name, ta.total_films
FROM sakila.film_actor fa
JOIN sakila.film f ON f.film_id = fa.film_id
JOIN total_films_per_actor ta ON ta.actor_id = fa.actor_id
);

create temporary table sakila.total_movies
select 
	*,
	rank() over (partition by title order by total_films desc) as rnk
from final_table;

select * from sakila.total_movies
having rnk = 1






