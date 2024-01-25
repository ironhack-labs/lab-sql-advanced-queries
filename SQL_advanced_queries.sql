-- 1. List each pair of actors that have worked together
create or replace view  actors_who_palyed_together as
Select distinct concat(C1.first_name, ' ', C1.last_name) as actor1_name, 
                concat(C2.first_name, ' ', C2.last_name) as actor2_name
from sakila.film_actor a1 
join sakila.film_actor a2 on a1.film_id = a2.film_id and a1.actor_id <> a2.actor_id
left join sakila.film B on a1.film_id = B.film_id
left join sakila.actor C1 on a1.actor_id = C1.actor_id
left join sakila.actor C2 on a2.actor_id = C2.actor_id
;

select * from actors_who_palyed_together;


-- 2. For each film, list actor that has acted in more films.

create or replace view cte_count_mov as
with cte_count as (
	select actor_id, 
    count(film_id) as count_movies 
    from film_actor 
    group by actor_id order by count_movies desc) 

select * from cte_count;

select * from cte_count_mov;

create view list_id as
with cte_actor as (
	select film_id, title, fa.actor_id
    from film
    join film_actor fa using(film_id)
    order by title)

select * from cte_actor;

select * from list_id;

with cte_rnk as (
	select *, 
		rank() over(partition by film_id order by cte.count_movies desc) as rnk
		from list_id l
		join cte_count_mov cte using(actor_id))

select film_id, title, actor_id, concat(a.first_name," ", a.last_name) as Actor_Name, count_movies  
		from cte_rnk r 
        join actor a using(actor_id) 
        where rnk=1;
