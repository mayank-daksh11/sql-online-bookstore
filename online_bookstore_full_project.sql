-- ============================================
-- 📊 ONLINE BOOKSTORE DATABASE PROJECT
-- ============================================

-- 🔹 1. CREATE DATABASE
CREATE DATABASE OnlineBookstore;

-- 🔹 2. USE DATABASE
\c OnlineBookstore;

-- ============================================
-- 🔹 3. CREATE TABLES
-- ============================================

DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10,2),
    Stock INT
);

DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(100)
);

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10,2)
);

-- ============================================
-- 🔹 4. BASIC QUERIES
-- ============================================

-- 1. Fiction Books
SELECT * FROM Books WHERE genre = 'Fiction';

-- 2. Books after 1950
SELECT * FROM Books WHERE published_year > 1950;

-- 3. Customers from Canada
SELECT * FROM Customers WHERE country = 'Canada';

-- 4. Orders in November
SELECT * FROM Orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5. Total Stock
SELECT SUM(stock) AS total_stock FROM Books;

-- 6. Most Expensive Book
SELECT * FROM Books ORDER BY price DESC LIMIT 1;

-- 7. Orders with Quantity > 1
SELECT * FROM Orders WHERE quantity > 1;

-- 8. Orders above $20
SELECT * FROM Orders WHERE total_amount > 20;

-- 9. Distinct Genres
SELECT DISTINCT genre FROM Books;

-- 10. Lowest Stock Books
SELECT * FROM Books ORDER BY stock ASC LIMIT 5;

-- ============================================
-- 🔹 5. INTERMEDIATE QUERIES
-- ============================================

-- 11. Total Revenue (Correct)
SELECT SUM(total_amount) AS total_revenue FROM Orders;

-- 12. Books Sold per Genre
SELECT b.genre, SUM(o.quantity) AS total_sold
FROM Orders o
JOIN Books b ON o.book_id = b.book_id
GROUP BY b.genre;

-- 13. Average Price (Fantasy)
SELECT AVG(price) FROM Books WHERE genre = 'Fantasy';

-- 14. Customers with 2+ Orders
SELECT c.name, COUNT(o.order_id) AS order_count
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY c.name
HAVING COUNT(o.order_id) >= 2;

-- 15. Most Ordered Book
SELECT b.title, COUNT(o.order_id) AS order_count
FROM Orders o
JOIN Books b ON o.book_id = b.book_id
GROUP BY b.title
ORDER BY order_count DESC
LIMIT 1;

-- 16. Top 3 Expensive Fantasy Books
SELECT * FROM Books
WHERE genre = 'Fantasy'
ORDER BY price DESC
LIMIT 3;

-- 17. Quantity Sold by Author
SELECT b.author, SUM(o.quantity) AS total_sold
FROM Orders o
JOIN Books b ON o.book_id = b.book_id
GROUP BY b.author;

-- 18. Cities with High Spending
SELECT DISTINCT c.city
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
WHERE o.total_amount > 30;

-- ============================================
-- 🔹 6. ADVANCED QUERIES
-- ============================================

-- 19. Top Spending Customer
SELECT c.name, SUM(o.total_amount) AS total_spent
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY c.name
ORDER BY total_spent DESC
LIMIT 1;

-- 20. Stock Remaining
SELECT 
    b.title,
    b.stock,
    COALESCE(SUM(o.quantity),0) AS sold_quantity,
    b.stock - COALESCE(SUM(o.quantity),0) AS remaining_stock
FROM Books b
LEFT JOIN Orders o ON b.book_id = o.book_id
GROUP BY b.title, b.stock;

-- 21. Monthly Sales Trend
SELECT 
    DATE_TRUNC('month', order_date) AS month,
    SUM(total_amount) AS monthly_sales
FROM Orders
GROUP BY month
ORDER BY month;

-- 22. Revenue by Genre
SELECT 
    b.genre,
    SUM(o.total_amount) AS revenue
FROM Orders o
JOIN Books b ON o.book_id = b.book_id
GROUP BY b.genre
ORDER BY revenue DESC;

-- 23. City-wise Revenue Ranking
SELECT 
    c.city,
    SUM(o.total_amount) AS revenue,
    RANK() OVER (ORDER BY SUM(o.total_amount) DESC) AS rank
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY c.city;

-- 24. Top 5 Best-Selling Books
SELECT 
    b.title,
    SUM(o.quantity) AS total_sold
FROM Orders o
JOIN Books b ON o.book_id = b.book_id
GROUP BY b.title
ORDER BY total_sold DESC
LIMIT 5;

-- 25. Average Order Value
SELECT AVG(total_amount) AS avg_order_value FROM Orders;









