use sakila;
-- List each pair of actors that have worked together.
WITH cte_actors AS (
  SELECT actor_id, CONCAT(first_name, ' ', last_name) AS actor_name
  FROM sakila.actor
)
SELECT DISTINCT a1.actor_name, a2.actor_name
FROM cte_actors a1
JOIN sakila.film_actor fa1 ON a1.actor_id = fa1.actor_id
JOIN sakila.film_actor fa2 ON fa1.film_id = fa2.film_id
JOIN cte_actors a2 ON fa2.actor_id = a2.actor_id AND a1.actor_id != a2.actor_id;

-- For each film, list actor that appeared in that film that has appeared in the most films overall.
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

