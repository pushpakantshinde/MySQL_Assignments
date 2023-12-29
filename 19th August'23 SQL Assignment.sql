create database inueron_assignments;

use inueron_assignments;

create table city (
id int,
`name` varchar(17),
countrycode varchar(3), 
district varchar(20), 
population int);

select * from city;

describe city;

select count(*) from city;

# Q1
select * from city where countrycode = "USA" and population>100000;


# Q2
select * from city where countrycode = "USA" and population>120000;


# Q3
select * from city;


# Q4
select * from city where id = 1661;


# Q5
select * from city where countrycode = "JPN";


# Q6
select name from city where countrycode = "JPN";


create table station(
id int,
city varchar(21), 
state varchar(2), 
lat_n int, 
long_w int);

describe station;

# Q7
select city, state from station;


# Q8
select distinct city from station where id%2 = 0;


# Q9
select (count(city) - count(distinct city)) as 'city_count-dist_city_count' from station;


# Q10
(select city, length(city) as length
from station
order by length(city) asc, city asc limit 1)

union

(select city, length(city) as length
from station
order by length(city) desc, city asc limit 1);


# Q11
select distinct city from station where left(city,1) in ('a', 'e', 'i', 'o', 'u');


# Q12
select distinct city from station where right(city,1) in ('a', 'e', 'i', 'o', 'u');


# Q13
select distinct city from station where left(city,1) not in ('a', 'e', 'i', 'o', 'u');


# Q14
select distinct city from station where right(city,1) not in ('a', 'e', 'i', 'o', 'u');


# Q15
select distinct city from station where (left(city,1) not in ('a', 'e', 'i', 'o', 'u')) or right(city,1) not in ('a', 'e', 'i', 'o', 'u');


# Q16
select distinct city from station where (left(city,1) not in ('a', 'e', 'i', 'o', 'u')) and right(city,1) not in ('a', 'e', 'i', 'o', 'u');


# Q17
create table Product
(product_id int,
product_name varchar(20),
unit_price int,
primary key(product_id));

create table Sales
(seller_id int,
product_id int,
buyer_id int,
sale_date date,
quantity int,
price int,
foreign key(product_id) references Product(product_id));

insert into Product values (1, 'S8', 1000), (2, 'G4', 800), (3, 'iphone', 1400);
insert into Sales values (1, 1, 1, '2019-01-21', 2, 2000), (1, 2, 2, '2019-02-17', 1, 800), (2, 2, 3, '2019-06-02', 1, 800), (3, 3, 4, '2019-05-13', 2, 2800);

# Q17 solution 1

select p.product_id, p.product_name 
FROM Product as p 
INNER JOIN Sales as s on p.product_id = s.product_id
where s.sale_date >= '2019-01-01' and s.sale_date <= '2019-03-31'
and p.product_id not in
(select p.product_id 
FROM Product as p 
INNER JOIN Sales as s on p.product_id = s.product_id
where s.sale_date < '2019-01-01' or s.sale_date > '2019-03-31');

# Q17 solution 2
select p.product_id, p.product_name 
FROM Product as p 
INNER JOIN Sales as s on p.product_id = s.product_id
where s.sale_date >= '2019-01-01' and s.sale_date <= '2019-03-31'
and p.product_id not in
(select product_id 
FROM Sales as s 
where s.sale_date < '2019-01-01' or s.sale_date > '2019-03-31');


# Q18
select distinct author_id 
from views 
where author_id = viewer_id 
order by author_id asc;


# Q19
select round(
(select count(*) 
from delivery 
where order_date = customer_pref_delivery_date)/count(*)*100,2) as immediate_percentage 
from delivery;


# Q20
select t.ad_id, (case when base != 0 then round(t.num/t.base*100,2) else 0 end) as Ctr 
from (
select ad_id, sum( case when action = 'clicked' or action = 'viewed' then 1 else 0 end) as base, sum( case when action = 'clicked' then 1 else 0 end) as num 
from ads 
group by ad_id)t 
order by Ctr desc, t.ad_id asc;


# Q21
select employee_id, count(team_id) over (partition by team_id) as team_size 
from employee
order by employee_id;


# Q22
select c.country_name, 
case when avg(weather_state) <= 15 then 'Cold' 
when avg(weather_state) >= 25 then 'Hot' 
else 'Warm' end as weather_state 
from countries c 
left join weather w on c.country_id = w.country_id 
where month(day) = 11 
group by c.country_name;


