use sakila;

-- 1.List each pair of actors that have worked together.
WITH pair_of_actors as (
SELECT CONCAT(actor1.first_name, ' ', actor1.last_name) AS actor1, CONCAT(actor2.first_name, ' ', actor2.last_name) AS actor2
FROM actor AS actor1
JOIN film_actor fa1 USING(actor_id)
JOIN film_actor fa2 ON fa1.film_id = fa2.film_id  AND fa1.actor_id < fa2.actor_id
JOIN actor AS actor2 ON fa2.actor_id = actor2.actor_id
)

select * from pair_of_actors;

-- 2.For each film, list actor that has acted in more films.
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