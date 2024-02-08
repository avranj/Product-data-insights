show tables;
desc sales;
-- looking what is inside the tables
select * from sales;

select max(Customers), min(Customers), max(Amount),min(Amount) from sales;
-- Specifying different-different columns
select SaleDate, Amount, Customers, Boxes from sales;

-- Now we will see amount per box
select  Customers, Amount, Boxes, Amount/Boxes as 'Amount per box' from sales
order by Amount desc; 

-- each customer spending how much amount
select Customers, Amount, Amount/Customers 'Avg Customer amount', Boxes/Customers 'Avg boxes to each customer' from sales
order by Amount, Boxes;
-- By above query we found out that there is no use of Avg. customer amt and avg. boxes to each customer

-- Now we will see data as geography wise, ID wise and amount condition:
select * from sales
where GeoID in('G4','G5','G6') and PID in('P08','P07') and Amount > 1000 and Amount <=2000
Group by PID, GeoID
order by Amount desc;

-- we will sales at specific year
select * from sales
where Amount>1000 and year(saleDate)=2022;

-- finding sale at specific weekday before that we will chaeck weekday function
select  Amount, PID, Customers, weekday(SaleDate) as 'Day' from sales;

-- finding data at specific day
select Customers, Amount, SaleDate, weekday(SaleDate) 'Day of week' from sales
where weekday(SaleDate)=3;

-- Analyzing more on weekdays
select Customers, GeoID, PID, Amount, SaleDate, weekday(SaleDate)  'day' from sales
where weekday(SaleDate) in(3,4,5)
and Customers <= 300 
and Amount <= 3000
and GeoID in('G4','G6') 
and PID in('P02','P03')
Group by PID, GeoID, weekday(SaleDate)
order by Amount;

-- In below query we will check customers and amount on each day with some specific condition and compare it with overall footfall and highest amount of the day
select Customers, max(Customers),max(Amount),GeoID, PID, Amount, SaleDate, weekday(SaleDate)  'day' from sales
where weekday(SaleDate) in(0,1,2,3,4,5,6)
and Customers >= 50 
and Amount >= 1000
and GeoID in('G1','G3') 
and PID in('P05','P08')
Group by PID, GeoID, weekday(SaleDate)
order by Amount desc;

-- Finding min, max and average values of customers , Total amount on ach day 
select min(Customers) as mincustomer, min(Amount) as minamount, max(Customers) as maxcustomers,
max(Amount) as maxamount, avg(Customers) as average_footfall, avg(Amount) as AverageAmt,
weekday(SaleDate) from sales
where weekday(SaleDate) in(0,1,2,3,4,5,6)
group by weekday(SaleDate);

-- we can also apply branching in sql
select Customers, SaleDate, Amount, case
when Amount < 1000 then 'under 1k'
when Amount < 5000 then 'under 5k'
when Amount < 10000 then 'under 10k'
else '10k or more'
end as 'amount category' from sales;

-- we will try to check day wise (While applying group by clause it is adjusting it ti specific days) 
select Customers, SaleDate, Amount, weekday(SaleDate) as day_of_week , case
when Amount < 1000 then 'under 1k'
when Amount < 5000 then 'under 5k'
when Amount < 10000 then 'under 10k'
else '10k or more'
end as 'amount category' 
from sales
where weekday(SaleDate)
order by Amount;

/* Now we will explore different tables and 
Analyse by applying join techniques in table :-
*/

select * from people;
select * from products;
select * from geo;

-- Simple Joining sales and products table and so on 


select s.Amount, s.Customers, p.Location, p.Salesperson, p.Team
from sales s
join people p on p.spid=s.spid;

-- data of same team
select s.Amount, s.Customers, p.Location, p.Salesperson, p.Team
from sales s
join people p on p.spid=s.spid
where p.Team = 'yummies';

-- Salesperson with no team
select s.Amount, s.Customers, p.Location, p.Salesperson, p.Team
from sales s
join people p on p.spid=s.spid
where p.Team = ''
order by p.location;

-- day wise breakeven for hyderabad
select s.Amount, s.Customers, p.Location, weekday(s.SaleDate) as 'day of week'
from sales s
join people p on p.spid=s.spid
where weekday(s.SaleDate) in(0,1,2,3,4,5) 
and p.location='HYDERABAD'
order by p.SPID;

-- Max footfalls and max amount for each day in hyderabad -- we can check the same for different cities
select max(s.amount) as 'Max Amount', max(s.Customers) as 'MaxCustomers', p.Location, weekday(s.Saledate) as 'dayofweek'
from sales s
join people p on p.spid=s.spid
where p.Location='HYDERABAD'
group by dayofweek;

-- Will do more analysis with product table
select * from products;

-- on a certain day amount of product sale and how many consumers bought it
select s.amount, s.customers,pr.category,pr.product,pr.size
from sales s
join products pr on pr.PID = s.PID;

-- now we will check which category or product is in demand
select max(s.amount), max(s.customers), pr.product, pr.category
from sales s
join products pr on pr.PID = s.PID;

-- now we will check for each product and category
select max(s.amount) as Maxamt, min(s.amount) as Minamt, 
min(s.customers) as Mincustomers, max(s.customers) as Maxcustomers,
pr.product,pr.category
from sales s
join products pr on pr.PID = s.PID
group by pr.product,pr.category; 

