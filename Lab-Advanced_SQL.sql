-- Listing each pair of actors that have worked together

select distinct a3.actor_id as actor_id_1,
 a3.first_name as first_name_1,
 a3.last_name as last_name_1, 
 a4.actor_id as actor_id_2,
 a4.first_name as first_name_2,
 a4.last_name as last_name_2
 
from sakila.film_actor a1

inner join sakila.film_actor a2 
on a1.film_id = a2.film_id
left join sakila.actor a3
on a1.actor_id = a3.actor_id
left join sakila.actor a4 
on a2.actor_id = a4.actor_id
where a1.actor_id < a2.actor_id
order by a3.actor_id asc, a4.actor_id asc;


-- For each film, listing actor that has acted in more films
-- some Tries but not sure if the output is the rigth one
SELECT
    f.title AS film_title,
    a.first_name AS actor_first_name,
    a.last_name AS actor_last_name,
    COUNT(fa.film_id) AS number_of_films
FROM
    sakila.film_actor fa
JOIN
    sakila.film f ON fa.film_id = f.film_id
JOIN
    sakila.actor a ON fa.actor_id = a.actor_id
JOIN (
    SELECT
        film_id,
        actor_id,
        RANK() OVER (PARTITION BY film_id ORDER BY COUNT(*) DESC) AS actor_rank
    FROM
        sakila.film_actor
    GROUP BY
        film_id, actor_id
) ranked_actors ON fa.film_id = ranked_actors.film_id AND fa.actor_id = ranked_actors.actor_id
WHERE
    ranked_actors.actor_rank = 1
GROUP BY
    f.title, a.actor_id, a.first_name, a.last_name;


SELECT
    film.title AS film_title,
    actor.first_name AS actor_first_name,
    actor.last_name AS actor_last_name,
    actor_record.number_of_films
FROM
    sakila.film_actor
JOIN (
    SELECT
        actor_id,
        COUNT(*) AS number_of_films
    FROM
        sakila.film_actor
    GROUP BY
        actor_id
) actor_record ON film_actor.actor_id = actor_record.actor_id
JOIN (
    SELECT
        film_id,
        MAX(number_of_films) AS best_actor_number
    FROM (
        SELECT
            film.film_id,
            actor.actor_id,
            COUNT(*) AS number_of_films
        FROM
            sakila.film_actor
        JOIN sakila.actor ON film_actor.actor_id = actor.actor_id
        JOIN sakila.film ON film_actor.film_id = film.film_id
        GROUP BY
            film.film_id,
            actor.actor_id
    ) film_actor_count
    GROUP BY
        film_id
) film_best_actor ON film_actor.film_id = film_best_actor.film_id
JOIN sakila.film ON film_actor.film_id = film.film_id
JOIN sakila.actor actor ON actor_record.actor_id = actor.actor_id
WHERE
    actor_record.number_of_films = film_best_actor.best_actor_number;


