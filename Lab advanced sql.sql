select * from sakila.actor;

with actor_pairs as (
   select
        fa1.actor_id as 'actor1_id', 
        fa2.actor_id as 'actor2_id'
    from sakila.film_actor fa1
        inner join sakila.film_actor fa2 on fa1.film_id = fa2.film_id and fa1.actor_id < fa2.actor_id
)
select 
    ap.actor1_id, 
    a1.first_name as 'actor1_name', 
    ap.actor2_id, 
    a2.first_name as 'actor2_name'
from
    actor_pairs ap
    inner join sakila.actor a1 on ap.actor1_id = a1.actor_id
    inner join sakila.actor a2 on ap.actor2_id = a2.actor_id
order by 1, 3 asc;


select * from sakila.film;
select * from sakila.actor; 

with cte_film_actor as (
  select fa.actor_id, count(f.film_id) as num_films,
         rank() over (partition by fa.actor_id order by count(f.film_id) desc) as 'rank'
  from sakila.film_actor fa
 inner join sakila.film f on f.film_id = fa.film_id
  group by fa.actor_id
)
select f.title as film_title, concat(a.first_name, ' ', a.last_name) as 'actor_name'
from sakila.film f
inner join sakila.film_actor fa on fa.film_id = f.film_id
inner join cte_film_actor cfa ON cfa.actor_id = fa.actor_id
inner join sakila.actor a on a.actor_id = cfa.actor_id
where cfa.rank = 1
order by 1, 2 asc;

