
-- JOINS

-- 1. Basic Inner Join
-- Question: Retrieve a list of all products that have been purchased, including the product name and the total quantity purchased.

use learning;
select 
    p.product_name as product_name,
    sum(pu.Quantity) as Total_quantity
From Product p
INNER JOIN
Purchases pu on p.product_id = pu.product_id
GROUP BY product_name;


-- 2. Inner Join with Multiple Conditions
-- Question: Retrieve the names and emails of customers who have purchased more than 3 items in a single purchase.

use learning;
SELECT
    c.customer_name,
    c.email,
    pu.purchase_date,
    sum(pu.quantity) as Total_quantity
From Customers c 
INNER JOIN
    Purchases pu on c.customer_id = pu.customer_id
GROUP BY 
    purchase_date , c.customer_name , c.email
HAVING
    Total_quantity >=3;


-- 3. Left Join
-- Question: Get a list of all products, showing the total quantity sold for each product. Include products that haven’t been sold.

use learning;
SELECT
    p.product_name AS Product_Name,
    COALESCE(sum(pu.quantity),0) as Total_quantity
From Product p
LEFT JOIN
Purchases pu on p.product_id = pu.product_id
GROUP BY
    product_name;


-- 4. Right Join
-- Question: Find all purchases where the customer details are missing (i.e., the customer was not found in the customers table).

use learning;
SELECT
    pu.purchase_date AS purchase_date,
    COALESCE(c.customer_name,'') AS Customer_Name,
    COALESCE(c.email,'') AS email
FROM Customers c
RIGHT JOIN
Purchases pu on c.customer_id = pu.customer_id
where c.customer_name is NULL;


-- 5. Full Outer Join
-- Question: Generate a report showing all products and all purchases, even if there are no matching records in the other table.

use learning;
select 
    p.product_name AS Product_Name,
    pu.purchase_date AS purchase_date
from Product p
LEFT JOIN
Purchases pu on p.product_id = pu.product_id
union
select 
    p.product_name AS Product_Name,
    pu.purchase_date AS purchase_date
from Product p
Right JOIN
Purchases pu on p.product_id = pu.product_id;


--6. Self Join
-- Question: Find all customers who have the same name as another customer (i.e., duplicate names).


use learning;
SELECT
    c1.customer_name  as Customer_Name,
    c1.customer_id as customer_id_1,
    c1.email as email_1,
    c2.customer_id as custoemr_id_2,
    c2.email as email_2
from Customers c1
JOIN
Customers c2 on c1.customer_name = c2.customer_name
where 
    c1.customer_id <> c2.customer_id
ORDER BY customer_name;

-- Alternative

use learning;
SELECT 
    customer_name,
    count(customer_name)
from Customers
group by customer_name
HAVING count(customer_name) >=2;

-- 7. Cross Join
-- Question: Generate a list showing every possible combination of products and customers.

use learning;
SELECT 
    c.customer_name as Customer_Name,
    p.product_name
from 
Customers c
Cross JOIN 
Product p 

-- 8. Join with Aggregation
-- Question: List each customer with the total amount they’ve spent across all their purchases.

use learning;
select
    c.customer_name as Customer_Name,
    sum(p.price*pu.quantity) as Total_Amount
from
Customers c 
JOIN
Purchases pu on pu.customer_id = c.customer_id
JOIN
Product p on p.product_id = pu.product_id
GROUP BY
    c.customer_name;

-- 9. Join with Subquery
-- Question: Retrieve the details of the most recent purchase for each customer.

USE learning;
SELECT 
    c.customer_name AS Customer_Name,
    p.product_name AS Product_Name,
    pu.purchase_date AS Purchase_Date,
    pu.quantity AS Quantity
FROM 
    Customers c
JOIN
    (SELECT 
         customer_id,
         MAX(purchase_date) AS most_recent_purchase_date
     FROM 
         Purchases
     GROUP BY 
         customer_id
    ) AS recent_purchases
ON
    c.customer_id = recent_purchases.customer_id
JOIN
    Purchases pu ON pu.customer_id = recent_purchases.customer_id 
    AND pu.purchase_date = recent_purchases.most_recent_purchase_date
JOIN
    Product p ON p.product_id = pu.product_id;


-- 10. Advanced Join with CTE
-- Question: Use a Common Table Expression (CTE) to list customers who have made purchases of more than 10 units of products in total.

USE learning;

-- Define the CTE to calculate total quantity purchased by each customer
WITH TotalPurchases AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        SUM(pu.quantity) AS total_quantity
    FROM 
        Customers c
    JOIN
        Purchases pu ON c.customer_id = pu.customer_id
    GROUP BY 
        c.customer_id, c.customer_name
)

-- Use the CTE to filter customers with total quantity greater than 1000
SELECT 
    customer_name,
    total_quantity
FROM 
    TotalPurchases
WHERE 
    total_quantity > 10;