# Q23
select p.product_id, round(sum(u.units*p.price)/sum(u.units),2) as average_price 
from prices p 
left join unitssold u on p.product_id = u.product_id 
where u.purchase_date >= start_date and u.purchase_date <= end_date 
group by product_id 
order by product_id;


# Q24
select t.player_id, event_date as first_login 
from 
(select player_id, event_date, row_number() over(partition by player_id order by event_date) as num 
from activity)t 
where t.num = 1;


# Q25
select t.player_id, t.device_id 
from 
(select player_id, device_id, row_number() over(partition by player_id order by event_date) as num 
from activity)t 
where t.num = 1;


# Q26
select p.product_name, sum(o.unit) as unit 
from Products p 
left join Orders o on p.product_id = o.product_id 
where month(o.order_date) = 2 and year(o.order_date) = 2020 
group by p.product_id 
having unit >= 100;


# Q27
select user_id, name, mail 
from Users 
where mail regexp '^[a-zA-Z]+[a-zA-Z0-9_\.\-]*@leetcode[\.]com' 
order by user_id;


# Q28
select t.customer_id, t.name 
from 
(select c.customer_id, c.name, 
sum(case when month(o.order_date) = 6 and year(o.order_date) = 2020 then p.price*o.quantity else 0 end) as june_spent, 
sum(case when month(o.order_date) = 7 and year(o.order_date) = 2020 then p.price*o.quantity else 0 end) as july_spent 
from Orders o 
left join Product p on o.product_id = p.product_id 
left join Customers c on o.customer_id = c.customer_id 
group by c.customer_id) t 
where june_spent >= 100 and july_spent >= 100;


# Q29
select c.Title 
from Content c 
left join TVProgram t on c.content_id = t.content_id 
where c.Kids_content = 'Y' and c.content_type = 'Movies' and month(t.program_date) = 6 and year(t.program_date) = 2020;


# Q30
select q.*, coalesce(n.Npv,0) as Npv 
from Queries q 
left join NPV n on q.Id = n.Id and q.Year = n.Year;


# Q31
select q.*, coalesce(n.Npv,0) as Npv 
from Queries q 
left join NPV n on q.Id = n.Id and q.Year = n.Year;


# Q32
select u.unique_id, e.name 
from employees e 
left join employeeUNI u on e.id = u.id;


# Q33
select u.name, coalesce(sum(r.distance),0) as travelled_distance 
from users u 
left join rides r on u.id = r.user_id 
group by u.name 
order by travelled_distance desc, u.name;


# Q34
select p.product_name, sum(o.unit) as unit 
from Products p 
left join Orders o on p.product_id = o.product_id
where month(o.order_date) = 2 and year(o.order_date) = 2020 
group by p.product_id 
having unit >= 100;


# Q35
(select t1.name as Results 
from 
(select u.name, count(u.user_id), dense_rank() over(order by count(user_id) desc, u.name) as r1 
from Users u 
left join MovieRating m on u.user_id = m.user_id 
group by u.user_id) t1 
where r1 = 1) 
union 
(select t2.title as Results 
from 
(select mo.title, avg(m.rating), dense_rank() over(order by avg(m.rating)desc, mo.title) as r2 
from Movies mo 
left join MovieRating m on mo.movie_id = m.movie_id 
where month(m.created_at) = 2 and year(m.created_at) = 2020 
group by m.movie_id) t2 
where r2 = 1);


# Q36
select u.name, coalesce(sum(r.distance),0) as travelled_distance 
from users u 
left join rides r on u.id = r.user_id 
group by u.name 
order by travelled_distance desc, u.name;


# Q37
select u.unique_id, e.name 
from employees e 
left join employeeUNI u on e.id = u.id;


# Q38
select id, name 
from Students 
where department_id not in (select id from Departments);


# Q39
select t.person1, t.person2, count(*) as call_count, sum(t.duration) as total_duration 
from 
(select duration, case when from_id < to_id then from_id else to_id end as person1, 
case when from_id > to_id then from_id else to_id end as person2 
from Calls) t 
group by t.person1, t.person2;


