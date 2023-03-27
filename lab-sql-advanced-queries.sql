 WITH actors_collab AS (SELECT DISTINCT 
                                       CONCAT(a1.first_name, ' ', a1.last_name) AS actor1, 
			                           CONCAT(a2.first_name, ' ', a2.last_name) AS actor2
						FROM sakila.film_actor fa1
                        JOIN sakila.actor a1 ON fa1.actor_id = a1.actor_id
						JOIN sakila.film_actor fa2 ON fa1.film_id = fa2.film_id AND fa1.actor_id < fa2.actor_id
                        JOIN sakila.actor a2 ON fa2.actor_id = a2.actor_id
                        ORDER BY 1
                        )
SELECT 
      *
FROM actors_collab;


WITH film_per_actor AS (SELECT
						      actor_id,
						      count(*) as film_count
					   FROM sakila.film_actor
                       GROUP BY 1
                        ),
film_per_actor_related AS (SELECT
								 f.film_id,
							     f.title,
								 a.first_name,
								 a.last_name,
								 fpa.film_count,
								 RANK() OVER (PARTITION BY film_id ORDER BY fpa.film_count) as rnk
						   FROM sakila.film f
						   JOIN sakila.film_actor fa ON fa.film_id = f.film_id
						   JOIN sakila.actor a ON a.actor_id = fa.actor_id
						   JOIN film_per_actor fpa ON fpa.actor_id = a.actor_id
						    )
SELECT 
      *
FROM film_per_actor_related;