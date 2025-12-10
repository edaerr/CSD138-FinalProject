/*
CSD 138 Final Group Project - SweetScoops Ice Cream Shop

Team Members / Roles
- Project Manager (PM): Eda Er
- Team Member: Reza Safari
- Team Member: Intrayut Raksasab

Who worked on what:
- Eda Er (PM): Documentation, business description, Information Literacy work,
               GitHub repo setup, final proofreading & submission.
- Reza Safari & Intrayut Raksasab: Database design & inserts, verification queries, 
               final project programming problems (indexes, subquery, view,
               stored procedure, stored function, multi-table query),
               and backup/restore testing.

Business Summary:
SweetScoops is a small, community-focused ice cream shop that offers a variety of handcrafted flavors, seasonal specials, and customizable dessert options. 
The business aims to provide a friendly and welcoming environment for families, students, and local visitors while maintaining consistent product quality and efficient service.

To support its growth, SweetScoops needs a reliable database system that can manage daily business operations such as tracking products, customers, employees, orders, and payments.
 A well-designed relational database will help the shop reduce errors, speed up order processing, and maintain accurate inventory records.
 It will also support business decision-making by allowing the owners to analyze best-selling flavors, customer purchasing habits, and staffing needs during busy hours.

This project focuses on designing and implementing a functional database for SweetScoops using SQL. 
The system includes multiple tables (employees, customers, products, orders, and order_items), along with advanced features such as indexes, stored procedures, stored functions, and views to optimize performance and improve usability.
 By building this database, our team provides SweetScoops with a scalable and maintainable data solution suitable for real-world operations.
 
 Documen Section:
 The purpose of this project is to design and implement a fully functional relational database system for SweetScoops, a small local ice cream shop. 
 The database supports essential business operations such as managing customers, employees, products, orders, and order items. 
 The goal is to create a system that is accurate, efficient, and easy to maintain while demonstrating core database design and SQL programming skills.

The project begins with the creation of a multi-table schema that follows relational database design principles. 
Primary keys, foreign keys, and relationships between tables were carefully structured to ensure data consistency and referential integrity. 
Sample data was inserted to allow the team to test the system and validate that all queries and programming features function correctly.

Beyond basic table creation, the project includes several advanced SQL components required for the final assessment. These include:
	•	Indexes: Created to improve query performance and speed up data retrieval for frequently accessed columns.
	•	Subquery: Developed to demonstrate the use of nested SELECT statements to extract specific business insights.
	•	Updatable View: Implemented to allow controlled, simplified access to customer records while restricting unnecessary fields.
	•	Stored Procedure: Designed to return detailed order information by customer ID and illustrate procedural logic in SQL.
	•	Stored Function: Used to calculate the total paid amount for a given order, demonstrating reusable server-side computation.
	•	Multi-Table Evaluation Query: A final analytic query that joins multiple tables to provide meaningful business insights.

Together, these elements demonstrate a complete SQL solution that not only supports SweetScoops’ operational needs but also provides tools for data analysis and business decision-making. 
The final script is designed to run from start to finish without errors, recreating the entire database, inserting data, and executing all programming components successfully.

Data Sources:
All data in this database is fictional and created by the team for academic use
only. No public or licensed datasets are used.

This script includes:
1. Midterm database schema + seed data (midterm_icecream_db)
2. Verification queries for constraints and row counts
3. Final Group Project Programming Problems for SweetScoops:
   - Indexes
   - Subquery
   - Updatable Single Table View
   - Stored Procedure
   - Stored Function
4. Multi-Table Evaluation & Synthesis problem in a separate database
   (BusinessAnalytics) using GROUP BY WITH ROLLUP.
*/

/* =======================================================================
   SECTION 1: MIDTERM GROUP PROJECT SCHEMA & DATA  (SweetScoops)
   ======================================================================= */

-- Midterm Group Project SQL
-- Business: "SweetScoops" Ice Cream Shop
-- Author: Reza Safari, Eda Er

DROP DATABASE IF EXISTS midterm_icecream_db;
CREATE DATABASE midterm_icecream_db 
  CHARACTER SET utf8mb4 
  COLLATE utf8mb4_0900_ai_ci;

USE midterm_icecream_db;

/* =======================
   TABLES
   ======================= */

