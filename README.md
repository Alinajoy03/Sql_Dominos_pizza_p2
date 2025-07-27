# Sql_Dominos_pizza_p2

Project Overview:

This SQL project revolves around a database schema designed to manage and analyze data for a Dominos pizza store. The database consists of four primary tables: order_details, pizzas, orders, and pizza_types. Each table plays a crucial role in storing different facets of the business operations, from individual orders to the types of pizzas offered. Below is a detailed description of each table and its columns:

1. order_details:
   - order_details_id: A unique identifier for each entry in the order details.
   - order_id: References the ID from the orders table, linking the order detail to a specific order.
   - pizza_id: References the ID from the pizzas table, identifying which pizza was ordered.
   - quantity: The number of pizzas ordered of the specified type.

2. pizzas:
   - pizza_id: A unique identifier for each type of pizza available.
   - pizza_type_id: Links to the pizza_types table, specifying the type of pizza.
   - size: The size of the pizza (e.g., small, medium, large).
   - price: The cost of the pizza.

3. orders:
   - order_id: A unique identifier for each order placed.
   - date: The date on which the order was placed.
   - time: The time at which the order was placed.

4. pizza_types:
   - pizza_type_id: A unique identifier for each type of pizza.
   - name: The name of the pizza type (e.g., Margherita, Pepperoni).
   - category: Categorizes the pizza (e.g., Vegetarian, Non-Vegetarian).
   - ingredients: Lists the ingredients used in the pizza.

Relevance to a Pizza Sales Store Manager:

A pizza sales store manager can utilize this SQL project to extract valuable insights and conduct detailed data analysis, facilitating informed decision-making and efficient management of the store's operations. Here are a few points illustrating the importance and utility of this database for a store manager:

- Sales Analysis: By querying the order_details and pizzas tables, managers can identify the best-selling pizzas, assess revenue from different pizza sizes, and evaluate pricing strategies.
- Inventory Management: Analyzing the pizza_types and their ingredients helps in managing inventory more efficiently, ensuring that ingredients are stocked according to demand and reducing waste.
- Customer Preferences: Through data gathered in the orders and pizzas tables, managers can track customer preferences over time, adjusting the menu to cater to popular choices and experimenting with new or seasonal offerings.
- Operational Efficiency: Date and time data from the orders table allow managers to assess peak hours and staff the store appropriately, ensuring operational efficiency and customer satisfaction.
- Marketing Insights: Data analysis can also support targeted marketing campaigns, like promotions on specific types of pizzas that are popular or on days when sales are typically lower.

Conclusion:

This SQL project not only serves as a robust data management system but also as a strategic tool for business intelligence. By maintaining comprehensive data on every aspect of the store's operations, the database allows store managers to make precise adjustments to improve both customer experience and profitability. When presented on a blog, this project can provide practical insights into how structured SQL queries can be used to harness data for real business applications, making it an excellent resource for aspiring data analysts and business owners alike.

Queries

 Database creation
``` sql
CREATE DATABASE Sql_project_1;
```

 Order_details Table creation
 ``` sql
CREATE TABLE sql_project_1.Dominos_pizza_order_details
(
order_details_id INT  PRIMARY KEY,	
order_id	INT,
pizza_id	VARCHAR(50),
quantity  INT
);
```

 Orders Table creation
 ``` sql
CREATE TABLE sql_project_1.Dominos_pizza_orders
(
order_id	INT  PRIMARY KEY,
date	DATE,
time    TIME
);
```

 Pizza_types Table creation
 ```sql
CREATE TABLE sql_project_1.Dominos_pizza_orders_Pizza_types
(
pizza_type_id	VARCHAR(100)  PRIMARY KEY,
name	       VARCHAR(100),
category	VARCHAR(100),
ingredients    VARCHAR(100)
);
```

Pizzas Table creation
```sql
CREATE TABLE sql_project_1.Dominos_pizza_orders_pizzas
(
    pizza_id VARCHAR(100) PRIMARY KEY,
    pizza_type_id VARCHAR(100),
    size CHAR(50),
    price FLOAT,
    FOREIGN KEY (pizza_type_id) REFERENCES sql_project_1.Dominos_pizza_orders_Pizza_types(pizza_type_id)
);
```

