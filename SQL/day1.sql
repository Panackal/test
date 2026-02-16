SELECT * FROM parks_and_recreation.employee_demographics;

SELECT age, age+10 FROM parks_and_recreation.employee_demographics;

SELECT distinct gender, age FROM parks_and_recreation.employee_demographics;

SELECT *  FROM parks_and_recreation.employee_salary where salary>50000;

SELECT * FROM parks_and_recreation.employee_demographics where gender!='Male'; 

SELECT * FROM parks_and_recreation.employee_demographics where birth_date> 1988-01-01;

SELECT * FROM employee_salary WHERE first_name LIKE '%Y';

SELECT gender , avg(age), max(age), min(age),count(age) from employee_demographics group by gender;
-- ORDERR BY 
SELECT * from employee_demographics order by first_name desc;
select * from employee_demographics order by gender,age desc;
 -- HAVING 
select occupation, avg(salary)  from employee_salary where occupation like '%mana%' group by occupation having avg(salary) >60000;
-- LIMIT , GET 2N LASGRETS ,SMALLETS
select * from employee_demographics limit 3;
select * from employee_demographics order by age desc limit 3;
select * from employee_demographics order by age desc limit 1,1;
-- ALIASING
select gender, avg(age) as average from employee_demographics group by gender having average >40;
-- JOINS
select * from employee_demographics  join  employee_salary on employee_demographics.employee_id = employee_salary.employee_id;
select * from employee_demographics AS T1  join  employee_salary AS T2 on T1.employee_id = T2.employee_id;
select T1.employee_id,age,T2.employee_id from employee_demographics AS T1  join  employee_salary AS T2 on T1.employee_id = T2.employee_id;
select * from employee_demographics   join  employee_salary on employee_demographics.employee_id = employee_salary.employee_id
 join parks_departments on parks_departments.department_id= employee_salary.dept_id ;
 
-- UNION
select first_name from employee_demographics union  select first_name from employee_salary;
 select first_name from employee_demographics union all select first_name from employee_salary;
 select first_name, last_name, 'Old' as Label from employee_demographics where age>50 union 
 select first_name,last_name, 'high salry' as Label from employee_salary where salary >70000;
-- STRING FUNCTION
select first_name, length(first_name) from employee_demographics order by 2;
select first_name, upper(first_name) from employee_demographics order by 2;
select first_name, lower(first_name) from employee_demographics;
select first_name, trim(first_name) from employee_demographics ;
select first_name, rtrim(first_name) from employee_demographics ;
select first_name, left(first_name,4),right(first_name,4),birth_date, substring(birth_date,6,2) as month from employee_demographics ;
select first_name, replace(first_name,'a','89') from employee_demographics ;
select first_name, locate('A',first_name) from employee_demographics ;
select first_name,last_name, concat(first_name,' ',last_name) as name from employee_demographics ;

-- CASE SATMENT
select first_name,last_name,age, case
when age<=35 then 'young'
when age between 36 and 70 then'old'
end as 'age category'
from employee_demographics;

-- SUBQURIES
select * from employee_demographics where employee_id in( select employee_id from employee_salary where dept_id=1);
select first_name,salary,(select avg(salary) from employee_salary) from employee_salary;
select avg(maxi) from (select gender, avg(age) as avgi, max(age) as maxi, min(age) as mini from employee_demographics group by gender ) as aggi;

-- WINDOWS FUCNTION 
-- using over instaed of group by 
select d1.first_name,d1.last_name,salary, sum(salary) over (partition by gender order by d1.employee_id) as totl from employee_demographics as d1 join employee_salary d2 on 
d1.employee_id= d2.employee_id;
-- giving postions or ranks for rows
select d1.first_name,d1.last_name,salary,gender,row_number() over(partition by gender  order by salary asc ) as roww,
rank() over(partition by gender order by salary asc) as ranku,
dense_rank() over(partition by gender order by salary asc) as rankuu
from employee_demographics as d1 join employee_salary as d2 on d1.employee_id = d2.employee_id ;

-- --CTE instaed of subqury
with CTE_example as(
select gender,avg(salary) as salu from employee_demographics d join
  employee_salary dd on d.employee_id = dd.employee_id group by gender
)
select avg(salu) from CTE_example;
-- using subqury 
select avg(salu) from (
select gender,avg(salary) as salu from employee_demographics d join
  employee_salary dd on d.employee_id = dd.employee_id group by gender) e;
-- join using CTE
with CTE1 as(
select first_name,gender from employee_demographics
where gender = 'male'),
CTE2 as(
select employee_id,salary from employee_salary where salary >5000)
select * from CTE1 join CTE2 on CTE1.employee_id=CTE2.employee_id;

--  TEMPORAY TABLES
create temporary table tempy( 
name1 varchar(50)
);
insert into tempy value ('joshua');
select * from tempy;

select * from employee_salary;

create temporary table salaryless(
select * from employee_salary where salary >50000);
select * from salaryless;

-- stored procedures 
select * from employee_salary where salary >50000;

create procedure sal5()
 select * from employee_salary where salary >50000;
call sal5();
--ex1 
delimiter $$
create procedure salu1()
begin
 select * from employee_salary where salary >50000;
 select * from employee_salary where salary <50000;
 end $$
 delimiter ;
 call salu();
 -- ex2
 delimiter $$
create procedure salu1()
begin
 select * from employee_salary where salary >50000;
 select * from employee_salary where salary <50000;
 end $$
 delimiter ;
 call salu();
 
 delimiter $$
 create procedure salu2(pp int)
begin
 select salary from employee_salary where employee_id = pp;
 end $$
 delimiter ;
 call salu2(1);
 
 -- TRIGGEER 
 
delimiter $$ 
create trigger triggu
after insert on employee_salary
for each row
begin 
insert into employee_demographics(employee_id,first_name,last_name)
values (new.employee_id,new.first_name,new.last_name);
end $$
delimiter ;

insert into employee_salary(employee_id,first_name,last_name,occupation,salary,dept_id)
values(13,'Jean','zz','zzzz',000,null);

-- EVENTS

select * from employee_demographics;
delimiter $$
create event retire
on schedule every 30 second
do
begin
delete from employee_demographics where age=60;
end $$
delimiter ;

show  variables like 'event%';

