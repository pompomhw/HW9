use sakila;

select first_name, last_name from actor; -- 1a)
select upper(concat(first_name,' ',last_name)) as Actor_Name from actor;  -- 1b)
-----------------------------------------------------------------------------
select actor_id, first_name, last_name from actor where first_name='Joe'; -- 2a)
select last_name from actor where last_name like '%GEN%'; -- 2b)
select first_name, last_name from actor
  where last_name like '%LI%' 
  order by last_name, first_name; -- 2c) 
select country_id,country from country 
  where country in ('Afghanistan','Bangladesh','China'); -- 2d)
------------------------------------------------------------------------------- 
alter table  actor add description blob;  -- 3a)
alter table  actor drop description;  -- 3b)
----------------------------------------------------------------------------
select last_name, count(last_name) as _count from actor  
  group by last_name;                    -- 4a)
select last_name, count(last_name) as _count from actor  
  group by last_name having _count>1;    -- 4b)  
update actor set first_name='HARPO' 
  where first_name='GROUCHO' and last_name='WILLIAMS';  -- 4c)
update actor set first_name='GROUCHO' 
  where first_name='HARPO' and last_name='WILLIAMS';    -- 4d)
----------------------------------------------------------------------
show create table address; -- 5a)
----------------------------------------------------------------------
select s.first_name, s.last_name, a.address from staff s 
  join address a on s.address_id=a.address_id;   -- 6a)
  
select first_name, last_name, sum(amount) as total_amt 
  from staff s join payment p on p.staff_id=s.staff_id
  where payment_date like ('2005-08-%')
  group by last_name;   -- 6b)

select title, count(actor_id) as 'number of actors'
  from film_actor fa inner join film f on fa.film_id=f.film_id
  group by title;  -- 6c)
 
select  count(i.film_id) as 'number of copies'
  from inventory i inner join film f on i.film_id=f.film_id
  where title='Hunchback Impossible'; -- 6d)

select first_name, last_name,sum(amount) as 'Total Amount Paid'
  from customer c 
  join payment p on c.customer_id=p.customer_id
  group by c.customer_id
  order by last_name;  -- 6e)
------------------------------------------------------------------------   
select title from film 
  where language_id in (
	select language_id from language
    where (title like 'K%' or title like 'Q%') and language_id=1
    );  -- 7a) 
    
select upper(concat(first_name,' ',last_name)) as Actor_Name 
  from actor where actor_id in (
    select actor_id from film_actor where film_id in (
      select film_id from film 
	  where title='Alone Trip')); -- 7b) 
   
  select upper(concat(first_name,' ',last_name)) as customer_name, email
  from customer cu 
    join address a on cu.address_id=a.address_id
    join city ci on a.city_id=ci.city_id
    join country cr on ci.country_id=cr.country_id
    where country='Canada';  -- 7c) 
  
  select title
  from film f
    join film_category fc on f.film_id=fc.film_id
    join category ca on fc.category_id=ca.category_id
    where name='family';  -- 7d)
  
  select title, count(title) as rental_frequencies
  from film f
    join inventory i on f.film_id=i.film_id
    join rental r on i.inventory_id=r.inventory_id
    group by title
    order by count(title) desc; -- 7e)
  
  select s.store_id, sum(amount) as total_business
  from store s
	join staff sf on s.store_id=sf.store_id
    join payment p on sf.staff_id=p.staff_id
    group by s.store_id;   -- 7f)
  
  select s.store_id, city, country
  from store s 
    join address a on s.address_id=a.address_id
    join city ci on a.city_id=ci.city_id
    join country cr on ci.country_id=cr.country_id;  -- 7g)
  
  select cg.name as genre, sum(amount) as gross_revenue
  from category cg 
    join film_category fc on cg.category_id=fc.category_id
	join inventory i on fc.film_id=i.film_id
	join rental r on i.inventory_id=r.inventory_id
	join payment p on r.rental_id=p.rental_id
	group by cg.name
	order by sum(amount) desc limit 5;   -- 7h)
------------------------------------------------------------------ 
 create view top_five_genres as
  select cg.name as genre, sum(amount) as gross_revenue
  from category cg 
    join film_category fc on cg.category_id=fc.category_id
    join inventory i on fc.film_id=i.film_id
    join rental r on i.inventory_id=r.inventory_id
    join payment p on r.rental_id=p.rental_id
    group by cg.name
    order by sum(amount) desc limit 5;-- 8a)
  
 select * from top_five_genres;   -- 8b)
 drop view top_five_genres;   -- 8c)

                    