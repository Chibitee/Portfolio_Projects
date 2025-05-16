--Please make use of the AdventureWorks 2022 database:

--Question 1: Retrieve the names of all the products along with their standard costs and list prices from the "Product" table.
SELECT ProductID, Name, StandardCost, ListPrice
FROM [Production].[Product]
ORDER BY ProductID DESC;

--Question 2: Show the categories by the number of products they have in the "ProductCategory" table, along with the count of products in each category.
SELECT  PC.Name AS CategoryName, COUNT(PP.ProductID) AS ProductCount
FROM [Production].[Product] PP
JOIN  [Production].[ProductSubcategory] PS
ON PP.ProductSubcategoryID = PS.ProductSubcategoryID
JOIN [Production].[ProductCategory] PC
ON PS.ProductCategoryID = PC.ProductCategoryID
GROUP BY PC.Name
ORDER BY ProductCount DESC;

SELECT PC.ProductCategoryID, PC.Name, COUNT(PP.ProductID) AS ProductCount
FROM [Production].[Product] PP
JOIN [Production].[ProductCategory] PC ON PP.ProductID = PC.ProductCategoryID
GROUP BY ProductCategoryID, PC.Name;

--Question3: Retrieve the order date, ship date, and total due for all orders in the "SalesOrderHeader" table that were placed in the year 2011.
SELECT OrderDate, ShipDate, TotalDue
FROM [Sales].[SalesOrderHeader]
WHERE YEAR(OrderDate)=2011
ORDER BY TotalDue DESC;

--Question4: List all distinct product colors in the "Product" table.
SELECT DISTINCT Color
FROM [Production].[Product]
WHERE Color IS NOT NULL;

--Question5:Find the total quantity sold for each product in the "SalesOrderDetail" table. Display the product ID and the sum of the order quantities.
SELECT ProductID, SUM(OrderQty) AS TotalQtySold
FROM [Sales].[SalesOrderDetail]
GROUP BY ProductID
ORDER BY TotalQtySold DESC;

--Question6: Calculate the total sales amount for each year from the "SalesOrderHeader" table. Display the year and the sum of the TotalDue amounts for each year.
SELECT YEAR(OrderDate) AS Year, ROUND(SUM(TotalDue),2) AS TotalSales
FROM [Sales].[SalesOrderHeader]
GROUP BY YEAR(OrderDate)
ORDER BY TotalSales DESC;
