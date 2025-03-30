/*
START OF ASSIGNMENT
--relevant question no. is stated before the SQL commands
--some additional commands used to view table content or to review the outcome
*/

# Q.1 (a) SELECT clause with WHERE, AND, DISTINCT, Wild Card (LIKE)

select employeeNumber,firstName,lastName
from employees
where jobTitle='Sales Rep' and reportsTo=1102;



# Q.1 (b)
select distinct productline 
from products
where productLine like '%Cars';



# Q.2 (a) CASE STATEMENTS for Segmentation

select customerNumber,customerName,
case 
when country in ("USA","Canada")
then "North America"
when country in ("UK","France","Germany")
then "Europe"
else "Other"
end as "CustomerSegment"
from customers;



# Q.3 (a) Group By with Aggregation functions and Having clause, Date and Time functions

select productcode, sum(quantityordered) as 'total_ordered'
from orderdetails
group by productcode
order by total_ordered desc 
limit 10;



# Q.3 (b)

select monthname(paymentDate) as "payment_month" ,count(*) as "num_payments"
from payments
group by monthname(paymentDate)
having num_payments>20
order by num_payments desc;



# Q. 4 (a) CONSTRAINTS: Primary, key, foreign key, Unique, check, not null, default
create database Customers_Orders;
use Customers_Orders;

create table Customers
(
customer_id int PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(50) not null,
last_name VARCHAR(50) not null,
email VARCHAR(255) UNIQUE,
phone_number VARCHAR(20) 
);



# Q. 4 (b)
create table Orders 
(
order_id int PRIMARY KEY AUTO_INCREMENT,
customer_id int,
order_date date,
total_amount DECIMAL(10,2) check(total_amount>0),
foreign key (customer_id) references Customers(customer_id)
);



# Q.5 (a) JOINS
select * from customers;
select * from orders;

select country ,count(*) as "order_count"
from customers
join orders
using (customerNumber)
group by country
order by order_count desc
limit 5;



# Q.6 (a) SELF JOIN
create table project
(
EmployeeID int primary key auto_increment,
FullName varchar(50) not null,
Gender varchar(15) check (Gender="Male" or Gender="Female"),
ManagerID int
);

insert into project (FullName,Gender,ManagerID)
values ("Pranaya","Male",3),("Priyanka","Female",1),("Preety","Female",null),("Anurag","Male",1),("Sambit","Male",1),("Rajesh","Male",3),
("Hina","Female",3);

select * from project;

select m.FullName as "Manager Name",
e.FullName as "Emp Name"
from project m
join project e
on m.EmployeeID=e.ManagerID
order by m.FullName;



# Q.7 (a) DDL Commands: Create, Alter, Rename

create table facility
(
Facility_ID int,
Name varchar(100),
State varchar(100),
Country varchar (100)
);

# (i)
alter table facility
modify column Facility_ID int primary key auto_increment;

# (ii)
alter table facility
add column City varchar(100) not null after name;

desc facility;



# Q. 8 (a) Views in SQL
select * from products;
select * from orders;
select * from orderdetails;
select * from productlines;

create view product_category_sales as
select productline, sum((orderdetails.quantityOrdered*orderdetails.priceEach)) as "total_sales",
count(distinct orderdetails.orderNumber) as "number_of_orders"
from products
join orderdetails
using (productcode)
group by productline;

select * from product_category_sales;



# Q. 9 (a) Stored Procedures in SQL with parameters
select * from customers;
select * from payments;

delimiter @
create procedure Get_country_payments (pyear year, pcountry varchar(50))
begin
select year(paymentdate) as "Year", country as "country", concat(round((sum(amount)/1000),0),"K") as "Total Amount" from payments
join customers
using (customernumber)
where year(paymentDate)=pyear and country=pcountry
group by year(paymentdate), country;
end @
delimiter ;

call Get_country_payments(2003,"France");



# Q. 10 (a) Window functions - Rank, dense_rank, lead and lag
select * from customers;
select * from orders;

select customerName, count(*) as "Order_count", dense_rank () over (order by count(*) desc) as order_frequency_rnk
from customers
join orders
using (customernumber)
group by customerName;



# Q. 10 (b)
select * from orders;

select year(orderdate) as Year, monthname(orderdate) as Month, count(*) as "Total Orders",
concat(cast((count(*) - lag(count(*)) over (order by year(orderdate)))/lag(count(*)) over (order by year(orderdate))*100 as decimal(10,0)),"%")
as "% YoY Change"
from orders
group by Year, Month;



# Q. 11 (a) Subqueries and their applications
select * from products;

select productLine, count(*) as "Total"
from products
where buyPrice>(select avg(buyPrice) from products)
group by productLine
order by Total desc;



# Q. 12 ERROR HANDLING in SQL
create table Emp_EH
(
EmpID int primary key,
EmpName varchar(50),
EmailAddress varchar(100)
);

delimiter @
create procedure Accept_input(eid int,ename varchar(56),eaddress varchar(56))
begin
declare continue handler for sqlexception select "Error occurred";
insert into emp_eh(empid,empname,emailaddress) values(eid,ename,eaddress);
select * from emp_eh;
end @
delimiter ;

call accept_input(101,"Alice","alice@email.com");

#entering duplicate record as above to view if procedure is showing error message as "Error occured"...as duplicate record violates PRIMARY KEY logic
call accept_input(101,"Alice","alice@email.com");



# Q. 13 TRIGGERS
create table Emp_BIT
(
Name varchar(50),
Occupation varchar(50),
Working_date date,
Working_hours int
);

INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);

select * from emp_bit;

delimiter @
create trigger B_IT before insert on emp_bit for each row
begin
if new.working_hours<0
then set new.working_hours=-(new.working_hours);
end if;
end @
delimiter ;

insert into emp_bit values
('XYZ', 'Scientist', '2020-10-04', -12);

select * from emp_bit;


/*
END OF ASSIGNMENT
*/