# Q40
select p.product_id, round(sum(u.units*p.price)/sum(u.units),2) as average_price 
from prices p 
left join unitssold u on p.product_id = u.product_id 
where u.purchase_date >= start_date and u.purchase_date <= end_date 
group by product_id 
order by product_id;


# Q41
select w.name as warehouse_name, sum(p.width*p.length*p.height*w.units) as volume 
from warehouse w 
left join products p on w.product_id = p.product_id 
group by w.name 
order by w.name;


# Q42
select t.sale_date, (t.apples_sold - t.oranges_sold) as diff 
from 
(select sale_date, 
max(CASE WHEN fruit = 'apples' THEN sold_num ELSE 0 END )as apples_sold, 
max(CASE WHEN fruit = 'oranges' THEN sold_num ELSE 0 END )as oranges_sold 
from sales 
group by sale_date) t 
order by t.sale_date;


# Q43
select round(t.player_id/(select count(distinct player_id) from activity),2) as fraction 
from 
(select distinct player_id, datediff(event_date, lead(event_date, 1) over(partition by player_id order by event_date)) as diff 
from activity) t 
where diff = -1;


# Q44
select t.name 
from 
(select a.id, a.name, count(b.managerID) as no_of_direct_reports 
from employee a INNER JOIN employee b on a.id = b.managerID 
group by b.managerID) t 
where no_of_direct_reports >= 5 
order by t.name;


# Q45
select d.dept_name, count(s.dept_id) as student_number 
from department d 
left join student s on s.dept_id = d.dept_id 
group by d.dept_id 
order by student_number desc, dept_name;


# Q47
select t.project_id, t.employee_id 
from 
(select p.project_id, e.employee_id, dense_rank() over(partition by p.project_id order by e.experience_years desc) as r 
from project p 
left join employee e on p.employee_id = e.employee_id) t 
where r = 1 
order by t.project_id;


# Q48
select t1.book_id, t1.name 
from
((select book_id, name 
from Books 
where available_from < '2019-05-23') t1 
left join 
(select book_id, sum(quantity) as quantity 
from Orders 
where dispatch_date > '2018-06-23' and dispatch_date<= '2019-06-23' 
group by book_id 
having quantity < 10) t2 on t1.book_id = t2.book_id );


# Q49
select t.student_id, t.course_id, t.grade 
from 
(select student_id, course_id, grade, dense_rank() over(partition by student_id order by grade desc, course_id) as r 
from enrollments) t 
where r = 1 
order by t.student_id;


# Q50
select t2.group_id, t2.player_id 
from 
(select t1.group_id, t1.player_id, dense_rank() over(partition by group_id order by score desc, player_id) as r 
from 
(select p.*, 
case when p.player_id = m.first_player then m.first_score 
when p.player_id = m.second_player then m.second_score end as score 
from Players p, Matches m 
where player_id in (first_player, second_player) ) t1 ) t2 
where r = 1;


# Q51
select name, population, area 
from World 
where area >= 3000000 or population >= 25000000;


# Q52
select name 
from Customer 
where refree_id != 2 or refree_id is NULL;


# Q53
select c.name 
from Customers c 
left join Orders o on c.id = o.customerID 
where o.id is NULL;


# Q54
select employee_id, count(team_id) over(partition by team_id) as team_size 
from Employee order by employee_id;


# Q55
select t3.Name 
from 
(select t2.Name, 
avg(t1.duration) over(partition by t2.Name) as avg_call_duration, 
avg(t1.duration) over() as global_average 
from
((select cl.caller_id as id, cl.duration from Calls cl) 
union 
(select cl.callee_id as id, cl.duration from Calls cl)) t1 
left join 
(select p.id, c.Name 
from Person p 
left join Country c ON cast(left(p.phone_number,3) as int) = cast(c.country_code as int)) t2 on t1.id = t2.id) t3 
where t3.avg_call_duration > global_average 
group by t3.Name;


# Q56
select t.player_id, t.device_id 
from 
(select player_id, device_id, row_number() over(partition by player_id order by event_date) as num 
from activity)t 
where t.num = 1;


# Q57 - 1 
select customer_number 
from Orders 
group by customer_number 
order by count(order_number) desc limit 1;


# Q57- 2
select t.customer_number 
from 
(select customer_number, dense_rank() over(order by count(order_number) desc) as r 
from Orders 
group by customer_number) t 
where t.r = 1;


