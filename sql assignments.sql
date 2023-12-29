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

drop table skills;
describe skills;

select * from skills;

select id
from skills
where technology in ('DS', 'Tableau', 'SQL', 'Python')
group by id
having COUNT(distinct technology) = 4;


select id
from skills
where technology = 'DS'
and id in
	(select id
	from skills
	where technology = 'Tableau')
	and id in
		(select id
		from skills
		where technology = 'SQL')
		and id in
			(select id
			from skills
			where technology = 'Python');