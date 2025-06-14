create database brothers
use brothers

select * from brothers_data

select count(*) from brothers_data -- to count total rows

--proper text
update brothers_data
set item_fat_content = 
case 
when item_fat_content in ('LF','low fat') then 'Low Fat'
when item_fat_content = 'reg' then 'Regular'
else item_fat_content
end

select * from brothers_data

-- all distinct items in item_fat_content

select distinct (item_fat_content) from brothers_data

select * from brothers_data

--sum of sales in millions, not in digit
select cast(sum(sales)/1000000 as decimal(10,2)) as total_sales_million
from brothers_data

--average sales with round figure
select cast(avg(sales) as decimal(10,0)) as avg_sales from brothers_data
select cast(avg(sales) as decimal(10)) as avg_sales from brothers_data
--both query works same

--No.of items
select count(*) as Number_of_items from brothers_data

--For particular column (same where condition we can apply on avg sales too)
select cast(sum(sales)/1000000 as decimal(10,2)) as total_sales_million
from brothers_data
where item_fat_content = 'Low Fat'

select cast(sum(sales)/1000000 as decimal(10,2)) as total_sales_million
from brothers_data
where outlet_establishment_year = 2022


-- average rating
select cast(avg(rating) as decimal(10,2)) as avg_rating from brothers_data

--all above commands by particular column (fat content) with concanate function
select item_fat_content , 
concat(cast(sum(sales)/1000 as decimal(10,2)),'k') as total_sales,
cast(avg(rating) as decimal(10,2)) as avg_rating,
cast(avg(sales) as decimal(10,2)) as avg_sales,
count(*) as Number_of_items
from brothers_data
group by item_fat_content
order by total_sales 

--above command for 2022 year
select item_fat_content , 
cast(sum(sales) as decimal(10,2))as total_sales,
cast(avg(rating) as decimal(10,2)) as avg_rating,
cast(avg(sales) as decimal(10,2)) as avg_sales,
count(*) as Number_of_items
from brothers_data
where outlet_establishment_year=2022
group by item_fat_content
order by total_sales 

--above command for 2020 year
select item_fat_content , 
cast(sum(sales) as decimal(10,2))as total_sales,
cast(avg(rating) as decimal(10,2)) as avg_rating,
cast(avg(sales) as decimal(10,2)) as avg_sales,
count(*) as Number_of_items
from brothers_data
where outlet_establishment_year=2020
group by item_fat_content
order by total_sales 

-- Above commands with 'Item type' in all years
select item_type , 
cast(sum(sales) as decimal(10,2))as total_sales,
cast(avg(rating) as decimal(10,2)) as avg_rating,
cast(avg(sales) as decimal(10,2)) as avg_sales,
count(*) as Number_of_items
from brothers_data
group by item_type
order by total_sales desc

-- Above commands with 'Item type' in all years with top 5 items
--LIMIT doesn't work in SQL Server, so we are using TOP
select top 5 item_type , 
cast(sum(sales) as decimal(10,2))as total_sales,
cast(avg(rating) as decimal(10,2)) as avg_rating,
cast(avg(sales) as decimal(10,2)) as avg_sales,
count(*) as Number_of_items
from brothers_data
group by item_type
order by total_sales desc

-- Above commands with 'Item type' in all years with bottom 5 items
--We don't need to use bottom keyword, just sort it with order by, make it asc instead of desc
-- or just desc because its asc by default
select top 5 item_type , 
cast(sum(sales) as decimal(10,2))as total_sales,
cast(avg(rating) as decimal(10,2)) as avg_rating,
cast(avg(sales) as decimal(10,2)) as avg_sales,
count(*) as Number_of_items
from brothers_data
group by item_type
order by total_sales

-- Above commands with 'Item type' in year 2022 only
select item_type , 
cast(sum(sales) as decimal(10,2))as total_sales,
cast(avg(rating) as decimal(10,2)) as avg_rating,
cast(avg(sales) as decimal(10,2)) as avg_sales,
count(*) as Number_of_items
from brothers_data
where outlet_establishment_year=2022
group by item_type
order by total_sales desc