-- Employees (1→Many Orders)
CREATE TABLE employees (
  employee_id INT PRIMARY KEY AUTO_INCREMENT,
  first_name  VARCHAR(50) NOT NULL,
  last_name   VARCHAR(50) NOT NULL,
  email       VARCHAR(100) NOT NULL,
  role        VARCHAR(20)  NOT NULL,
  hire_date   DATE         NOT NULL,
  hourly_rate DECIMAL(6,2) NOT NULL,
  CONSTRAINT UQ_employees_email UNIQUE (email),
  CONSTRAINT CK_employees_role   CHECK (role IN ('CASHIER','MANAGER','STAFFER')),
  CONSTRAINT CK_employees_pay    CHECK (hourly_rate > 0)
) ENGINE=InnoDB;

-- Customers
CREATE TABLE customers (
  customer_id INT PRIMARY KEY AUTO_INCREMENT,
  first_name  VARCHAR(50) NOT NULL,
  last_name   VARCHAR(50) NOT NULL,
  email       VARCHAR(100) NOT NULL,
  phone       VARCHAR(20),
  status      VARCHAR(10)  NOT NULL DEFAULT 'ACTIVE',
  created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT UQ_customers_email UNIQUE (email),
  CONSTRAINT CK_customers_status CHECK (status IN ('ACTIVE','INACTIVE'))
) ENGINE=InnoDB;

-- Products (menu items)
CREATE TABLE products (
  product_id INT PRIMARY KEY AUTO_INCREMENT,
  name       VARCHAR(80) NOT NULL,
  category   VARCHAR(30) NOT NULL,
  price      DECIMAL(6,2) NOT NULL,
  is_active  TINYINT      NOT NULL DEFAULT 1,
  created_at DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT UQ_products_name UNIQUE (name),
  CONSTRAINT CK_products_price CHECK (price > 0)
) ENGINE=InnoDB;

