USE sakila;

# 1. List each pair of actors that have worked together.
WITH collaborating_actors as (
	SELECT
		f1.actor_id,
        concat(a1.first_name,' ', a1.last_name) as actor_1,
		concat(a2.first_name,' ',a2.last_name) as actor_2
	FROM film_actor f1
	JOIN film_actor f2 ON f1.actor_id < f2.actor_id AND f1.film_id = f2.film_id
	LEFT JOIN actor a1 ON a1.actor_id = f1.actor_id
	LEFT JOIN actor a2 ON a2.actor_id = f2.actor_id
	GROUP BY 1,2,3
    ORDER BY 2
	)
SELECT
	actor_1,
    actor_2
FROM collaborating_actors;

# 2. For each film, list actor that has acted in more films.
WITH actor_apperances as (
	SELECT
		actor_id,
		count(*) as films_made
	FROM film_actor fa2
	GROUP BY 1
    ),
actors__apperances_ranked as (
	SELECT
		f.film_id,
        f.title,
        a.actor_id,
        a.first_name,
        a.last_name,
        ac.films_made,
        rank() over (partition by film_id order by films_made desc) as rnk
	FROM film f
    LEFT JOIN film_actor fa USING(film_id)
    LEFT JOIN actor a USING(actor_id)
    LEFT JOIN actor_apperances ac USING(actor_id)
    )
SELECT
	title,
    concat(first_name,' ',last_name),
    films_made
FROM actors__apperances_ranked
WHERE rnk = 1
GROUP BY 1,2,3
;
