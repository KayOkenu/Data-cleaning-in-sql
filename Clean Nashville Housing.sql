USE [PortfolioProject]
GO

/****** Object:  View [dbo].[CleanNashvilleHousing]    Script Date: 4/18/2024 9:05:25 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[CleanNashvilleHousing] AS
SELECT [UniqueID ],ParcelID,LandUse,SalePrice,LegalReference,SoldAsVacant,OwnerName,Acreage,LandValue,BuildingValue
,TotalValue,YearBuilt,Bedrooms,FullBath,HalfBath,SaleDateConverted,
PropertySplitAddress,PropertySplitCity,OwnerSplitAddress,OwnerSplitCity,OwnerSplitState
FROM NashvilleHousing
GO

