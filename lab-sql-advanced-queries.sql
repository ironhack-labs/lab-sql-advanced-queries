#all pairs of actors that have worked together
select a1.actor_id, a2.actor_id from sakila.film_actor a1 
inner join sakila.film_actor a2 on a1.film_id = a2.film_id
and a1.actor_id < a2.actor_id
group by a1.actor_id, a2.actor_id
order by a1.actor_id, a2.actor_id asc;

#number of films by actor
select actor_id, count(film_id) as nr_films_by_actor from sakila.film_actor group by actor_id;

#film, actor and number of films by actor
with cte_actor as 
(select actor_id, count(film_id) as nr_films_by_actor from sakila.film_actor group by actor_id)
select a.film_id, a.actor_id, nr_films_by_actor from sakila.film_actor a left join cte_actor ct 
on a.actor_id = ct.actor_id;

#by film, listing actors who appeared in more films
select * from(
select film_id, actor_id, 
rank() over (partition by film_id order by nr_films_by_actor desc) as nr_films_rank from
(with cte_actor as 
(select actor_id, count(film_id) as nr_films_by_actor from sakila.film_actor group by actor_id)
select a.film_id, a.actor_id, nr_films_by_actor from sakila.film_actor a left join cte_actor ct 
on a.actor_id = ct.actor_id) sub1) sub2
where nr_films_rank=1;