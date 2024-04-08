create table sales(
      invoice_id varchar(30) NOT NULL primary key,
      branch varchar(5) not null,
      city varchar (30) not null,
	  customer_type varchar (30) not null,
      gender varchar(10) not null,
      product_line varchar(100) not null,
      unit_price decimal(10,2) not null,
	  quantity int not null,
	  VAT decimal(6, 4) not null,
	  total decimal (12,4) not null,
	  "date" Date not null,
	  "time" time not null,
	  payment_method varchar(15) not null,
	  cogs decimal(10,2) not null,
	  gross_margin_pct decimal (11,9),
	  gross_income decimal (12,4) not null,
	  rating decimal (2,1));
	  
select * from sales;

copy sales  from 'D:\sql 2\WalmartSalesData.csv.csv'delimiter ',' csv header;

----Feature Enginerring---

alter table sales add column time_of_day varchar (20);


select min (time) from sales;

update sales
set time_of_day=(case when "time" between '00:00:00' and '12:00:00' then 'Morning'
	      when "time" between '12:01:00' and '16:00:00' then 'Afternoon'
		  else 'Evening' end);
		  		  
select date,
       to_char(date, 'Day') as day_name
	   from sales;
	   	  
alter table sales add column day_name varchar (20);

update sales
set day_name=to_char(date, 'Day')

select * from sales ;

select date,
       to_char(date, 'Month') as month_name
	   from sales;
	   
alter table sales add column month_name varchar (20);

update sales
set month_name=to_char(date, 'Month');

---------GENERIC---------
---How many unique cities does the data have?

select count(distinct city) from sales;

---In which city is each branch

select distinct city, branch from sales;


-------------PRODUCTS----------------
--How many unique product lines does the data have?

select count(distinct product_line) from sales;

--What is the most common payment method?

select payment_method, count(payment_method) as cnt from sales 
group by payment_method order by cnt desc;

---What is the most selling product line?

select product_line, count(product_line) as cnt from sales 
group by product_line order by cnt desc

--What is the total revenue by month?

select month_name, sum(total) as total_revenue from sales 
group by month_name order by total_revenue desc;

--What month had the largest COGS?

select month_name, sum(cogs) as total from sales 
group by month_name order by total desc;

--What product line had the largest revenue?

select product_line, sum(total) as total_revenue from sales 
group by product_line order by total_revenue desc;

--What is the city with the largest revenue?

select branch,city, sum(total) as total_revenue from sales 
group by branch, city order by total_revenue desc;

--What product line had the largest VAT?

select product_line, avg(VAT) as avg_VAT from sales 
group by product_line order by avg_VAT desc;

--Which branch sold more products than average product sold?

select branch, sum(quantity) as quant from sales 
group by branch  having sum(quantity)> (select avg(quantity) from sales) order by quant;

--What is the most common product line by gender?

select gender, product_line ,count(product_line) as cont from sales 
group by gender, product_line order by cont desc

--What is the average rating of each product line?

select product_line, round(avg(rating),2) as avg_rating from sales 
group by product_line order by avg_rating desc


--Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

select product_line, 
case when  sum (cogs) > avg (cogs ) then 'Good' else 'Bad' end 
from sales
group by product_line;


------------------sales------------------
--Number of sales made in each time of the day per weekday

select time_of_day, count(*) as total_sales from sales 
group by time_of_day order by total_sales desc;

select * from sales

--Which of the customer types brings the most revenue?

select customer_type, sum(total) as total  from sales 
group by customer_type order by total desc;

--Which city has the largest tax percent/ VAT (Value Added Tax)?

select city , avg(VAT) as avg_vat from sales group by city order by avg_vat desc;

--Which customer type pays the most in VAT?

select customer_type , sum(VAT) as total_vat from sales 
group by customer_type order by total_vat desc;

---------------------Customers-----------------
--How many unique customer types does the data have?
select distinct customer_type from sales;

--How many unique payment methods does the data have?

select distinct payment_method from sales;

--What is the most common customer type?

select customer_type, count(*) from sales group by customer_type;

--Which customer type buys the most?

select customer_type, count(*) from sales group by customer_type;

--What is the gender of most of the customers?

select gender, count(*) from sales group by gender;

---What is the gender distribution per branch?

select gender, count(*) from sales where branch='B' group by  gender order by gender;

--Which time of the day do customers give most ratings?

select time_of_day, count(rating) as rate_total from sales
group by time_of_day order by rate_total desc;

--Which time of the day do customers give most ratings per branch?

select branch,time_of_day, count(rating) as rate_total from sales 
group by branch, time_of_day order by rate_total desc;

--Which day fo the week has the best avg ratings?

select day_name, avg(rating) as rate_avg from sales 
group by day_name order by rate_avg desc

--Which day of the week has the best average ratings per branch?

select branch, avg(rating) as rate_avg from sales 
group by branch order by rate_avg desc


--------------Revenue and Profit Calculation------

--$ COGS = unitsPrice * quantity $
select sum (unit_price * quantity)  as COGS from sales

--$ VAT = 5% * COGS $--

select 0.05 *(sum (unit_price * quantity))  as VAT from sales

-- VAT is added to the COGS and this is what is billed to the customer--

select (sum (unit_price * quantity) + 0.05 *(sum (unit_price * quantity))) as total_gross_sales from sales

--$ grossProfit(grossIncome) = total(gross_sales) - COGS $

select (sum (total)-sum (cogs))as gross_income from sales