-- Orders (parent of order_items)
CREATE TABLE orders (
  order_id    INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT NOT NULL,
  employee_id INT NOT NULL,
  order_date  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status      VARCHAR(12) NOT NULL DEFAULT 'NEW',
  CONSTRAINT CK_orders_status CHECK (status IN ('NEW','PAID','CANCELLED')),
  CONSTRAINT FK_orders_customers FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT FK_orders_employees FOREIGN KEY (employee_id)
    REFERENCES employees(employee_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Associative table: Orders ↔ Products
CREATE TABLE order_items (
  order_item_id INT PRIMARY KEY AUTO_INCREMENT,
  order_id      INT NOT NULL,
  product_id    INT NOT NULL,
  quantity      INT NOT NULL,
  unit_price    DECIMAL(6,2) NOT NULL,
  CONSTRAINT FK_order_items_orders   FOREIGN KEY (order_id)
    REFERENCES orders(order_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT FK_order_items_products FOREIGN KEY (product_id)
    REFERENCES products(product_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT CK_order_items_qty   CHECK (quantity BETWEEN 1 AND 20),
  CONSTRAINT CK_order_items_price CHECK (unit_price > 0),
  CONSTRAINT UQ_order_items_order_product UNIQUE (order_id, product_id)
) ENGINE=InnoDB;

/* =======================
   SEED DATA
   ======================= */

-- Employees (5)
INSERT INTO employees (first_name,last_name,email,role,hire_date,hourly_rate) VALUES
('Ava','Nguyen','ava.nguyen@sweetscoops.local','MANAGER','2023-01-10',28.50),
('Leo','Martinez','leo.martinez@sweetscoops.local','CASHIER','2024-03-02',20.25),
('Maya','Singh','maya.singh@sweetscoops.local','STAFFER','2024-04-15',18.75),
('Noah','Brooks','noah.brooks@sweetscoops.local','STAFFER','2024-05-21',18.25),
('Ivy','Chen','ivy.chen@sweetscoops.local','CASHIER','2024-06-05',19.50);

-- Customers (10)
INSERT INTO customers (first_name,last_name,email,phone,status) VALUES
('Reza','Safari','reza.safari@example.com','206-555-1001','ACTIVE'),
('Eda','Er','eda.er@example.com','206-555-1002','ACTIVE'),
('Sam','Lee','sam.lee@example.com','206-555-1003','ACTIVE'),
('Nora','Kim','nora.kim@example.com','206-555-1004','ACTIVE'),
('Omar','Ali','omar.ali@example.com','206-555-1005','ACTIVE'),
('Liam','Wright','liam.wright@example.com','206-555-1006','ACTIVE'),
('Ella','Price','ella.price@example.com','206-555-1007','ACTIVE'),
('Zoe','Rivera','zoe.rivera@example.com','206-555-1008','ACTIVE'),
('Kai','Johnson','kai.johnson@example.com','206-555-1009','INACTIVE'),
('Mila','Young','mila.young@example.com','206-555-1010','ACTIVE');

-- Products (12)
INSERT INTO products (name,category,price) VALUES
('Vanilla Scoop','Scoop',3.50),
('Chocolate Scoop','Scoop',3.75),
('Strawberry Scoop','Scoop',3.75),
('Mint Chip Scoop','Scoop',3.95),
('Cookie Dough Scoop','Scoop',4.25),
('Waffle Cone','AddOn',1.25),
('Sprinkles','AddOn',0.50),
('Hot Fudge','AddOn',0.95),
('Banana Split','Sundae',7.50),
('Brownie Sundae','Sundae',6.95),
('Milkshake Vanilla','Drink',5.25),
('Affogato','Drink',4.95);

-- Orders (12)
INSERT INTO orders (customer_id, employee_id, status, order_date) VALUES
(1,1,'PAID','2025-10-01 13:05:00'),
(2,2,'PAID','2025-10-01 13:10:00'),
(3,2,'PAID','2025-10-02 11:00:00'),
(4,3,'PAID','2025-10-02 19:15:00'),
(5,4,'PAID','2025-10-03 12:40:00'),
(6,5,'PAID','2025-10-03 20:20:00'),
(7,2,'PAID','2025-10-04 14:55:00'),
(8,3,'PAID','2025-10-04 15:05:00'),
(9,4,'CANCELLED','2025-10-05 10:20:00'),
(10,5,'PAID','2025-10-05 16:45:00'),
(1,2,'PAID','2025-10-06 12:30:00'),
(2,1,'NEW','2025-10-06 12:45:00');

-- Order Items (≥1 per order)
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1,1,2,3.50), (1,6,1,1.25),
(2,9,1,7.50),
(3,10,1,6.95), (3,7,1,0.50),
(4,11,1,5.25),
(5,5,1,4.25), (5,6,1,1.25), (5,8,1,0.95),
(6,12,1,4.95),
(7,2,1,3.75), (7,6,1,1.25),
(8,3,1,3.75), (8,7,1,0.50),
(9,4,1,3.95),
(10,10,1,6.95),
(11,1,1,3.50), (11,8,1,0.95),
(12,2,1,3.75);

/* =======================
   VERIFICATION QUERIES
   ======================= */

SET @db := DATABASE();

-- Primary Keys
SELECT TABLE_NAME, COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE CONSTRAINT_NAME = 'PRIMARY'
  AND TABLE_SCHEMA = @db;

-- Foreign Keys
SELECT
  kcu.TABLE_NAME   AS `Table`,
  kcu.COLUMN_NAME  AS `Column`,
  kcu.CONSTRAINT_NAME AS `Constraint`,
  kcu.REFERENCED_TABLE_NAME AS `Referenced Table`,
  kcu.REFERENCED_COLUMN_NAME AS `Referenced Column`
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE kcu
WHERE kcu.REFERENCED_TABLE_NAME IS NOT NULL
  AND kcu.TABLE_SCHEMA = @db;

-- Unique Constraints
SELECT
  tc.TABLE_NAME,
  kcu.COLUMN_NAME,
  tc.CONSTRAINT_NAME
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE kcu
  ON tc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME
  AND tc.TABLE_NAME = kcu.TABLE_NAME
WHERE tc.CONSTRAINT_TYPE = 'UNIQUE'
  AND tc.TABLE_SCHEMA = @db;

-- Check Constraints
SELECT
  tc.TABLE_NAME,
  cc.CONSTRAINT_NAME,
  cc.CHECK_CLAUSE
FROM INFORMATION_SCHEMA.CHECK_CONSTRAINTS cc
JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
  ON cc.CONSTRAINT_NAME = tc.CONSTRAINT_NAME
WHERE tc.CONSTRAINT_TYPE = 'CHECK'
  AND cc.CONSTRAINT_SCHEMA = @db;

-- Default Constraints (columns with defaults)
SELECT TABLE_NAME, COLUMN_NAME, COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_DEFAULT IS NOT NULL
  AND TABLE_SCHEMA = @db;

-- Step 7: Counts + sample rows (parents first)
SELECT 'employees' AS table_name, COUNT(*) AS row_count FROM employees; SELECT * FROM employees;
SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers; SELECT * FROM customers;
SELECT 'products'  AS table_name, COUNT(*) AS row_count FROM products;  SELECT * FROM products;
SELECT 'orders'    AS table_name, COUNT(*) AS row_count FROM orders;    SELECT * FROM orders;
SELECT 'order_items' AS table_name, COUNT(*) AS row_count FROM order_items; SELECT * FROM order_items;

/* =======================================================================
   SECTION 2: FINAL GROUP PROJECT PROGRAMMING PROBLEMS (SweetScoops)
   ======================================================================= */

USE midterm_icecream_db;

/* -----------------------------------------------------------------------
   Problem 1: Indexes
   ----------------------------------------------------------------------- */

-- Indexes created before other final-project program units.
-- Naming convention: idx_<table>_<column(s)>

CREATE INDEX idx_orders_customer_id
  ON orders (customer_id);

CREATE INDEX idx_orders_employee_id
  ON orders (employee_id);

CREATE INDEX idx_order_items_order_product
  ON order_items (order_id, product_id);

CREATE INDEX idx_products_category
  ON products (category);

/* -----------------------------------------------------------------------
   Problem 2: Subquery
   Goal: List customers whose total PAID spending is above the overall
         average order total.
   ----------------------------------------------------------------------- */

-- Each order total is calculated from order_items (quantity * unit_price).
-- The subquery computes the average order total across all PAID orders.

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS customer_total
FROM customers c
JOIN orders o
  ON o.customer_id = c.customer_id
JOIN order_items oi
  ON oi.order_id = o.order_id
WHERE o.status = 'PAID'
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(oi.quantity * oi.unit_price) >
       (
         SELECT AVG(order_total)
         FROM (
           SELECT SUM(oi2.quantity * oi2.unit_price) AS order_total
           FROM orders o2
           JOIN order_items oi2
             ON oi2.order_id = o2.order_id
           WHERE o2.status = 'PAID'
           GROUP BY o2.order_id
         ) AS order_totals
       );

/* -----------------------------------------------------------------------
   Problem 3: Updatable Single Table View
   Requirements:
   - Single base table
   - SELECT includes a WHERE clause
   - No CHECK OPTION
   - Demonstrate: query view, update row via view, re-query.
   ----------------------------------------------------------------------- */

-- View of currently ACTIVE customers
CREATE OR REPLACE VIEW vw_active_customers AS
SELECT customer_id, first_name, last_name, status
FROM customers
WHERE status = 'ACTIVE';

-- Step 1: Query the view
SELECT * FROM vw_active_customers;

-- Step 2: Update a record through the view
-- (Adjust customer_id for testing as needed.)
UPDATE vw_active_customers
SET status = 'INACTIVE'
WHERE customer_id = 1;

-- Step 3: Re-query to confirm update
SELECT * 
FROM vw_active_customers
WHERE customer_id = 1;

/* -----------------------------------------------------------------------
   Problem 4: Stored Procedure
   Requirements:
   - Use CALL to execute
   - Must calculate and print a value
   - Accepts a parameter
   ----------------------------------------------------------------------- */

DELIMITER //

CREATE PROCEDURE sp_print_order_total (
    IN  p_order_id     INT,
    OUT p_order_total  DECIMAL(10,2)
)
BEGIN
    DECLARE v_exists INT DEFAULT 0;

    -- Check if the order exists
    SELECT COUNT(*)
    INTO v_exists
    FROM orders
    WHERE order_id = p_order_id;

    IF v_exists = 0 THEN
        SET p_order_total = 0.00;
    ELSE
        -- Calculate total as SUM(quantity * unit_price)
        SELECT IFNULL(SUM(quantity * unit_price), 0)
        INTO p_order_total
        FROM order_items
        WHERE order_id = p_order_id;
    END IF;

    -- "Print" the value as a result set
    SELECT p_order_id AS order_id,
           p_order_total AS order_total;
END//
DELIMITER ;

-- Test the stored procedure
CALL sp_print_order_total(1, @order_total);
SELECT @order_total AS last_order_total;

/* -----------------------------------------------------------------------
   Problem 5: Stored Function
   Requirements:
   - Called inside a SELECT
   - Must calculate and return a value
   - Uses IF and SELECTs
   ----------------------------------------------------------------------- */

DELIMITER //

CREATE FUNCTION fn_customer_total_spent (
    p_customer_id INT
) RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(10,2);

    -- Sum of all PAID orders for the given customer
    SELECT SUM(oi.quantity * oi.unit_price)
    INTO v_total
    FROM orders o
    JOIN order_items oi
      ON oi.order_id = o.order_id
    WHERE o.customer_id = p_customer_id
      AND o.status = 'PAID';

    IF v_total IS NULL THEN
        SET v_total = 0.00;
    END IF;

    RETURN v_total;
END//
DELIMITER ;

-- Example usage of the stored function
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    fn_customer_total_spent(c.customer_id) AS total_spent
FROM customers c
ORDER BY total_spent DESC;

/* =======================================================================
   SECTION 3: MULTI-TABLE QUERY (EVALUATION & SYNTHESIS)
   Database: BusinessAnalytics
   ======================================================================= */

 /*
 Business Scenario:
 You’ve been hired as a data analyst for a retail company specializing in
 electronics and furniture. Leadership wants to identify which product groups
 are generating strong revenue from high-priced items to guide pricing and
 inventory strategy.

 Analytical Task:
 - Join Item, Subcategory, and Category tables
 - Include only items with price > 250
 - Calculate total revenue (SUM(price)) for each Category/Subcategory
 - Use GROUP BY WITH ROLLUP for subtotals and grand total
 - Use HAVING to keep only groups with total > 1000
 */

-- Create and use the analytics database
DROP DATABASE IF EXISTS BusinessAnalytics;
CREATE DATABASE BusinessAnalytics;
USE BusinessAnalytics;

-- Hierarchical tables
CREATE TABLE Category (
    category_id   INT AUTO_INCREMENT,
    category_name VARCHAR(50),
    CONSTRAINT PK_Category PRIMARY KEY (category_id)
);

CREATE TABLE Subcategory (
    subcategory_id   INT AUTO_INCREMENT,
    subcategory_name VARCHAR(50),
    category_id      INT,
    CONSTRAINT PK_Subcategory PRIMARY KEY (subcategory_id),
    CONSTRAINT FK_Subcategory_Category 
        FOREIGN KEY (category_id) REFERENCES Category(category_id)
);

CREATE TABLE Item (
    item_id       INT AUTO_INCREMENT,
    item_name     VARCHAR(50),
    subcategory_id INT,
    price         DECIMAL(10,2),
    CONSTRAINT PK_Item PRIMARY KEY (item_id),
    CONSTRAINT FK_Item_Subcategory 
        FOREIGN KEY (subcategory_id) REFERENCES Subcategory(subcategory_id)
);

-- Seed data: Electronics + Furniture categories and subcategories
INSERT INTO Category (category_name) VALUES
  ('Electronics'),
  ('Furniture');

INSERT INTO Subcategory (subcategory_name, category_id) VALUES
  ('Laptops',      1),
  ('Televisions',  1),
  ('Smartphones',  1),
  ('Sofas',        2),
  ('Tables',       2);

-- Items with a mix of high- and lower-priced products
INSERT INTO Item (item_name, subcategory_id, price) VALUES
  ('Ultrabook 13"',          1,  999.99),
  ('Gaming Laptop 15"',      1, 1499.99),
  ('Business Laptop 14"',    1, 1249.00),
  ('4K OLED TV',             2, 1799.99),
  ('55\" LED TV',            2,  899.99),
  ('Budget Smartphone',      3,  399.99),
  ('Flagship Smartphone',    3, 1099.00),
  ('Leather Sofa',           4, 1299.99),
  ('Sectional Sofa',         4, 1899.50),
  ('Dining Table',           5,  799.00),
  ('Coffee Table',           5,  299.99),
  ('Side Table',             5,  199.99);  -- under 250, excluded by WHERE

-- Disable ONLY_FULL_GROUP_BY to match class exercise and allow ROLLUP usage
SET SESSION sql_mode = (SELECT REPLACE(@@SESSION.sql_mode, 'ONLY_FULL_GROUP_BY', ''));
-- (Optional) Check current sql_mode
SELECT @@SESSION.sql_mode;

-- Analytical query with ROLLUP implemented as a VIEW
CREATE OR REPLACE VIEW vw_total_price_by_category_subcategory AS
SELECT
    c.category_name,
    s.subcategory_name,
    ROUND(SUM(i.price), 2) AS total_price
FROM Item i
JOIN Subcategory s
  ON i.subcategory_id = s.subcategory_id
JOIN Category c
  ON s.category_id = c.category_id
WHERE
    i.price > 250                       -- high-priced items only
GROUP BY
    c.category_name,
    s.subcategory_name WITH ROLLUP
HAVING
    SUM(i.price) > 1000                 -- keep only strong-revenue groups
ORDER BY
    CASE
        WHEN c.category_name IS NULL THEN 2         -- grand total last
        WHEN s.subcategory_name IS NULL THEN 1      -- subtotals after details
        ELSE 0                                      -- detail rows first
    END,
    c.category_name,
    s.subcategory_name;

-- Final result set for evaluation & synthesis
SELECT * FROM vw_total_price_by_category_subcategory;

-- Re-enable ONLY_FULL_GROUP_BY (default mode)
SET SESSION sql_mode = CONCAT_WS(',', @@SESSION.sql_mode, 'ONLY_FULL_GROUP_BY');
-- (Optional) Check restored sql_mode
SELECT @@SESSION.sql_mode;

-- End of CSD138FinalProject.sql
