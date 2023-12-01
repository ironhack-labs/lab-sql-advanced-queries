-- 1. List each pair of actors that have worked together.
create table sakila.actor_film
select fa.actor_id, fa.film_id, concat(first_name, ' ', last_name) as actor_name from sakila.film_actor fa
left join sakila.actor a
on fa.actor_id = a.actor_id;

select distinct af1.actor_id as actor_1, af1.actor_name, af2.actor_id as actor_2, af2.actor_name, af1.film_id
from sakila.actor_film af1
inner join sakila.actor_film af2
on af1.film_id = af2.film_id 
and af1.actor_id <> af2.actor_id
order by 1,4;

-- 2. For each film, list actor that has acted in more films.

with cte_count as (
	select  fa1.film_id, f.title, a.actor_id, a.first_name, a.last_name, fa2.film_count
	 from sakila.actor as a
	 left join sakila.film_actor as fa1
	 on a.actor_id = fa1.actor_id
	 left join sakila.film as f
	 on fa1.film_id = f.film_id
	 inner join (
		select actor_id, count(film_id) as film_count
		 from sakila.film_actor
		 group by 1
		 ) as fa2
	 on fa1.actor_id = fa2.actor_id
	 order by 1 asc
 )
 select film_id, title, actor_id, concat(first_name,' ',last_name) as full_name, film_count
 from (
 	select film_id, title, actor_id, first_name, last_name, film_count,
     rank() over (partition by film_id order by film_count desc) as ranking
     from cte_count
 ) sub_rank
 where ranking = 1
 ;
