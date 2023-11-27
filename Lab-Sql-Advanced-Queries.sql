-- 1) Listing each pair of actors that have worked together
select distinct a3.actor_id as actor_id_1, a3.first_name as first_name_1, a3.last_name as last_name_1, a4.actor_id as actor_id_2, a4.first_name as first_name_2, a4.last_name as last_name_2
from sakila.film_actor a1
inner join sakila.film_actor a2 on a1.film_id = a2.film_id
left join sakila.actor a3 on a1.actor_id = a3.actor_id
left join sakila.actor a4 on a2.actor_id = a4.actor_id
where a1.actor_id < a2.actor_id
order by a3.actor_id asc, a4.actor_id asc;

-- 2) For each film, listing actor that has acted in more films
-- Some films there is a tie in the actores with more films. In that case I showed both actors.
select film.title as film_title, actor.first_name as actor_first_name, actor.last_name as actor_last_name, actor_record.number_of_films
from sakila.film_actor film_actor
left join (
select actor_id, count(*) as number_of_films
from sakila.film_actor
group by actor_id) actor_record on film_actor.actor_id = actor_record.actor_id
left join (
select film.film_id, max(record.number_of_films) as best_actor_number
from sakila.actor_record record
left join sakila.film_actor film on film.actor_id = record.actor_id
group by film.film_id
order by film.film_id) film_best_actor on film_actor.film_id = film_best_actor.film_id
left join sakila.film film on film_actor.film_id = film.film_id
left join sakila.actor actor on actor_record.actor_id = actor.actor_id
where actor_record.number_of_films = film_best_actor.best_actor_number;