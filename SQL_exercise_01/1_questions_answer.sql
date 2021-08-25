-- LINK: https://en.wikibooks.org/wiki/SQL_Exercises/The_computer_store
-- 1.1 Select the names of all the products in the store.
SELECT name
FROM products

-- 1.2 Select the names and the prices of all the products in the store.
SELECT name, price
FROM products

-- 1.3 Select the name of the products with a price less than or equal to $200.
SELECT name
FROM products
WHERE price <=200

-- 1.4 Select all the products with a price between $60 and $120.
SELECT name
FROM products
WHERE price >=60 AND price <=120

-- 1.5 Select the name and price in cents (i.e., the price must be multiplied by 100).
SELECT name, price*100
FROM products

-- 1.6 Compute the average price of all the products.
SELECT AVG(price)
FROM products

-- 1.7 Compute the average price of all products with manufacturer code equal to 2.
SELECT AVG(price)
FROM products
WHERE manufacturer = 2

-- 1.8 Compute the number of products with a price larger than or equal to $180.
SELECT COUNT(code)
FROM products
WHERE price >= 180

-- 1.9 Select the name and price of all products with a price larger than or equal to $180, and sort first by price (in descending order), and then by name (in ascending order).
SELECT name, price
FROM products
WHERE price >= 180
ORDER BY price DESC, name ASC

-- 1.10 Select all the data from the products, including all the data for each product's manufacturer.
SELECT a.*, b.name 
FROM products a
JOIN Manufacturers b ON(a.manufacturer = b.code)

-- 1.11 Select the product name, price, and manufacturer name of all the products.
SELECT a.name AS products_name, b.name AS manufacturer_name
FROM products a
JOIN Manufacturers b ON(a.manufacturer = b.code)

-- 1.12 Select the average price of each manufacturer's products, showing only the manufacturer's code.
SELECT AVG(price)
FROM products
GROUP BY manufacturer

-- 1.13 Select the average price of each manufacturer's products, showing the manufacturer's name.
SELECT manufacturer 
FROM products
GROUP BY manufacturer

-- 1.14 Select the names of manufacturer whose products have an average price larger than or equal to $150.
SELECT a.*, b.name AS manufacturer_name, AVG(a.price) AS avg_price
FROM products a
JOIN Manufacturers b ON(a.manufacturer = b.code)
GROUP BY a.manufacturer
HAVING AVG(a.price) >= 150

-- 1.15 Select the name and price of the cheapest product.
SELECT *
FROM products
ORDER BY price ASC LIMIT 1

-- 1.16 Select the name of each manufacturer along with the name and price of its most expensive product.
select max_price_mapping.name as manu_name, max_price_mapping.price, products_with_manu_name.name as product_name
from 
    (SELECT Manufacturers.Name, MAX(Price) price
     FROM Products, Manufacturers
     WHERE Manufacturer = Manufacturers.Code
     GROUP BY Manufacturers.Name)
     as max_price_mapping
   left join
     (select products.*, manufacturers.name manu_name
      from products join manufacturers
      on (products.manufacturer = manufacturers.code))
      as products_with_manu_name
 on
   (max_price_mapping.name = products_with_manu_name.manu_name
    and
    max_price_mapping.price = products_with_manu_name.price); 

-- 1.17 Add a new product: Loudspeakers, $70, manufacturer 2.
INSERT INTO products
VALUE (11,"Loudspeakers",70,2)

-- 1.18 Update the name of product 8 to "Laser Printer".
UPDATE products
SET name = "Laser Printer"
WHERE code = 8

-- 1.19 Apply a 10% discount to all products.
UPDATE products
SET price = price*0.9

-- 1.20 Apply a 10% discount to all products with a price larger than or equal to $120.
UPDATE products
SET price = price*0.9
WHERE price >= 120

