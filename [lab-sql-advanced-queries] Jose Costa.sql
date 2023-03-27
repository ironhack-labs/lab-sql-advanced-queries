# 1. List each pair of actors that have worked together.
use sakila;

with cte_actors as (
	SELECT fa1.film_id, a1.actor_id as actor1, a1.first_name as actor1_1st_name, a1.last_name as actor1_last_name, 
		   a2.actor_id as actor2, a2.first_name as actor2_1st_name, a2.last_name as actor2_last_name
	FROM film_actor fa1
	JOIN film_actor fa2 ON fa1.film_id = fa2.film_id AND fa1.actor_id < fa2.actor_id
	JOIN actor a1 ON fa1.actor_id = a1.actor_id
	JOIN actor a2 ON fa2.actor_id = a2.actor_id
	ORDER BY actor1_1st_name)

select * from cte_actors;

# 2. For each film, list actor that has appeared in the most films.   cte with rank, get all cols filter by rank
create view cte_count_mov as
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

