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


