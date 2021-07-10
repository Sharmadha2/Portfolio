USE Portfolio
SELECT * FROM dbo.nashvillehousing

--standardize date format
SELECT SaleDate from dbo.nashvillehousing

SELECT SaleDateconverted,CONVERT(Date,SaleDate)from dbo.nashvillehousing

UPDATE dbo.nashvillehousing SET  SaleDate=CONVERT(Date,SaleDate)

ALTER TABLE dbo.nashvillehousing ADD SaleDateconverted DATE

UPDATE dbo.nashvillehousing SET  SaleDateconverted=CONVERT(Date,SaleDate)

--Populate property address data
SELECT * from dbo.nashvillehousing 
--where PropertyAddress IS NULL
ORDER By ParcelID

SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from dbo.nashvillehousing a 
JOIN dbo.nashvillehousing b
ON a.ParcelID=b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
from dbo.nashvillehousing a 
JOIN dbo.nashvillehousing b
ON a.ParcelID=b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

--Breaking out Address into Individual Columns(Address,City,State)
SELECT PropertyAddress from dbo.nashvillehousing 

SELECT SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))as Address
from dbo.nashvillehousing 

ALTER TABLE dbo.nashvillehousing ADD propertysplit Nvarchar(255)

UPDATE dbo.nashvillehousing SET  propertysplit=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE dbo.nashvillehousing ADD propertysplitcity Nvarchar(255)

UPDATE dbo.nashvillehousing SET  propertysplitcity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

SELECT * FROM dbo.nashvillehousing

SELECT OwnerAddress FROM dbo.nashvillehousing

SELECT PARSENAME(replace(OwnerAddress,',','.'),3),
PARSENAME(replace(OwnerAddress,',','.'),2),
PARSENAME(replace(OwnerAddress,',','.'),1)
FROM dbo.nashvillehousing



ALTER TABLE dbo.nashvillehousing ADD ownersplitaddress Nvarchar(255)

UPDATE dbo.nashvillehousing SET  ownersplitaddress=PARSENAME(replace(OwnerAddress,',','.'),3)

ALTER TABLE dbo.nashvillehousing ADD ownersplitcity Nvarchar(255)

UPDATE dbo.nashvillehousing SET  ownersplitcity=PARSENAME(replace(OwnerAddress,',','.'),2)

ALTER TABLE dbo.nashvillehousing ADD ownersplitstate Nvarchar(255)

UPDATE dbo.nashvillehousing SET ownersplitstate=PARSENAME(replace(OwnerAddress,',','.'),1)

--Change Y and N to Yes and No in "Sold as vacant" field
SELECT distinct(SoldAsVacant),Count(SoldAsVacant)
FROM dbo.nashvillehousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant='Y' THEN 'Yes'
WHEN SoldAsVacant='N' THEN 'No'
ELSE
SoldAsVacant
END
FROM dbo.nashvillehousing

UPDATE dbo.nashvillehousing SET SoldAsVacant=
CASE WHEN SoldAsVacant='Y' THEN 'Yes'
WHEN SoldAsVacant='N' THEN 'No'
ELSE
SoldAsVacant
END

--Removing Duplicates
WITH RownumCTE AS(
SELECT *,
    ROW_NUMBER()OVER(
	PARTITION BY ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	ORDER By
	UniqueID)rownum
FROM dbo.nashvillehousing)
SELECT * FROM RownumCTE
Where rownum>1

--Delete unused column

ALTER TABLE dbo.nashvillehousing
DROP COLUMN OwnerAddress,TaxDistrict,PropertyAddress

ALTER TABLE dbo.nashvillehousing
DROP COLUMN SaleDate

