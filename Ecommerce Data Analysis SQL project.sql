use ecommerce_dataset;

-- View the table
select * from ecommerce_data;

-- 1 what is total revenue generated?
select 
round(sum(revenue),3) as total_revenue 
from ecommerce_data
 where shipping_status = 'Delivered';

-- 2 What is total revenue loss?
select 
round(sum(revenue),3) as revenue_loss
 from ecommerce_data 
 where shipping_status = 'Cancelled';

-- 3 Total revenue by weekday
select
 weekday,
 round(sum(revenue),3) as total_revenue
 from ecommerce_data
 where shipping_status = 'Delivered' 
 group by weekday 
 order by total_revenue desc;

-- 4 total revenue by month
select 
`month`,
 round(sum(revenue),3) as total_revenue
 from ecommerce_data 
 where shipping_status = 'Delivered'  
 group by month
 order by total_revenue desc;
 
 -- 5 Total pending revenue by weekday
select
 weekday,
 round(sum(revenue),3) as pending_revenue
 from ecommerce_data
 where shipping_status in('Shipped', 'Processing')
 group by weekday
 order by pending_revenue desc;
 
 -- 6 Total pending revenue by month
select 
`month`,
 round(sum(revenue),3) as pending_revenue 
 from ecommerce_data
 where shipping_status in('Shipped', 'Processing')
 group by `month` 
 order by pending_revenue desc;
 
 -- 7 Total revenue loss by weekday
 select 
 weekday,
 round(sum(revenue),3) as revenue_loss
 from ecommerce_data
 where shipping_status = 'Cancelled'
 group by weekday
 order by revenue_loss desc;
 
 -- 8 Total revenue loss by month
 select 
 `month`,
 round(sum(revenue),3) as revenue_loss
 from ecommerce_data
 where shipping_status = 'Cancelled'
 group by `month`
 order by revenue_loss desc;
 
 -- 9 Top 5 customers who generates highest revenue
 select 
 customer_email,
 customer_name,
 round(sum(revenue),3) as total_revenue 
 from ecommerce_data 
 where shipping_status = 'Delivered' 
 group by customer_email, customer_name 
 order by total_revenue desc 
 limit 5;
 
 -- 10 Top 10 products generating high revenue
 select
 product_name,
 round(sum(revenue),3) as total_revenue
 from ecommerce_data
 where shipping_status = 'Delivered'
 group by product_name
 order by total_revenue desc
 limit 10 ;
 
 -- 11 Top 10 products whose quantity sold is highest
 select 
 product_name,
 sum(quantity) as total_quantity_sold
 from ecommerce_data 
 where shipping_status = 'Delivered'
 group by product_name
 order by total_quantity_sold desc
 limit 10;
 
 -- 12 Total revenue by each category 
 select
 category,
 round(sum(revenue),3) as total_revenue
 from ecommerce_data
 where shipping_status = 'Delivered'
 group by category
 order by total_revenue desc;
 
 -- 13 Total revenue by each sub category
  select
 sub_category,
 round(sum(revenue),3) as total_revenue
 from ecommerce_data
 where shipping_status = 'Delivered'
 group by sub_category
 order by total_revenue desc;
 
 -- 14 Total revenue by each payment method
 select 
 payment_method,
 round(sum(revenue),3) as total_revenue
 from ecommerce_data 
 where shipping_status = 'Delivered'
 group by payment_method
 order by total_revenue desc;
 
 -- 15 Top 5 customers who are buying high quantites
 select 
 customer_email, 
 customer_name, 
 sum(quantity) as total_quantity 
 from ecommerce_data 
 where shipping_status != 'Cancelled'  
 group by customer_email, customer_name 
 order by total_quantity desc
 limit 5;
 
 -- 16 Top 5 customers who received total highest discount
 select 
 customer_email, 
 customer_name,
 round(sum(discount),3) as total_discount
 from ecommerce_data 
 where shipping_status != 'Cancelled'
 group by customer_email, customer_name
 order by total_discount desc
 limit 5;
 
 -- 17 Total quantity sold by each category
 select 
 category,
 sum(quantity) as total_quantity_sold
 from ecommerce_data 
 where shipping_status = 'Delivered'
 group by category
 order by total_quantity_sold desc;
 
 -- 18 Total quantity sold by each sub category
 select 
 sub_category,
 sum(quantity) as total_quantity_sold
 from ecommerce_data 
 where shipping_status = 'Delivered'
 group by sub_category
 order by total_quantity_sold desc;
 
 -- 19 Quantity sold by discount
 select 
discount,
 sum(quantity) as quantity_sold
 from ecommerce_data 
 where shipping_status = 'Delivered' 
 group by discount 
 order by quantity_sold desc;
 
 -- 20 Top 3 customers generating high revenue by each category
select 
`rank`,
category,
customer_email,
customer_name,
total_revenue
from (select 
category,
customer_email,
customer_name,
round(sum(revenue),2) as total_revenue,
row_number() over(partition by category order by sum(revenue) desc) AS `rank`
from ecommerce_data 
where shipping_status = 'Delivered'
group by category, customer_email, customer_name) ranked
where `rank` <= 3
order by category, total_revenue desc;

-- 21 Second highest revenue generating product
select
product_name,
max(revenue) as max_revenue
from ecommerce_data
where revenue != (select max(revenue) from ecommerce_data)
group by product_name
order by max_revenue desc
limit 1;

-- 22 On which day of the week the orders are highest?
select 
weekday,
count((order_id)) as total_orders
from ecommerce_data 
group by weekday
order by total_orders desc;

-- 23 top 3 products generating high revenue by each category
with my_cte as ( select
product_name,
category,
round(sum(revenue),2) as total_revenue,
row_number() over(partition by category order by sum(revenue) desc) as `rank`
from ecommerce_data
where shipping_status = 'Delivered'
group by product_name, category)
select
`rank`,
category,
product_name,
total_revenue
from my_cte
where `rank` <= 3
order by category, total_revenue desc;

-- 24 how many times Which 2 products are bought together?
select 
a.product_id as product_id_1,
a.product_name as product_name_1,
b.product_id as product_id_2,
b.product_name as product_name_2,
count(*) as number_of_times_bought_together
from ecommerce_data a
join ecommerce_data b 
on
a.order_id = b.order_id
and a.product_id < b.product_id
group by
a.product_id,
a.product_name,
b.product_id,
b.product_name
order by number_of_times_bought_together desc;