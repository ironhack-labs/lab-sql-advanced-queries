# 1 - List each pair of actors that have worked together.

select f1.film_id, concat(a1.first_name, ' ', a1.last_name) as actor1, 
	concat(a2.first_name, ' ', a2.last_name) as actor2
from sakila.film_actor f1
join sakila.film_actor f2 on f1.film_id = f2.film_id and f1.actor_id <> f2.actor_id
join actor a1 on f1.actor_id = a1.actor_id
join actor a2 on f2.actor_id = a2.actor_id
order by 1
;

# 2 For each film, list actor that has acted in more films.

with cte_film_actor as (
select 
	actor_id, count(film_id) as films
from sakila.film_actor
group by actor_id
    ),
cte_appearences as (
select f.film_id, f.title, fa.actor_id,a.first_name,a.last_name, films,
rank() over(partition by film_id order by films desc) as rnk
from sakila.film f
join film_actor fa on f.film_id = fa.film_id
join actor a on a.actor_id = fa.actor_id
join cte_film_actor ct on ct.actor_id = a.actor_id 
)
select title, films,concat(first_name, ' ',last_name) as Name
from cte_appearences
where rnk =1
group by 1,2,3 ;