# Q58
select t.seat_id 
from (select seat_id, lead(seat_id,1,seat_id) over(order by seat_id) as next 
from Cinema where Free != 0 ) t 
where next - seat_id in (0,1) 
order by seat_id;


# Q59
select Name 
from SalesPerson 
where sales_id not in (select o.sales_id from Orders o 
left join Company c on o.com_id = c.com_id 
where c.Name = 'Red');


# Q60
select X, Y, Z, (case when X+Y > Z and Y+Z > X and Z+X > Y then 'Yes' else 'No' end) as triangle 
from Triangle;


# Q61
select min(t.diff) as shortest 
from 
(select lead(X,1) over(order by X) - X as diff 
from Point) t;


# Q62
select actor_id, director_id 
from ActorDirector 
group by actor_id, director_id 
having count(*) >= 3;


# Q63
select p.product_name, s.year, sum(price) as price 
from Sales s 
left join Product p on s.product_id = p.product_id 
group by p.product_name, s.year;


# Q64
select p.project_id, round(avg(e.experience_years),2) as average_years 
from Project p 
left join Employee e on p.employee_id = e.employee_id 
group by p.project_id;


# Q65
select t.seller_id from (select seller_id , sum(price), dense_rank() over(order by sum(price) desc) as r 
from Sales 
group by seller_id) t 
where t.r = 1;


# Q66
select buyer_id 
from 
(select t1.buyer_id, 
sum(case when t1.product_name = 'S8' then 1 else 0 end) as S8_count, 
sum(case when t1.product_name = 'iPhone' then 1 else 0 end) as iphone_count 
from 
(select s.buyer_id, p.product_name 
from Sales s 
left join Product p on s.product_id = p.product_id ) t1 
group by t1.buyer_id ) t2 
where t2.S8_count = 1 and t2.iphone_count = 0;


# Q67
select t2.visited_on, t2.amount, t2.average_amount 
from 
(select t1.visited_on, 
t1.prev_date_interval_6, 
round(sum(amount) over(order by visited_on range between interval '6' day preceding and current row),2) as amount, 
round(avg(amount) over(order by visited_on range between interval '6' day preceding and current row),2) as average_amount 
from 
(select visited_on, sum(amount) as amount, lag(visited_on,6) over(order by visited_on) as prev_date_interval_6 
from Customer 
group by visited_on 
order by visited_on) t1 ) t2 
where prev_date_interval_6 is not null;


# Q68
select gender, day, sum(score_points) over(partition by gender order by day) as total 
from Scores 
group by gender, day 
order by gender, day;


# Q69
select distinct start.log_id as start_id, min(end.log_id) over(partition by start.log_id) as end_id 
from 
(select log_id 
from Logs 
where log_id - 1 not in (select * from Logs)) 
start, 
(select log_id from Logs where log_id + 1 not in (select * from Logs)) end 
where start.log_id <= end.log_id;

# Q70
select t.student_id, t.student_name , t.subject_name, count(e.subject_name) as attended_exams 
from 
(select student_id, student_name, subject_name 
from Students, Subjects) t 
left join Examinations e on t.student_id = e.student_id and t.subject_name = e.subject_name 
group by t.student_id, t.subject_name 
order by t.student_id, t.subject_name;


# Q71
with recursive new as 
( 
	select employee_id 
    from Employees 
    where employee_id = 1 
    union 
    select e2.employee_id 
    from new e1 
    inner join Employees e2 on e1.employee_id = e2.manager_id 
) 
select * 
from new 
where employee_id <> 1;


# Q72
select month(trans_date) as Month, 
Country, count(Id) as trans_count, 
sum(case when State = 'approved' then 1 else 0 end) as approved_count, 
sum(amount) as trans_total_amount, 
sum(case when State = 'approved' then amount else 0 end) as approved_total_amount 
from Transactions 
group by Month, Country;


# Q73
select round(avg(t.daily_percent), 2) as average_daily_percent 
from 
(select sum(case when remove_date > action_date then 1 else 0 end)/ count(tmp.action_date)*100 as daily_percent 
from 
(select post_id, action_date, extra 
from Actions 
where extra = 'spam') tmp 
left join Removals r on tmp.post_id = r.post_id 
group by action_date) t;


