-- Database and table creation

CREATE DATABASE Sql_project_1;

-- Order_details Table creation
CREATE TABLE sql_project_1.Dominos_pizza_order_details
(
order_details_id INT  PRIMARY KEY,	
order_id	INT,
pizza_id	VARCHAR(50),
quantity  INT
);

-- Orders Table creation
CREATE TABLE sql_project_1.Dominos_pizza_orders
(
order_id	INT  PRIMARY KEY,
date	DATE,
time    TIME
);

-- Pizza_types Table creation
CREATE TABLE sql_project_1.Dominos_pizza_orders_Pizza_types
(
pizza_type_id	VARCHAR(100)  PRIMARY KEY,
name	       VARCHAR(100),
category	VARCHAR(100),
ingredients    VARCHAR(100)
);

-- Pizza Table creation
CREATE TABLE sql_project_1.Dominos_pizza_orders_pizzas
(
    pizza_id VARCHAR(100) PRIMARY KEY,
    pizza_type_id VARCHAR(100),
    size CHAR(50),
    price FLOAT,
    FOREIGN KEY (pizza_type_id) REFERENCES sql_project_1.Dominos_pizza_orders_Pizza_types(pizza_type_id)
);

/*
Basic:
Retrieve the total number of orders placed.
Calculate the total revenue generated from pizza sales.
Identify the highest-priced pizza.
Identify the most common pizza size ordered.


Intermediate:
Join the necessary tables to find the total quantity of each pizza category ordered.
Determine the distribution of orders by hour of the day.
Join relevant tables to find the category-wise distribution of pizzas.
Determine the top 3 most ordered pizza types based on revenue.

Advanced:
Analyze the cumulative revenue generated over time.

*/

-- Retrieve the total number of orders placed.
SELECT COUNT(ORDER_ID) AS Total_Orders FROM sql_project_1.dominos_pizza_orders;

-- Calculate the total revenue generated from pizza sales.
SELECT ROUND(SUM(Price*Quantity),2) AS Total_Revenue FROM sql_project_1.dominos_pizza_order_details
JOIN sql_project_1.dominos_pizza_orders_pizzas 
ON sql_project_1.dominos_pizza_order_details.pizza_id = sql_project_1.dominos_pizza_orders_pizzas.pizza_id;

-- Identify the highest priced pizza
SELECT name , price 
FROM sql_project_1.dominos_pizza_orders_pizza_types
JOIN sql_project_1.dominos_pizza_orders_pizzas 
ON sql_project_1.dominos_pizza_orders_pizza_types.pizza_type_id = sql_project_1.dominos_pizza_orders_pizzas.pizza_type_id
ORDER BY price DESC
LIMIT 1;


-- Identify the most common pizza size ordered
SELECT size , COUNT(sql_project_1.dominos_pizza_order_details.pizza_id) AS Ordered , SUM(quantity) AS Quantity_ordered
FROM sql_project_1.dominos_pizza_order_details JOIN sql_project_1.dominos_pizza_orders_pizzas
ON sql_project_1.dominos_pizza_order_details.pizza_id = sql_project_1.dominos_pizza_orders_pizzas.pizza_id
GROUP BY size
ORDER BY COUNT(sql_project_1.dominos_pizza_order_details.pizza_id) desc;

-- Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT Category , SUM(Quantity) AS Quantity_ordered
FROM sql_project_1.dominos_pizza_order_details JOIN 
sql_project_1.dominos_pizza_orders_pizzas ON 
sql_project_1.dominos_pizza_order_details.pizza_id = sql_project_1.dominos_pizza_orders_pizzas.pizza_id
JOIN sql_project_1.dominos_pizza_orders_pizza_types ON
sql_project_1.dominos_pizza_orders_pizzas.pizza_type_id = sql_project_1.dominos_pizza_orders_pizza_types.pizza_type_id
GROUP BY category
ORDER BY SUM(quantity) DESC;

-- Determine the distribution of orders by hour of the day.
SELECT HOUR(time) AS Hour_of_day , COUNT(order_id) AS Total_orders
FROM sql_project_1.dominos_pizza_orders
GROUP BY HOUR(time);

-- Join the relevant tables and find the category-wise distribution of pizzas
SELECT 
Category , COUNT(Category) AS No_of_pizzas
FROM sql_project_1.dominos_pizza_orders_pizza_types
group by category;

-- Determine the top 3 most ordered pizza types based on revenue.
SELECT NAME , SUM(PRICE*QUANTITY) AS REVENUE
FROM sql_project_1.dominos_pizza_order_details JOIN sql_project_1.dominos_pizza_orders_pizzas
ON sql_project_1.dominos_pizza_order_details.pizza_id = sql_project_1.dominos_pizza_orders_pizzas.pizza_id
JOIN sql_project_1.dominos_pizza_orders_pizza_types ON
sql_project_1.dominos_pizza_orders_pizzas.pizza_type_id = sql_project_1.dominos_pizza_orders_pizza_types.pizza_type_id
GROUP BY NAME
ORDER BY REVENUE DESC
LIMIT 3;

-- Analyze the cumulative revenue generated over time.
SELECT date , 
ROUND(SUM(Price*quantity),2) AS Daily_revenu , 
ROUND(SUM(SUM(Price*quantity)) OVER(ORDER BY Date),2) AS Cumulative_revenue
FROM sql_project_1.dominos_pizza_order_details JOIN sql_project_1.dominos_pizza_orders_pizzas
ON sql_project_1.dominos_pizza_order_details.pizza_id = sql_project_1.dominos_pizza_orders_pizzas.pizza_id
JOIN sql_project_1.dominos_pizza_orders ON 
sql_project_1.dominos_pizza_orders.order_id = sql_project_1.dominos_pizza_order_details.order_id
group by Date
ORDER BY ROUND(SUM(Price*quantity),2)  DESC;






