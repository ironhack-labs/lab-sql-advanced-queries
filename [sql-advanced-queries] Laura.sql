-- 1. List each pair of actors that have worked together.
with actor_pairs as (
    select a1.actor_id as a1_actor_id, 
		a1.first_name as a1_first_name, 
        a1.last_name as a1_last_name, 
        fa.film_id, f.title
    from sakila.actor as a1
    left join sakila.film_actor as fa
    on a1.actor_id = fa.actor_id
    left join sakila.film as f
    on fa.film_id = f.film_id
)
select ap.film_id, ap.title, ap.a1_actor_id, ap.a1_first_name, ap.a1_last_name, 
a2_actor.actor_id as a2_actor_id,
a2_actor.first_name as a2_first_name,
a2_actor.last_name as a2_last_name
from actor_pairs as ap
inner join sakila.film_actor as a2
on ap.film_id = a2.film_id
and ap.a1_actor_id <> a2.actor_id
inner join sakila.actor as a2_actor on a2.actor_id = a2_actor.actor_id
;

-- 2. For each film, list actor that has acted in the most films.
with cte_count as (
select  fa1.film_id, f.title, a.actor_id, a.first_name, a.last_name, fa2.movie_count
from sakila.actor as a
left join sakila.film_actor as fa1
on a.actor_id = fa1.actor_id
left join sakila.film as f
on fa1.film_id = f.film_id
inner join (
	select actor_id, count(film_id) as movie_count
    from sakila.film_actor
    group by 1
    ) as fa2
on fa1.actor_id = fa2.actor_id
order by 1 asc
)

select film_id, title, actor_id, first_name, last_name, movie_count
from (
	select film_id, title, actor_id, first_name, last_name, movie_count,
    rank() over (partition by film_id order by movie_count desc) as rnk
    from cte_count
) as ranked
where rnk = 1
;