-- Practice

-- 1. Product Sales Analysis
-- A company wants to analyze its sales data. They need a report that shows the name of each product, the names of customers who purchased each product, 
-- and the total quantity purchased. Generate this report.

use learning;
select 
    p.product_name,
    c.customer_name,
    sum(pu.quantity) as Purchased_Quantity
from 
    Customers c
join 
    Purchases pu on pu.customer_id = c.customer_id
join 
    Product p on p.product_id = pu.product_id
GROUP BY
    p.product_name , c.customer_name
ORDER BY
    Purchased_Quantity desc;

-- 2. Customer Order Summary
-- You are tasked with creating a summary report that includes customer names and the total number of orders each customer has placed. 
-- The report should include customers who have placed at least one order.

use learning;
SELECT
    c.customer_name,
    count(pu.purchase_date) AS Order_Count
From 
    Purchases pu
Inner JOIN
    Customers c on pu.customer_id = c.customer_id
GROUP BY
    c.customer_name;

-- 3. Product Availability Check
-- A store wants to check if there are any products that have never been sold. Generate a list of all products 
-- and indicate whether each product has been sold or not.


use learning;
SELECT
    p.product_name,
    CASE
        WHEN pu.product_id is null then 'Not Sold'
        else 'sold'
    END as sales_update
FROM
    Product p
LEFT JOIN
    Purchases pu on p.product_id = pu.product_id
GROUP BY
    p.product_name,pu.product_id;


-- 4. Recent Purchase Details
-- The marketing team needs to find out the most recent purchase made by each customer, including the product name, purchase date, and quantity purchased.

INCOMPLETE

-- use learning;
-- SELECT
--     -- c.customer_name,
--     -- c.email,
--     p.product_name,
--     pu.purchase_date,
--     pu.quantity
-- from 
--     customers c
-- join
--     (SELECT
--         product_name,
--         max(purchase_date) as most_recent_purchase_date
--     from Purchases
--     group by customer_id) as new_table
-- JOIN
-- Purchases pu on p.product_id = pu.product_id and pu,purchase_date = new_table.most_recent_purchase_date
-- join 
-- product p as p.product_id = pu.product_id;

-- 5. Customer Purchase History
-- Create a report that shows each customer along with the names of all products they have purchased and the dates of those purchases. 
-- Include customers who have made multiple purchases.

use learning;
SELECT
    c.customer_name,
    p.product_name,
    pu.purchase_date
from 
    Customers c
join 
    Purchases pu on pu.customer_id = c.customer_id
join 
    Product p on p.product_id = pu.product_id
ORDER BY
    c.customer_name;


-- 6. Sales Performance Report
-- Generate a report that lists all products along with their sales performance. 
-- The report should include the total quantity sold and the average price per product, even if some products have not been sold.

use learning;
SELECT
    p.product_name,
    coalesce(sum(pu.quantity),0) as quantity,
    round(COALESCE(sum(p.price*pu.quantity),0)/nullif(sum(pu.quantity),0),2) as money
FROM
    Product p
Left JOIN
    Purchases pu on p.product_id = pu.product_id
GROUP BY
    p.product_name
ORDER BY
    money desc;

-- 7. Missing Product Information
-- Identify any purchases where the product information is missing. Generate a report that includes purchase details 
-- with a note indicating the absence of product information.

use learning;
SELECT
    pu.purchase_date,
    case
        when p.product_name is null then 'Not Found'
        else 'found'
    END as data_set
FROM Product p
LEFT JOIN
Purchases pu on pu.product_id = p.product_id
where p.product_name = 'Not Found';

USE learning;

SELECT
    pu.purchase_date,
    pu.customer_id,
    pu.product_id,
    CASE
        WHEN p.product_name IS NULL THEN 'Not Found'
        ELSE 'Found'
    END AS data_set
FROM
    Purchases pu
LEFT JOIN
    Product p ON pu.product_id = p.product_id
WHERE
    p.product_name IS NULL;


-- 8. Customer Purchase Frequency
-- You need to analyze how frequently customers make purchases. Create a report that lists each customer with the number of purchases they have made, 
-- including customers with no purchases.


use learning;
SELECT
    c.customer_id,
    c.customer_name,
    COALESCE(count(pu.purchase_date),0) as counting
FROM
    Purchases pu
Right JOIN
    Customers c on c.customer_id = pu.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY
    counting desc;

-- 9. Product and Customer Overlap
-- Create a report that shows which products have been purchased by which customers, including cases where 
-- some products have been purchased by multiple customers.


USE learning;
SELECT
    c.customer_name,
    p.product_name,
    pu.purchase_date
FROM
    Customers c
JOIN
    Purchases pu on pu.customer_id = c.customer_id
JOIN
    Product p on p.product_id = pu.product_id
ORDER BY
    C.customer_name;


