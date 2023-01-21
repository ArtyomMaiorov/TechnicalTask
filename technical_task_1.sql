create table employees
(
    employee_id   int primary key,
    name          varchar(255),
    position      varchar(255),
    start_date    date,
    salary        decimal(10, 2),
    department_id int,
    foreign key (department_id) references departments (department_id)
);

insert into employees (employee_id, name, position, start_date, salary, department_id)
values (1, 'Maiorov Artyom Konstantinovich', 'Developer', '2023-01-23', 300000, 2),
       (2, 'Sidnikov Sergei Nikolaevich', 'Manager', '2022-09-12', 300000, 1),
       (3, 'Sadvakasov Arsen Kemelevich', 'Designer', '2019-01-05', 300000, 3),
       (4, 'Manukyan David Timurovich', 'Manager', '2022-11-11', 60000, 4),
       (5, 'Michelangelo David Lodovico', 'Manager', '2012-12-12', 110000, 1),
       (6, 'Denisova Anna Vyacheslavovna', 'Manager', '2023-01-18', 200000, 4),
       (7, 'Askarovich Aman Damirovich', 'Developer', '2019-09-15', 180000, 2),
       (8, 'Kim Mikhail Antonovich', 'Manager', '2022-04-18', 100000, 3),
       (9, 'Apresyan Natalya Viktorovna', 'Designer', '2021-03-12', 130000, 3);

create table departments
(
    department_id   int primary key,
    department_name varchar(255)
);

insert into departments (department_id, department_name)
values (1, 'Marketing'),
       (2, 'IT'),
       (3, 'Design'),
       (4, 'Supply');


create table employee_address
(
    address_id  int primary key,
    employee_id int,
    address     varchar(255),
    city        varchar(255),
    zip_code    varchar(255),
    foreign key (employee_id) references employees (employee_id)
);

insert into employee_address(address_id, employee_id, address, city, zip_code)
values (1, 1, 'Furmanova 23', 'Almaty', '050032'),
       (2, 2, 'Shevchenko 250', 'Almaty', '512035'),
       (3, 3, 'Shemyaking 120b', 'Almaty', '050056'),
       (4, 4, 'Al-Faraby 137', 'Almaty', '651325'),
       (5, 5, 'Uly Dala 38', 'Astana', '326845'),
       (6, 6, 'Kabanbay 25', 'Astana', '845135'),
       (7, 7, 'Zheltoksan 2', 'Almaty', '846151'),
       (8, 8, 'Abylai Khan 13', 'Almaty', '984632'),
       (9, 9, 'Abay 92', 'Karaganda', '135465');


create table employee_education
(
    education_id    int primary key,
    employee_id     int,
    degree          varchar(255),
    major           varchar(255),
    university      varchar(255),
    graduation_date DATE,
    foreign key (employee_id) references employees (employee_id)
);

insert into employee_education(education_id, employee_id, degree, major, university, graduation_date)
values (1, 1, 'Bachelors', 'Computer Science', 'Kazakh British Technical University', '2023-05-25'),
       (2, 2, 'Bachelors', 'Civil Engineering', 'Al-Farabi Kazakh National University', '2012-05-25'),
       (3, 3, 'Bachelors', 'Business Administration', 'Eurasian National University', '2018-05-25'),
       (4, 4, 'Masters', 'Management', 'Abai Kazakh National Pedagogical University', '2013-05-25'),
       (5, 5, 'Bachelors', 'Mathematics', 'Kazakh-British Technical University', '2018-05-25'),
       (6, 6, 'Bachelors', 'Computer Science', 'Kazakh-British Technical University', '2019-05-25'),
       (7, 7, 'Masters', 'Physics', 'Kazakh National University', '2019-05-25'),
       (8, 8, 'Masters', 'Political Science', 'Al-Farabi Kazakh National University', '2021-05-25'),
       (9, 9, 'Bachelors', '3D Design', 'International IT University', '2019-05-25');

create table employee_experience
(
    experience_id int primary key,
    employee_id   int,
    company_name  varchar(255),
    position      varchar(255),
    start_date    date,
    end_date      date,
    foreign key (employee_id) references employees (employee_id)
);

insert into employee_experience(experience_id, employee_id, company_name, position, start_date, end_date)
values (1, 1, 'Google', 'Developer', '2015-01-25', '2023-01-22'),
       (2, 2, 'KazMunayGas', 'Manager', '2018-05-01', '2022-09-11'),
       (3, 3, 'Air Astana', 'Designer', '2016-05-01', '2019-01-04'),
       (4, 4, 'Halyk Bank', 'Manager', '2015-05-01', '2022-11-10'),
       (5, 5, 'Kaspi Bank', 'Designer', '2010-05-01', '2012-12-11'),
       (6, 6, 'Kazakhstan Temir Zholy', 'Developer', '2008-05-01', '2018-09-15'),
       (7, 7, 'Jysan Bank', 'Developer', '2013-05-01', '2019-09-15'),
       (8, 8, 'Samsung', 'Manager', '2011-05-01', '2022-04-17'),
       (9, 9, 'Bank Central Credit', 'Designer', '2009-05-01', '2021-03-11');


-- 1
select name, salary, position
from employees e
         join departments d on d.department_id = e.department_id
where e.name like '%David%'
  and d.department_name = 'Supply';


-- 2
select d.department_name, round(avg(e.salary)) as average_salary
from employees e
         join departments d on e.department_id = d.department_id
group by d.department_name;


-- 3
with common_average as (select avg(salary) as common_average
                        from employees),
     position_average as (select position, avg(salary) as position_average from employees group by position)
select position, position_average,
case
    when (position_average > common_average) then 'yes'
    else 'no'
end
as larger_than_common_average_salary
from position_average,
     common_average;

select avg(salary)
from employees;

-- 4
create view fourth_table as
with departments_list as (select position, array_agg(distinct department_name)
                          from employees
                                   join departments d on d.department_id = employees.department_id
                          group by position),
     employees_json as (select position,
                               department_name,
                               array_agg(employees.name) as employees
                        from employees
                                 join departments on employees.department_id = departments.department_id
                        where employees.start_date >= '2021-01-01'
                        group by department_name, position),
     average_salary as (select position, salary as avgsalary
                        from employees)
select position,
       array_agg(distinct department_name)                       as departments,
       json_object_agg(distinct department_name, employees_json) as employees_from_2021,
       avg(avgsalary)                                            as average_salary
from employees_json
         join departments_list using (position)
         join average_salary using (position)
group by position;

select * from fourth_table;
