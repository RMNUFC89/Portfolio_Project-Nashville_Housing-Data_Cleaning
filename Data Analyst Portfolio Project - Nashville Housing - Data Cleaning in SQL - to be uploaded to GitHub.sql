/*

Cleaning Data in SQL Queries

*/


SELECT *
FROM [Portfolio_Project_Nashville Housing Data].dbo.Nashville_Housing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


SELECT SaleDateConverted , CONVERT(date, SaleDate)
FROM [Portfolio_Project_Nashville Housing Data].dbo.Nashville_Housing

UPDATE Nashville_Housing
SET SaleDate = CONVERT(date, SaleDate)

ALTER TABLE Nashville_Housing
ADD SaleDateConverted  DATE;

UPDATE Nashville_Housing
SET SaleDateConverted = CONVERT(date, SaleDate)


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

SELECT *
FROM [Portfolio_Project_Nashville Housing Data].dbo.Nashville_Housing
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT PropertyAddress
FROM [Portfolio_Project_Nashville Housing Data].dbo.Nashville_Housing
--WHERE PropertyAddress IS NULL


SELECT A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM [Portfolio_Project_Nashville Housing Data].dbo.Nashville_Housing A
JOIN [Portfolio_Project_Nashville Housing Data].dbo.Nashville_Housing B
ON A.ParcelID = B.ParcelID
AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL

UPDATE A
SET PropertyAddress = ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM [Portfolio_Project_Nashville Housing Data].dbo.Nashville_Housing A
JOIN [Portfolio_Project_Nashville Housing Data].dbo.Nashville_Housing B
ON A.ParcelID = B.ParcelID
AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM [Portfolio_Project_Nashville Housing Data].dbo.Nashville_Housing
--WHERE PropertyAddress IS NULL
--ORDER BY ParcelID

SELECT
SUBSTRING(propertyaddress, 1, CHARINDEX(',', PropertyAddress) -1 ) AS Address
, SUBSTRING(propertyaddress, CHARINDEX(',', PropertyAddress) + 1 , LEN (PropertyAddress)) AS Address
FROM [Portfolio_Project_Nashville Housing Data].dbo.Nashville_Housing

ALTER TABLE Nashville_Housing
ADD PropertySplitAddress  NVARCHAR (255);

UPDATE Nashville_Housing
SET PropertySplitAddress = SUBSTRING(propertyaddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE Nashville_Housing
ADD PropertySplitCity  NVARCHAR (255);

UPDATE Nashville_Housing
SET PropertySplitCity = SUBSTRING(propertyaddress, CHARINDEX(',', PropertyAddress) + 1 , LEN (PropertyAddress))


SELECT *
FROM [Portfolio_Project_Nashville Housing Data].dbo.Nashville_Housing






SELECT OwnerAddress
FROM [Portfolio_Project_Nashville Housing Data].dbo.Nashville_Housing


SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
, PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
, PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
FROM [Portfolio_Project_Nashville Housing Data].dbo.Nashville_Housing



ALTER TABLE Nashville_Housing
ADD OwnerSplitAddress  NVARCHAR (255);

UPDATE Nashville_Housing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE Nashville_Housing
ADD OwnerSplitCity  NVARCHAR (255);

UPDATE Nashville_Housing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE Nashville_Housing
ADD OwnerSplitState  NVARCHAR (255);

UPDATE Nashville_Housing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


SELECT *
FROM [Portfolio_Project_Nashville Housing Data].dbo.Nashville_Housing

--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM [Portfolio_Project_Nashville Housing Data].dbo.Nashville_Housing
GROUP BY SoldAsVacant
ORDER BY 2



SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END
FROM [Portfolio_Project_Nashville Housing Data].dbo.Nashville_Housing

UPDATE Nashville_Housing
SET SoldAsVacant = 
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM [Portfolio_Project_Nashville Housing Data].dbo.Nashville_Housing
GROUP BY SoldAsVacant
ORDER BY 2

-----------------------------------------------------------------------------------------------------------------------------------------------------------

--- Remove Duplicates ---

--- Finding the Duplicates
WITH Row_Num_CTE AS (
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY PARCELID,
PropertyAddress,
SalePrice,
SaleDate,
LegalReference
ORDER BY
UniqueID
) Row_Num
FROM [Portfolio_Project_Nashville Housing Data].dbo.Nashville_Housing
--ORDER BY ParcelID
)
SELECT *
FROM Row_Num_CTE
WHERE Row_Num > 1
ORDER BY PropertyAddress

--- Deleting the Duplicates found (change SELECT * to DELETE)
WITH Row_Num_CTE AS (
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY PARCELID,
PropertyAddress,
SalePrice,
SaleDate,
LegalReference
ORDER BY
UniqueID
) Row_Num
FROM [Portfolio_Project_Nashville Housing Data].dbo.Nashville_Housing
--ORDER BY ParcelID
)
DELETE
FROM Row_Num_CTE
WHERE Row_Num > 1
--ORDER BY PropertyAddress

SELECT *
FROM [Portfolio_Project_Nashville Housing Data].dbo.Nashville_Housing



---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns (Deleting the columns PropertyAddress, OwnerAddress, SaleDate and TaxDistrict )



SELECT *
FROM [Portfolio_Project_Nashville Housing Data].dbo.Nashville_Housing

ALTER TABLE [Portfolio_Project_Nashville Housing Data].dbo.Nashville_Housing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE [Portfolio_Project_Nashville Housing Data].dbo.Nashville_Housing
DROP COLUMN SaleDate