Queries 

 Retrieve the total number of orders placed.
 ```sql
SELECT COUNT(ORDER_ID) AS Total_Orders FROM sql_project_1.dominos_pizza_orders;
```

 Calculate the total revenue generated from pizza sales.
 ```sql
SELECT ROUND(SUM(Price*Quantity),2) AS Total_Revenue FROM sql_project_1.dominos_pizza_order_details
JOIN sql_project_1.dominos_pizza_orders_pizzas 
ON sql_project_1.dominos_pizza_order_details.pizza_id = sql_project_1.dominos_pizza_orders_pizzas.pizza_id;
```

 Identify the highest priced pizza
 ```sql
SELECT name , price 
FROM sql_project_1.dominos_pizza_orders_pizza_types
JOIN sql_project_1.dominos_pizza_orders_pizzas 
ON sql_project_1.dominos_pizza_orders_pizza_types.pizza_type_id = sql_project_1.dominos_pizza_orders_pizzas.pizza_type_id
ORDER BY price DESC
LIMIT 1;
```

 Identify the most common pizza size ordered
 ```sql
SELECT size , COUNT(sql_project_1.dominos_pizza_order_details.pizza_id) AS Ordered , SUM(quantity) AS Quantity_ordered
FROM sql_project_1.dominos_pizza_order_details JOIN sql_project_1.dominos_pizza_orders_pizzas
ON sql_project_1.dominos_pizza_order_details.pizza_id = sql_project_1.dominos_pizza_orders_pizzas.pizza_id
GROUP BY size
ORDER BY COUNT(sql_project_1.dominos_pizza_order_details.pizza_id) desc;
```

 Join the necessary tables to find the total quantity of each pizza category ordered.
 ```sql
SELECT Category , SUM(Quantity) AS Quantity_ordered
FROM sql_project_1.dominos_pizza_order_details JOIN 
sql_project_1.dominos_pizza_orders_pizzas ON 
sql_project_1.dominos_pizza_order_details.pizza_id = sql_project_1.dominos_pizza_orders_pizzas.pizza_id
JOIN sql_project_1.dominos_pizza_orders_pizza_types ON
sql_project_1.dominos_pizza_orders_pizzas.pizza_type_id = sql_project_1.dominos_pizza_orders_pizza_types.pizza_type_id
GROUP BY category
ORDER BY SUM(quantity) DESC;
```

Determine the distribution of orders by hour of the day.
```sql
SELECT HOUR(time) AS Hour_of_day , COUNT(order_id) AS Total_orders
FROM sql_project_1.dominos_pizza_orders
GROUP BY HOUR(time);
```

Join the relevant tables and find the category-wise distribution of pizzas
```sql
SELECT 
Category , COUNT(Category) AS No_of_pizzas
FROM sql_project_1.dominos_pizza_orders_pizza_types
group by category;
```

Determine the top 3 most ordered pizza types based on revenue
```sql
SELECT NAME , SUM(PRICE*QUANTITY) AS REVENUE
FROM sql_project_1.dominos_pizza_order_details JOIN sql_project_1.dominos_pizza_orders_pizzas
ON sql_project_1.dominos_pizza_order_details.pizza_id = sql_project_1.dominos_pizza_orders_pizzas.pizza_id
JOIN sql_project_1.dominos_pizza_orders_pizza_types ON
sql_project_1.dominos_pizza_orders_pizzas.pizza_type_id = sql_project_1.dominos_pizza_orders_pizza_types.pizza_type_id
GROUP BY NAME
ORDER BY REVENUE DESC
LIMIT 3;
```

Analyze the cumulative revenue generated over time.
```sql
SELECT date , 
ROUND(SUM(Price*quantity),2) AS Daily_revenu , 
ROUND(SUM(SUM(Price*quantity)) OVER(ORDER BY Date),2) AS Cumulative_revenue
FROM sql_project_1.dominos_pizza_order_details JOIN sql_project_1.dominos_pizza_orders_pizzas
ON sql_project_1.dominos_pizza_order_details.pizza_id = sql_project_1.dominos_pizza_orders_pizzas.pizza_id
JOIN sql_project_1.dominos_pizza_orders ON 
sql_project_1.dominos_pizza_orders.order_id = sql_project_1.dominos_pizza_order_details.order_id
group by Date
ORDER BY ROUND(SUM(Price*quantity),2)  DESC;
```





