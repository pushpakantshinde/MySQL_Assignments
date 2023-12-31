# Question 1 - Write SQL query to list the candidates who posses all the required skillss i.e. DS, Tableau, Python, SQL

create database linkedin;
use linkedin;

create table skills (
id int,
technology varchar(20)
);

insert into skills values 
(1, 'DS'), 
(1, 'Tableau'), 
(1, 'SQL'), 
(2, 'R'), 
(2, 'PowerBI'), 
(1, 'Python'), 
(2, 'SQL'),
(3, 'PowerBI'),
(3, 'Python'),
(3, 'SQL');

describe skills;

select * from skills;

# Solution 1

select id
from skills
where technology in ('DS', 'Tableau', 'SQL', 'Python')
group by id
having COUNT(distinct technology) = 4;

# Solution 2

select id
from skills
where technology = 'DS'
and id in (
	select id
	from skills
	where technology = 'Tableau'
	and id in (
		select id
		from skills
		where technology = 'SQL'
		and id in (
			select id
			from skills
			where technology = 'Python')
            )
		);
 
# Question 2 - Write SQL query to return the IDs of the product info that has 0 likes.
 
create database facebook;
 
use facebook;
 
create table product_info(
product_id int primary key,
product_name varchar(30)
);
 
drop table product_info;
 
create table product_info_likes(
user_id int not null,
product_id int,
liked_date date,
foreign key (product_id) references product_info(product_id)
);
 
insert into product_info values (1001, 'Blog'), (1002, 'Youtube'), (1003, 'Education');
 
insert into product_info_likes values (1, 1001, '2023-08-19'), (2, 1003, '2023-08-18');
 
select * from product_info;
select * from product_info_likes;


# Solution

select p.product_id
from product_info p
left join product_info_likes pl on p.product_id = pl.product_id
group by p.product_id
having count(pl.product_id) = 0;

