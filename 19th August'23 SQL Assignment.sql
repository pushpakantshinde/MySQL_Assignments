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



# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46
# Q46