-- List each pair of actors that have worked together.

select distinct s1.first_name, s1.last_name, s2.first_name, s2.last_name
from sakila.film_actor f1
inner join sakila.actor s1
on f1.actor_id = s1.actor_id
inner join sakila.film_actor f2
on f1.film_id = f2.film_id
inner join sakila.actor s2
on f2.actor_id = s2.actor_id
where f1.actor_id > f2.actor_id;

-- I used the DISTINCT to avoid repeated pairs, since many actors worked together in more than 1 film 

-- For each film, list actor that has acted in more films. 

with actors_films as (
select f.title, a.actor_id, a2.first_name, a2.last_name, a.film_id 
from sakila.film_actor a 
left join sakila.film f 
on a.film_id = f.film_id
left join sakila.actor a2
on a2.actor_id = a.actor_id 
group by f.title, a.actor_id, a2.first_name, a2.last_name, a.film_id
),films_count as (
select b.actor_id, count(b.film_id) as films_played 
from sakila.film_actor b
group by b.actor_id)
select * from (
select t.film_id, t.title, t.actor_id, t.first_name, t.last_name,
rank() over (partition by film_id order by films_played desc) as ranked
from actors_films t
inner join films_count c
on t.actor_id = c.actor_id)d
where ranked =1;
