-- 1. List each pair of actors that have worked together.
with actor_pairs as (
select a1.actor_id as p1_actor_id, a1.first_name as p1_first_name, a1.last_name as p1_last_name, fa.film_id, f.title
from sakila.actor as a1
left join sakila.film_actor as fa
on a1.actor_id = fa.actor_id
left join sakila.film as f
on fa.film_id = f.film_id)
select ap.film_id, ap.title, ap.p1_actor_id, ap.p1_first_name, ap.p1_last_name, fa2.actor_id as p2_actor_id, a.first_name as p2_first_name, a.last_name as p2_last_name
from actor_pairs as ap
inner join sakila.film_actor as fa2
on ap.film_id = fa2.film_id
and ap.p1_actor_id <> fa2.actor_id
inner join sakila.actor as a 
on fa2.actor_id = a.actor_id
;



-- 2. For each film, list actor that has acted in more films. in every film, give me the actor that participated in the most film

with cte_count as (
select  fa.film_id, f.title, a.actor_id, a.first_name, a.last_name, fa1.movie_count
from sakila.actor as a
left join sakila.film_actor as fa
on a.actor_id = fa.actor_id
left join sakila.film as f
on fa.film_id = f.film_id
inner join (
	select actor_id, count(film_id) as movie_count
    from sakila.film_actor
    group by 1
    ) as fa1
on fa.actor_id = fa1.actor_id
order by 1 asc
)
select film_id, title, actor_id, first_name, last_name, movie_count
from (
	select film_id, title, actor_id, first_name, last_name, movie_count,
    rank() over (partition by film_id order by movie_count desc) as ranking
    from cte_count
) as ranked
where ranking = 1
;


