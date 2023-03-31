use bank;
with cte_loan as (
select * from bank.loan)
select * from cte_loan
where status = 'B';

with cte_transactions as (
select account_id, sum(amount), sum(balance)
from bank.trans
group by 1)
select * from cte_transactions ct
join bank.account a 
using (account_id);

with cte_transactions as (    -- cte is like a temporary table that is not saved anywhere but returns the result
select account_id, sum(amount), sum(balance)
from bank.trans
group by 1),
cte_account as (
select * from cte_transactions ct
join bank.account a 
using (account_id))
select * from cte_account;

-- use cte to display the first account opened by a district
with first_account_opened as (
select d.a2 as disctrict_name, a.account_id as account_id,
rank() over (partition by district_id order by date) as rnk
from bank.account a
join bank.district d on a.district_id = d.a1)
select * from first_account_opened where rnk = 1; 

create view running_contract_ok_balances as -- creates subsets of data to only some people to view
with cte_running_contract_OK_balances as (  -- it can be used when you have confidential data that shouldn´t be available to everyone
select *, amount-payments as Balance        -- it gets stored on views
from bank.loan
where status = 'C'
order by Balance)
select * from cte_running_contract_OK_balances limit 20;

select * from running_contract_ok_balances;

drop view running_contract_ok_balances; -- this drops the view that was created. only runs one time.
drop view if exists running_contract_ok_balances; -- this avoids the error of running more than once - use this

create view customer_status_D as -- also gives error if you run more than once because already exists
select * from bank.loan
where status = 'D'
with check option;

create or replace view customer_status_D as -- this avoids the error because it overwrites the view created when you run again
select * from bank.loan
where status = 'D'
with check option; -- it checks if all status is D - it prevents someone from adding bad data in the view

select * from customer_status_D;

insert into customer_status_D values (0000,00000,987301,00000,60,00000,'C'); -- does not run because the status is not checked as D 

select * from bank.loan l1
where amount > (
select avg (amount) -- this creates one table with the avg amount and compares it with the plain table
from bank.loan l2
where l1.status = l2.status)
order by amount desc
limit 10;

select * from bank.loan l1
where amount > (
select avg (amount)
from bank.loan l2
where l1.account_id = l2.account_id) -- does the same comparing account id
order by amount desc
limit 10;

use bank;

create or replace view user_activity as
select account_id, convert(date, date) as Activity_date,
date_format(convert(date,date), '%M') as Activity_Month,
date_format(convert(date,date), '%m') as Activity_Month_number,
date_format(convert(date,date), '%Y') as Activity_year
from bank.trans;

-- Checking the results
select * from bank.user_activity;
-- month on month = variation on a monthly basis
create or replace view bank.monthly_active_users as
select Activity_year, Activity_Month, Activity_Month_number, count(account_id) as Active_users
from bank.user_activity
group by 1,2,3
order by 1,3;

with cte_view as(
select Activity_year, Activity_Month, Activity_Month_number, Active_users,
lag(Active_users,1) over(  -- returns the value of active users on the row bellow for last month, so it can be compared
	order by Activity_year, Activity_Month_number) as Last_month
from monthly_active_users)

select *, (Active_users - Last_month)/Active_users * 100 as diff -- this returns the difference in percentage
from cte_view;

-- customer retention - how many customers keep using the service
-- churn rate - how many customers stoped using the service 

create or replace view bank.distinct_users as
select distinct
	date_format(convert(d1.Activity_date, date), '%Y-%m-01') as Activity_month,
    d1.account_id from bank.user_activity d1;

select Activity_Month, count(distinct account_id) as retained_customers 
from distinct_users
group by 1
order by 1;

select * from distinct_users d1
left join distinct_users d2
on d1.account_id = d2.account_id
and d2.Activity_Month = date_add(d1.Activity_Month, interval 1 month) -- this gets the activity for this 3 ids on may and june, so we can see customers
where d1.account_id in (5,6,7) and d1.Activity_Month = '1997-05-01'; -- retained or lost

create or replace view retained_customers as
select d2.Activity_Month, count(distinct d1.account_id) as retained_customers
from distinct_users d1
join distinct_users d2
on d1.account_id = d2.account_id
and d2.Activity_Month = date_add(d1.Activity_Month, interval 1 month) 
group by 1
order by 1,2;

select *, lag(Retained_customers,1) over () as lagged,
(Retained_customers - lag(Retained_customers,1) over ()) / Retained_customers * 100 as diff -- brings the difference of retained/lagged in %
from retained_customers;

select avg(amount) from bank.order;

select * from bank.order where amount > 3280;

select * from bank.order 
where amount > (select avg(amount)from bank.order);

select a.* from bank.account a
join bank.order o on a.account_id = o.account_id
where o.k_symbol = 'SIPO';
-- this makes the same thing one with join and the oder with subqueries
select * from bank.account
where account_id in (
	select distinct account_id from bank.order
    where k_symbol = 'SIPO');
-- sql reads joins easierly, but if the table is very big, use subs
-- you can put subs in the select statement, from statement and where statement
    