# 74
select round(t.player_id/(select count(distinct player_id) from activity),2) as fraction 
from 
(select distinct player_id, 
datediff(event_date, 
lead(event_date, 1) over(partition by player_id order by event_date)) as diff 
from activity) t 
where diff = -1;


# Q75
select round(t.player_id/(select count(distinct player_id) from activity),2) as fraction 
from 
(select distinct player_id, 
datediff(event_date, lead(event_date, 1) over(partition by player_id order by event_date)) as diff 
from activity )t 
where diff = -1;


# Q76
select company_id, 
employee_id, employee_name, 
(case when max(salary) over(partition by company_id) < 1000 then salary 
when max(salary) over(partition by company_id) < 10000 then round(0.76*salary) 
else round(0.51*salary) end) as Salary
 from Salaries;


# Q77
select t.left_operand, t.operator, t.right_operand, 
(case when t.value > v2.value and operator = '>' then "true" 
when t.value < v2.value and operator = '<' then "true" 
when t.value = v2.value and operator = '=' then "true" else "false" end) as value 
from
(select e.*, v1.value 
from Expressions e 
inner join Variables v1 on e.left_operand = v1.name) t 
inner join Variables v2 on t.right_operand = v2.name;


# Q78
select t3.Name 
from 
(select t2.Name, avg(t1.duration) over(partition by t2.Name) as avg_call_duration, 
avg(t1.duration) over() as global_average 
from 
((select cl.caller_id as id, cl.duration 
from Calls cl) 
union 
(select cl.callee_id as id, cl.duration 
from Calls cl)) t1 left join 
(select p.id, c.Name 
from Person p 
left join Country c on cast(left(p.phone_number,3) as int) = cast(c.country_code as int)) t2 on t1.id = t2.id) t3 
where t3.avg_call_duration > global_average 
group by t3.Name;


# Q79
select name from Employee order by name;


# Q80
select year, 
product_id, curr_year_spend, 
coalesce(prev_year_spend,'') as prev_year_spend, 
coalesce(round((curr_year_spend - prev_year_spend)/prev_year_spend *100,2),'') as yoy_rate 
from 
(select year(transaction_date) as year, 
product_id, spend as curr_year_spend, 
round(lag(spend,1) over(partition by product_id order by transaction_date),2) as prev_year_spend 
from user_transactions )t;


# Q81
select item_type, 
(case 
when item_type = 'prime_eligible' then floor(500000/sum(square_footage)) * count(item_type) 
when item_type = 'not_prime' then floor((500000 -(select floor(500000/sum(square_footage)) * sum(square_footage) 
from inventory 
where item_type = 'prime_eligible'))/sum(square_footage)) * count(item_type) end) as item_count 
from inventory 
group by item_type 
order by count(item_type) desc;


# Q82 - Solution: For July Month
select month(a.event_date) as month, 
count(distinct a.user_id) as monthly_active_users 
from user_actions a 
inner join user_actions b on concat(month(a.event_date),year(a.event_date)) = concat(1+month(b.event_date),year(b.event_date)) and a.user_id = b.user_id 
where a.event_type in ('sign-in', 'like', 'comment') and b.event_type in ('sign-in', 'like', 'comment') and concat(month(a.event_date),'/',year(a.event_date)) = '7/2022' and concat(1+month(b.event_date),'/',year(b.event_date)) = '7/2022' 
group by month(a.event_date);


# Q82 - Solution: For June Month
select month(a.event_date) as month, 
count(distinct a.user_id) as monthly_active_users 
from user_actions a inner join user_actions b on concat(month(a.event_date),year(a.event_date)) = concat(1+month(b.event_date),year(b.event_date)) and a.user_id = b.user_id 
where a.event_type in ('sign-in', 'like', 'comment') and b.event_type in ('sign-in', 'like', 'comment') and concat(month(a.event_date),'/',year(a.event_date)) = '6/2022' and concat(1+month(b.event_date),'/',year(b.event_date)) = '6/2022' 
group by month(a.event_date);


# Q83 - Solution: using recursive cte
with recursive seq as 
( 
	select searches, num_users, 1 as c 
    from search_frequency 
    union 
    select searches, num_users, c+1 
    from seq where c < num_users 
) 
select round(avg(t.searches),1) as median 
from
(select searches,row_number() over(order by searches, c) as r1, row_number() over(order by searches desc, c desc) as r2 
from seq order by searches) t where t.r1 in (t.r2, t.r2 - 1, t.r2 + 1);


