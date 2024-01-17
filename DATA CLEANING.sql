SELECT*
FROM NashvilleHousing
--STANDARDIZING DATA FORMAT
SELECT SaleDate,CONVERT(Date,SaleDate)
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date

UPDATE NashvilleHousing
SET SaleDateConverted=CONVERT(Date,SaleDate)

SELECT SaleDateConverted,CONVERT(Date,SaleDate)
FROM NashvilleHousing

--POPULATING PROPERTY ADDRESS DATA
SELECT PropertyAddress
FROM NashvilleHousing
WHERE PropertyAddress is null

SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
ON a.ParcelID=b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress is null

UPDATE a
SET PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
ON a.ParcelID=b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress is null

SELECT PropertyAddress
FROM NashvilleHousing
WHERE PropertyAddress is null

--BREAKING ADDRESS INTO INDIVIDUAL COLUMNS (ADDRESS,CITY,STATE)
SELECT PropertyAddress
FROM NashvilleHousing
--ASK CLIFFORD EXTENSIVELY ABOUT CHARINDEX
SELECT
SUBSTRING (PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as ADDRESS,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as ADDRESS 
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress nvarchar(255)

UPDATE NashvilleHousing
SET PropertySplitAddress=SUBSTRING (PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255)

UPDATE NashvilleHousing
SET PropertySplitCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) 

SELECT*
FROM NashvilleHousing

--SPLITING OWNER ADDRESS
SELECT OwnerAddress
FROM NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitAddress=PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitCity=PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitState=PARSENAME(REPLACE(OwnerAddress,',','.'),1)

SELECT *
FROM NashvilleHousing

--CHANGING Y AND N TO YES AND NO IN 'SOLD AS VACANT' FIELD
SELECT DISTINCT SoldAsVacant, COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant
,CASE WHEN SoldAsVacant='Y' THEN 'Yes'
      WHEN SoldAsVacant='N' THEN 'No'
	  ELSE SoldAsVacant
 END
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant= CASE WHEN SoldAsVacant='Y' THEN 'Yes'
      WHEN SoldAsVacant='N' THEN 'No'
	  ELSE SoldAsVacant
 END


 --REMOVE DUPLICATES
 SELECT *,
 ROW_NUMBER( ) OVER(
PARTITION BY ParcelID,
             PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 ORDER BY UniqueID
			 )row_num
FROM NashvilleHousing
ORDER BY ParcelID

WITH RowNumCTE AS(
SELECT*,
ROW_NUMBER( ) OVER(
PARTITION BY ParcelID,
             PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 ORDER BY UniqueID
			 )row_num
FROM NashvilleHousing
)
SELECT*
FROM RowNumCTE
WHERE row_num>1
ORDER BY PropertyAddress

WITH RowNumCTE AS(
SELECT*,
ROW_NUMBER( ) OVER(
PARTITION BY ParcelID,
             PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 ORDER BY UniqueID
			 )row_num
FROM NashvilleHousing
)
DELETE 
FROM RowNumCTE
WHERE row_num>1

--DELETING UNUSED COLUMNS
SELECT*
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict,PropertyAddress

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate

