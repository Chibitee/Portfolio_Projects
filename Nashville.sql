--Data Cleaning in SQL
--Imported data using SQL Server 2022 Import and Export Data 

SELECT *
FROM PortfolioProject..Nashville

--Standardizing SaleDate column

SELECT SaleDate, CAST(SaleDate AS Date)
FROM PortfolioProject..Nashville

ALTER TABLE Nashville
ADD NewSaleDate Date;

UPDATE Nashville
SET NewSaleDate = CAST(SaleDate AS Date)

SELECT NewSaleDate
FROM PortfolioProject..Nashville

--Property Address Populating

SELECT *
FROM PortfolioProject..Nashville

--First Step
SELECT Nash.ParcelID, Nash.PropertyAddress, Ville.ParcelID, Ville.PropertyAddress
FROM PortfolioProject..Nashville AS Nash
JOIN PortfolioProject..Nashville AS Ville
ON Nash.[ParcelID] = Ville.[ParcelID]
AND Nash.[UniqueID] <> Ville.[UniqueID]
WHERE Nash.PropertyAddress IS NULL

--Second Step
SELECT Nash.ParcelID, Nash.PropertyAddress, Ville.ParcelID, Ville.PropertyAddress, 
ISNULL(Nash.PropertyAddress, Ville.PropertyAddress)
FROM PortfolioProject..Nashville AS Nash
JOIN PortfolioProject..Nashville AS Ville
ON Nash.[ParcelID] = Ville.[ParcelID]
AND Nash.[UniqueID] <> Ville.[UniqueID]
WHERE Nash.PropertyAddress IS NULL

--Third Step
UPDATE Nash
SET PropertyAddress = ISNULL(Nash.PropertyAddress, Ville.PropertyAddress)
FROM PortfolioProject..Nashville AS Nash
JOIN PortfolioProject..Nashville AS Ville
ON Nash.[ParcelID] = Ville.[ParcelID]
AND Nash.[UniqueID] <> Ville.[UniqueID]
WHERE Nash.PropertyAddress IS NULL

--Separating PropertyAddress into Addrerss, City
SELECT PropertyAddress
FROM PortfolioProject..Nashville

--Step 1:  CHARINDEX is use for knowing position, so ADD (-1) to remove the ',' 
SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address
FROM PortfolioProject..Nashville

--Step 2: Add Query for the City (+1 is to remove ',')
SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS NewPropertyAddress
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS City
FROM PortfolioProject..Nashville

--Update the table
ALTER TABLE Nashville
ADD NewPropertyAddress NVARCHAR(255);

UPDATE Nashville
SET NewPropertyAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE Nashville
ADD City NVARCHAR(255);

UPDATE Nashville
SET City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

SELECT *
FROM PortfolioProject..Nashville

--Separating OwnerAddress into Address, City, State
SELECT OwnerAddress
FROM PortfolioProject..Nashville

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) AS NewOwnerAddress,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) AS OwnerCity,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) AS OwnerState
FROM PortfolioProject..Nashville

--Update the table
ALTER TABLE Nashville
ADD NewOwnerAddress NVARCHAR(255);

UPDATE Nashville
SET NewOwnerAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE Nashville
ADD OwnerCity NVARCHAR(255);

UPDATE Nashville
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE Nashville
ADD OwnerState NVARCHAR(255);

UPDATE Nashville
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

SELECT *
FROM PortfolioProject..Nashville


--In SoldAsVacant, Change 'Y' and 'N' to 'Yes' and 'No'
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject..Nashville
GROUP BY SoldAsVacant

--Changing 'N' to 'No' and 'Y' to 'Yes'
SELECT SoldAsVacant,
CASE WHEN SoldAsVacant ='Y' THEN 'Yes' 
     WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM PortfolioProject..Nashville

--Update the table
UPDATE Nashville
SET SoldAsVacant = CASE WHEN SoldAsVacant ='Y' THEN 'Yes' 
     WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END

--Remove Duplicates
SELECT*
FROM PortfolioProject..Nashville

WITH RowNum AS(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY ParcelID,
             PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
ORDER BY 
UniqueID) Row_Num
FROM PortfolioProject..Nashville
)
DELETE
FROM RowNum
WHERE Row_Num >1

--To view
WITH RowNum AS(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY ParcelID,
             PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
ORDER BY 
UniqueID) Row_Num
FROM PortfolioProject..Nashville
)
SELECT*
FROM RowNum
WHERE Row_Num >1
ORDER BY PropertyAddress

--Dropping Columns
SELECT *
FROM PortfolioProject..Nashville

ALTER TABLE PortfolioProject..Nashville
DROP COLUMN PropertyAddress, OwnerAddress

ALTER TABLE PortfolioProject..Nashville
DROP COLUMN SaleDate