# Q83 - Solution: using cumulative sum
select round(avg(t1.searches),1) as median 
from 
(select t.searches, t.cumm_sum, 
lag(cumm_sum,1,0) over(order by searches) as prev_cumm_sum, 
case when total % 2 = 0 then total/2 else (total+1)/2 end as pos1, 
case when total % 2 = 0 then (total/2)+1 else (total+1)/2 end as pos2 
from 
(select searches, num_users, 
sum(num_users) over(order by searches rows between unbounded preceding and current row) as cumm_sum, 
sum(num_users) over(order by searches rows between unbounded preceding and unbounded following) as total 
from search_frequency) t ) t1 
where (t1.pos1 > t1.prev_cumm_sum and t1.pos1 <= t1.cumm_sum) or (t1.pos2 > t1.prev_cumm_sum and t1.pos2 <= t1.cumm_sum);


# Q84
select user_id, 
case when status in ('NEW','EXISTING','CHURN','RESURRECT') and user_id not in (select user_id from daily_pay) then 'CHURN' 
when status in ('NEW','EXISTING','RESURRECT') and user_id in (select user_id from daily_pay) then 'EXISTING' 
when status = 'CHURN' and user_id in (select user_id from daily_pay) then 'RESURRECT' end as new_status
from advertiser order by user_id;


# Q85
select sum(t.individual_uptime) as total_uptime_days 
from 
(select case when session_status = 'stop' then timestampdiff(day, lag(status_time) over(partition by server_id order by status_time), status_time) end as individual_uptime 
from server_utilization ) t;


# Q86
select sum(case when (unix_timestamp(t.next_transaction) - unix_timestamp(t.transaction_timestamp))/60 <= 10 then 1 else 0 end) as payment_count 
from 
(select transaction_timestamp, lead(transaction_timestamp,1) over(partition by merchant_id, credit_card_id, Amount 
order by transaction_timestamp) as next_transaction 
from transactions)t;


# Q87
select round(avg(t1.bad_exp_pct_per_cust),2) as bad_exp_pct 
from 
(select t.customer_id, 100*sum(case when o.status <> 'completed successfully' then 1 else 0 end)/count(*) as bad_exp_pct_per_cust 
from
(select customer_id, signup_timestamp 
from customers 
where month(signup_timestamp) = 6 ) t 
inner join orders o on o.customer_id = t.customer_id 
where timestampdiff(day, t.signup_timestamp, o.order_timestamp) <= 13 
group by t.customer_id) t1;


# Q88
select gender, day, sum(score_points) over(partition by gender order by day) as total 
from Scores 
group by gender, day 
order by gender, day;


# Q89
select t3.Name 
from 
(select t2.Name, 
avg(t1.duration) over(partition by t2.Name) as avg_call_duration, avg(t1.duration) over() as global_average 
from 
((select cl.caller_id as id, cl.duration from Calls cl) 
union 
(select cl.callee_id as id, cl.duration from Calls cl)) t1 
left join 
(select p.id, c.Name 
from Person p left join Country c on cast(left(p.phone_number,3) as int) = cast(c.country_code as int)) t2 on t1.id = t2.id) t3 
where t3.avg_call_duration > global_average 
group by t3.Name;


# Q90 - Solution: using recursive cte 
with recursive seq as 
( 
	select num, frequency, 1 as c 
    from Numbers 
    union 
    select num, frequency, c+1 
    from seq 
    where c < frequency ) 
    select round(avg(t.num),1) as median 
    from 
    (select num,row_number() over(order by num, c) as r1, row_number() over(order by num desc, c desc) as r2 from seq order by num ) t 
    where t.r1 in (t.r2, t.r2 - 1,t.r2 + 1);

# Q90 - Solution: using cumulative sum 
select round(avg(t1.num),1) as median 
from 
(select t.num, t.cumm_sum, 
lag(cumm_sum,1,0) over(order by num) as prev_cumm_sum, 
case when total % 2 = 0 then total/2 else (total+1)/2 end as pos1, 
case when total % 2 = 0 then (total/2)+1 else (total+1)/2 end as pos2 
from 
(select num, frequency, 
sum(frequency) over(order by num rows between unbounded preceding and current row) as cumm_sum, 
sum(frequency) over(order by num rows between unbounded preceding and unbounded following) as total
from Numbers) t ) t1 
where (t1.pos1 > t1.prev_cumm_sum and t1.pos1 <= t1.cumm_sum) or (t1.pos2 > t1.prev_cumm_sum and t1.pos2 <= t1.cumm_sum);


