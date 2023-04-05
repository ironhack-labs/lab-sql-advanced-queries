-- 1. List each pair of actors that have worked together.

use sakila;

SELECT 
    CONCAT(a1.first_name, ' ', a1.last_name) AS actor1,
    CONCAT(a2.first_name, ' ', a2.last_name) AS actor2
FROM
    sakila.film_actor fa1
        JOIN
    film_actor fa2 ON fa1.film_id = fa2.film_id
        AND fa1.actor_id < fa2.actor_id
        JOIN
    actor a1 ON fa1.actor_id = a1.actor_id
        JOIN
    actor a2 ON fa2.actor_id = a2.actor_id;

-- or

SELECT DISTINCT
    a1.first_name, a1.last_name, a2.first_name, a2.last_name
FROM
    film_actor fa1
        JOIN
    film_actor fa2 ON fa1.film_id = fa2.film_id
        AND fa1.actor_id < fa2.actor_id
        JOIN
    actor a1 ON fa1.actor_id = a1.actor_id
        JOIN
    actor a2 ON fa2.actor_id = a2.actor_id;

-- 2. For each film, list actor that has acted in more films.

use sakila;
CREATE OR REPLACE VIEW total_films_per_actor AS
    (SELECT 
        a.actor_id,
        a.first_name,
        a.last_name,
        COUNT(*) AS total_films
    FROM
        sakila.film_actor fa
            JOIN
        sakila.actor a ON fa.actor_id = a.actor_id
    GROUP BY 1 , 2);

CREATE OR REPLACE VIEW final_table AS
    (SELECT 
        f.title, ta.first_name, ta.last_name, ta.total_films
    FROM
        sakila.film_actor fa
            JOIN
        sakila.film f ON f.film_id = fa.film_id
            JOIN
        total_films_per_actor ta ON ta.actor_id = fa.actor_id);

create temporary table sakila.total_movies
select 
	*,
	rank() over (partition by title order by total_films desc) as rnk
from final_table;

SELECT 
    *
FROM
    sakila.total_movies
HAVING rnk = 1