-- Above commands with 'Item type' in year 2020 only with top and bottom 5
select top 5 item_type , 
cast(sum(sales) as decimal(10,2))as total_sales,
cast(avg(rating) as decimal(10,2)) as avg_rating,
cast(avg(sales) as decimal(10,2)) as avg_sales,
count(*) as Number_of_items
from brothers_data
where outlet_establishment_year=2020
group by item_type
order by total_sales desc

--Bottom 5
select top 5 item_type , 
cast(sum(sales) as decimal(10,2))as total_sales,
cast(avg(rating) as decimal(10,2)) as avg_rating,
cast(avg(sales) as decimal(10,2)) as avg_sales,
count(*) as Number_of_items
from brothers_data
where outlet_establishment_year=2020
group by item_type
order by total_sales

--Above commands with 2 columns- outlet_location_type and item_fat_content
select outlet_location_type , Item_fat_content , 
cast(sum(sales) as decimal(10,2))as total_sales,
cast(avg(rating) as decimal(10,2)) as avg_rating,
cast(avg(sales) as decimal(10,2)) as avg_sales,
count(*) as Number_of_items
from brothers_data
group by item_fat_content, outlet_location_type
order by total_sales

--Above command output aren't shown in good picture.
--we need T1,2,3 in 1 column, and LF,REG in 2,3column with total sales
--we will doing this with using pivot table in SQL
select outlet_location_type,
isnull([Low Fat],0) as Low_Fat,
isnull([Regular],0) as Regular
from
(
select outlet_location_type, Item_fat_content,
cast(sum(sales) as decimal(10,2)) as total_sales
from brothers_data
group by outlet_location_type, Item_fat_content
) as sourceTable
pivot
(
sum(total_sales)
for item_fat_content in ([Low Fat],[Regular])
) as pivotTable
order by outlet_location_type

--Total sales by outlet establishment year
select outlet_establishment_year , 
cast(sum(sales) as decimal(10,2))as total_sales,
cast(avg(rating) as decimal(10,2)) as avg_rating,
cast(avg(sales) as decimal(10,2)) as avg_sales,
count(*) as Number_of_items
from brothers_data
group by outlet_establishment_year
order by outlet_establishment_year 

--Sales and Percentage of total sales by Outlet size
--also contain window function i.e over()
select
outlet_size , 
cast(sum(sales) as decimal(10,2))as total_sales,
cast((sum(sales) *100.0/sum(sum(sales)) over()) as decimal(10,2)) as sales_percentage
from brothers_data
group by outlet_size
order by total_sales ;

--Sales & percentage by outlet location
select outlet_location_type , 
cast(sum(sales) as decimal(10,2))as total_sales,
cast((sum(sales) *100.0/sum(sum(sales)) over()) as decimal(10,2)) as sales_percentage,
cast(avg(rating) as decimal(10,2)) as avg_rating,
cast(avg(sales) as decimal(10,2)) as avg_sales,
count(*) as Number_of_items
from brothers_data
group by outlet_location_type
order by total_sales

--Above command with where clause, only in 2018, we have 2 location type
select outlet_location_type , 
cast(sum(sales) as decimal(10,2))as total_sales,
cast((sum(sales) *100.0/sum(sum(sales)) over()) as decimal(10,2)) as sales_percentage,
cast(avg(rating) as decimal(10,2)) as avg_rating,
cast(avg(sales) as decimal(10,2)) as avg_sales,
count(*) as Number_of_items
from brothers_data
where outlet_establishment_year = 2018
group by outlet_location_type
order by total_sales

--Above command with outlet_type
select outlet_type , 
cast(sum(sales) as decimal(10,2))as total_sales,
cast((sum(sales) *100.0/sum(sum(sales)) over()) as decimal(10,2)) as sales_percentage,
cast(avg(rating) as decimal(10,2)) as avg_rating,
cast(avg(sales) as decimal(10,2)) as avg_sales,
count(*) as Number_of_items
from brothers_data
group by outlet_type
order by total_sales