-- now we can check some insights on daywise
select max(s.amount) as Maxamt, min(s.amount) as Minamt, 
min(s.customers) as Mincustomers, max(s.customers) as Maxcustomers,
pr.product, pr.category,
dayofweek(s.SaleDate) as 'Day'
from sales s
join products pr on pr.PID = s.PID
group by Day;

select distinct dayname(SaleDate) as dayofweek
from sales; -- as we found out in this query that total weekdays are 5, which means above query is giving correct result only change is day starts with 2 number.

-- which team has sales of below 500 in which we have to cover category and product as well.
select s.amount,s.SaleDate, pr.product, pr.Category, p.team
from sales s
join people p on p.spid=s.spid
join products pr on pr.pid=s.pid
where s.amount <500 and p.Team='DELISH'
order by s.amount desc;

select s.amount,s.SaleDate, pr.product, pr.Category, p.team
from sales s
join people p on p.spid=s.spid
join products pr on pr.pid=s.pid
where s.amount <500 and p.Team=''
order by s.amount desc;

select s.amount,s.SaleDate, pr.product, pr.Category, p.team, pr.size
from sales s
join people p on p.spid=s.spid
join products pr on pr.pid=s.pid
where s.amount <500 and p.Team='JUCIES'
order by s.amount desc;

-- which product, category has boxes large and small
select s.customers, pr.product, pr.category, p.team, pr.size
from sales s
join people p on p.spid=s.spid
join products pr on pr.pid=pr.pid
where pr.size in('SMALL','LARGE')
order by s.customers;

-- on weekday which type of box size is preferred majorly
select max(s.amount) as Maxamt, min(s.amount) as Minamt, pr.size, weekday(s.SaleDate) as 'Day'
from sales s
join products pr on pr.PID=s.PID
group by Day;

-- which category, product, team has more boxes and more sum of amount:
select sum(s.amount), sum(s.Boxes), sum(s.Customers), p.team, pr.category, pr.product
from sales s
join products pr on pr.pid=s.pid
join people p on p.spid=s.spid
group by p.team, pr.category, pr.product;

-- What if we need to find top 5 product
select pr.product, sum(s.amount)
from sales s
join products pr on pr.pid=s.pid
group by pr.product
order by s.amount desc limit 5;

-- top 5 customers footfall for which category and product also can check it is of which team and of what box size. 
select pr.product, pr.category,sum(s.customers)
from sales s
join products pr on pr.pid=s.pid
group by pr.product,pr.category
order by s.customers desc limit 5;

-- we can also find how many customers coming for specific item each day
select pr.product, pr.category, p.team, weekday(s.SaleDate) as 'day_of_week',
sum(s.customers) as 'customers_each_day'
from sales s
join products pr on pr.pid=s.pid
join people p on p.spid=s.spid
group by day_of_week
order by p.team;

/*  Now we will look in to some more deep dive  logical queries
which might have require some more time and will end the analysis */
-- Print details of shipments (sales) where amounts are > 2,000 and boxes are <100?
select * from sales where amount > 2000 and boxes <200;
-- (we can create deep insights using this query)

-- How many shipments (sales) each of the sales persons had in the month of January 2022?
select * from sales where year(SaleDate) ='2022' and month(SaleDate)=1 ;
/* We can also create much more Insights using above query.
 1. can compare each product day-wise.
 2. we can get trends in product using months and day to generate product forecasting
 
 */
 
 -- Which product sells more boxes? Milk Bars or Eclairs? 
 select sum(s.boxes) as Total_product_sell, pr.Product
 from products pr
 join sales s on s.PID = pr.PID
 where pr.product in ('Milk Bars', 'Eclairs')
 group by pr.product; -- Eclairs has more sell.
 
 -- Which product sold more boxes in the first 7 days of February 2022? Milk Bars or Eclairs?
 select sum(s.boxes) as Total_product_sell, pr.Product
 from products pr
 join sales s on s.PID = pr.PID
 where pr.product in ('Milk Bars', 'Eclairs') and
 s.saledate between '2022-2-8' and '2022-2-14'
 group by pr.product;

-- Which shipments had under 100 customers & under 100 boxes? Did any of them occur on Wednesday?
select * from sales
where customers < 100 and boxes <100 
and dayofweek(SaleDate)=2;

-- What are the names of salespersons who had at least one shipment (sale) in the first 7 days of January 2022?
select  distinct p.salesperson
from people p
join sales s on s.spid=p.spid
where s.SaleDate between '2022-01-01' and '2022-01-07' ;

-- Which salespersons did not make any shipments in the first 7 days of January 2022?
select  distinct p.salesperson
from people p
where p.spid not in(select distinct s.spid from sales s
where s.SaleDate between '2022-01-01' and '2022-01-07');

-- How many times we shipped more than 1,000 boxes in each month?
select year(SaleDate) as 'year', month(SaleDate) as 'month', count(*) as 'Total sales'
from sales
where boxes >= 90
group by year(SaleDate) , month(SaleDate)
order by year(SaleDate) , month(SaleDate);

/*------------------------------------------ This is the Insights of a product sales analysis---------------------------------------------------*/



