# Q91
select distinct 
concat(year(t.pay_date),'-',month(t.pay_date)) as pay_month, t.department_id, 
case when monthly_department_avg_salary > monthly_average_salary then 'higher' 
when monthly_department_avg_salary < monthly_average_salary then 'lower' 
else 'same' end as Comparison 
from 
(select s.pay_date, e.department_id, 
avg(s.amount) over(partition by month(s.pay_date), 
e.department_id) as monthly_department_avg_salary, 
avg(s.amount) over(partition by month(s.pay_date)) as monthly_average_salary 
from Salary s 
left join Employee e on s.employee_id = e.employee_id) t 
order by t.department_id;


# Q92
select t1.install_dt, 
count(player_id) as installs, 
round(count(t1.next_install)/count(t1.player_id),2) as Day1_retention 
from 
(select t.player_id, t.install_dt, a.event_date as next_install 
from
(select player_id, min(event_date) as install_dt 
from Activity group by player_id ) t 
left join Activity a on t. player_id = a.player_id and a.event_date = t.install_dt + 1) t1 
group by install_dt;


# Q93
select t2.group_id, t2.player_id 
from 
(select t1.group_id, t1.player_id, dense_rank() over(partition by group_id order by score desc, player_id) as r 
from 
(select p.*, 
case when p.player_id = m.first_player then m.first_score 
when p.player_id = m.second_player then m.second_score end as score 
from Players p, Matches m 
where player_id in (first_player, second_player) ) t1 ) t2 
where r = 1;


# Q94
select t.student_id, t.student_name 
from 
(select s.student_name, s.student_id, count(e.student_id) over(partition by student_name) as exams_given, 
case when e.score > min(e.score) over(partition by e.exam_id) and e.score < max(e.score) over(partition by e.exam_id) then 1 
else 0 end as quiet 
from Exam e 
left join Student s on e.student_id = s.student_id)t 
group by t.student_name, t.student_id, t.exams_given 
having sum(t.quiet) = t.exams_given;


# Q95
select t.student_id, t.student_name 
from 
(select s.student_name, s.student_id, count(e.student_id) over(partition by student_name) as exams_given, 
case when e.score > min(e.score) over(partition by e.exam_id) and e.score < max(e.score) over(partition by e.exam_id) then 1 
else 0 end as quiet 
from Exam e 
left join Student s on e.student_id = s.student_id)t 
group by t.student_name, t.student_id, t.exams_given 
having sum(t.quiet) = t.exams_given;


# Q96
select t.user_id, t.song_id, sum(t.song_plays) as song_plays 
from 
(select user_id, song_id, song_plays 
from songs_history 
union 
all select user_id, song_id, 1 as song_plays 
from songs_weekly 
where date(listen_time) <= '2022/08/04') t 
group by user_id, song_id;


# Q97
select round(sum(case when t.signup_action = 'Confirmed' then 1 else 0 end)/count(*),2) as confirm_rate 
from emails e 
join texts t on e.email_id = t.email_id;


# Q98
select user_id, 
date_format(tweet_date, '%m/%d/%Y %h:%i:%s') as tweet_date, 
round(avg(count(distinct tweet_id)) over(order by tweet_date rows between 2 preceding and current row),2) as rolling_avg_3days 
from tweets 
group by user_id, tweet_date;


# Q99
select b.age_bucket, 
round(100*sum(case when a.activity_type = 'Send' then a.time_spent else 0 end)/sum(a.time_spent),2) send_perc, 
round(100*sum(case when a.activity_type = 'Open' then a.time_spent else 0 end)/sum(a.time_spent),2) open_perc 
from activities a join age_breakdown b on a.user_id = b.user_id where activity_type in ('Open', 'Send') 
group by b.age_bucket order by b.age_bucket;


# Q100
select p.profile_id 
from personal_profiles p 
join employee_company e on p.profile_id = e.personal_profile_id 
join company_pages c on e.company_id = c.company_id 
group by p.profile_id, p.followers 
having p.followers > sum(c.followers) 
order by profile_id;