-- 10. Purchase Trends Analysis
-- A data analyst wants to understand trends in purchase behavior. Generate a report that includes all purchases with the customer name, 
-- product name, purchase date, and quantity. Include purchases from all available data.


USE learning;
SELECT
    c.customer_name,
    p.product_name,
    pu.purchase_date,
    pu.quantity as total_quantity
FROM
    Purchases pu
LEFT JOIN
    Product p on p.product_id = pu.product_id
LEFT JOIN
    Customers c on c.customer_id = pu.customer_id;

-- LEVEL2 Practice

-- 1. Inventory Insights

-- A store manager wants to analyze the inventory levels of products to ensure stock availability. 
-- Generate a report showing the product name, the quantity sold, and whether each product has low stock (quantity sold is less than 50 units). 
-- Include products that have never been sold.

use learning;
SELECT
    p.product_name,
    COALESCE(sum(pu.quantity),0) as Quantiy_Sold,
    CASE
        WHEN COALESCE(sum(pu.quantity),0)<50 THEN 'Low Stock'
        ELSE 'Good Stock'
    END as Stock_Available
FROM
    Product p
LEFT JOIN
    Purchases pu on pu.product_id = p.product_id
GROUP BY
    p.product_name;


-- 2. Customer Loyalty Check

-- The marketing team wants to identify loyal customers. 
-- Create a report listing customer names and the number of different products they have purchased. 
-- The team is particularly interested in customers who have purchased at least five different products.

use learning;
select
    c.customer_name,
    count(DISTINCT(p.product_name)) as counting
From
    Purchases pu
JOIN
    Customers c on pu.customer_id = c.customer_id
JOIN
    Product p on pu.product_id = p.product_id
GROUP BY
    c.customer_name
HAVING
    count(DISTINCT(p.product_name)) >= 5
ORDER BY
    counting DESC;


-- 3. Multi-Customer Product Purchases

-- The sales team wants to know which products are frequently purchased by multiple customers. 
-- Generate a report showing the product names and the number of unique customers who have purchased each product.


use learning;
SELECT
    p.product_name,
    count(DISTINCT(c.customer_id)) as Unique_Customer_Count
FROM
    Purchases pu
JOIN
    Customers c on c.customer_id = pu.customer_id
JOIN
    Product p on p.product_id = pu.product_id
GROUP BY
    p.product_name
ORDER BY
    Unique_Customer_Count DESC;


-- 4. Purchase Trends by Month

-- A data analyst is examining monthly purchase trends. 
-- Create a report showing the total quantity of products purchased each month and the corresponding customer names.


use learning;
SELECT
    year(pu.purchase_date),
    p.product_name,
    MONTHNAME(pu.purchase_date),
    COALESCE(sum(pu.quantity),0) as Total_quantity
FROM 
    Purchases pu
RIGHT JOIN
    Product p on p.product_id = pu.product_id
GROUP BY
    p.product_name,
    year(pu.purchase_date),
    MONTHNAME(pu.purchase_date)
ORDER BY
    year(pu.purchase_date),
    p.product_name,
    Total_quantity desc;


-- 5. Unlinked Purchases

-- Sometimes, purchases are recorded without linking to specific products or customers. 
-- Identify any purchases that are not linked to both a customer and a product, and generate a report showing the purchase details.


use learning;
SELECT
    pu.purchase_date,
    pu.product_id
FROM
    Purchases pu 
LEFT JOIN
    Product p on p.product_id = pu.product_id
LEFT JOIN
    Customers c on pu.customer_id = pu.customer_id
WHERE
    p.product_id is null or c.customer_id is null;

-- 6. Products Bought Together

-- The marketing department is interested in identifying products that are often bought together by the same customer. 
-- Generate a report showing pairs of products that have been purchased together by at least one customer.

use learning;
SELECT
    p1.product_name as Product1,
    p2.product_name as Product2,
    count(*)
FROM
    Purchases Pu1
JOIN
    Product p1 on p1.product_id = pu1.product_id
JOIN
    Purchases pu2 on pu1.purchase_date = pu2.purchase_date and pu1.customer_id = pu2.customer_id
JOIN
    Product p2 on p2.product_id = pu2.product_id
WHERE
    pu1.product_id<>pu2.product_id
GROUP BY
    p1.product_name,
    p2.product_name 
ORDER BY
    count(*);


-- 7. Product and Customer Diversity

-- A company wants to measure the diversity of its product offerings. 
-- Create a report showing the number of different products purchased by each customer, along with the total amount spent. 
-- Include customers who have not made any purchases.


use learning;
SELECT
    c.customer_name,
    count(product_name) as Products,
    round(COALESCE(sum(p.price*pu.quantity),0),0) as Total_Spend
From 
    Customers c
LEFT JOIN
    Purchases pu on c.customer_id = pu.customer_id
LEFT JOIN
    Product p on p.product_id = pu.product_id
GROUP BY
    c.customer_name
ORDER BY
    Products DESC;
