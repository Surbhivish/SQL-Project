use [my project]
SELECT * from dbo.Sheet1$
-- Standardize Date Format


Select saledate, CONVERT(Date,SaleDate)
From dbo.Sheet1$

Update dbo.Sheet1$
SET SaleDate = CONVERT(Date,SaleDate) 

Select * from dbo.Sheet1$
-- If it doesn't Update properly

ALTER TABLE dbo.sheet1$
Add SaleDateConverted Date

Update dbo.Sheet1$
SET SaleDateConverted = CONVERT(Date,SaleDate)

Select * from dbo.Sheet1$

-- Populate Property Address data

Select *
From dbo.Sheet1$
--Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From dbo.Sheet1$ a
JOIN dbo.Sheet1$ b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From dbo.Sheet1$ a
JOIN dbo.Sheet1$ b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From dbo.Sheet1$
--Where PropertyAddress is null
--order by ParcelID

SELECT propertyaddress,
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address1
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address2
From dbo.Sheet1$


ALTER TABLE dbo.sheet1$
Add PropertySplitAddress Nvarchar(255)

Update dbo.sheet1$
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE -- Breaking out Address into Individual Columns (Address, City, State)








ALTER TABLE dbo.sheet1$
Add PropertySplitCity Nvarchar(255);

Update dbo.sheet1$
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


select * from dbo.Sheet1$

Select 
PARSENAME(replace(OwnerAddress,',','.'),3),
PARSENAME(replace(OwnerAddress,',','.'),2),
PARSENAME(replace(OwnerAddress,',','.'),1)
from dbo.Sheet1$

Alter table dbo.sheet1$
Add ownersplitstate varchar(255)

update dbo.Sheet1$
set ownersplitstate = PARSENAME(replace(OwnerAddress,',','.'),1)

Alter table dbo.sheet1$
Add ownersplitcity varchar(255)

update dbo.Sheet1$
set ownersplitcity = PARSENAME(replace(OwnerAddress,',','.'),2)

Alter table dbo.sheet1$
Add ownersplitstate varchar(255)

update dbo.Sheet1$
set ownersplitadd = PARSENAME(replace(OwnerAddress,',','.'),3)

Select * from Sheet1$

-----Updating y and n to yes and no in SoldAsVacant column
Select distinct SoldAsVacant,COUNT(SoldAsVacant)
From dbo.Sheet1$
group by SoldAsVacant
order by 2

Select SoldAsVacant
, Case when SoldAsVacant = 'Y' then 'Yes'
        when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		end
from dbo.Sheet1$

Update dbo.Sheet1$
Set SoldAsVacant = Case when SoldAsVacant = 'Y' then 'Yes'
        when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		end

		--------------Removing Duplicates
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From dbo.Sheet1$
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

Select * from dbo.Sheet1$



WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From dbo.Sheet1$)
Delete 
From RowNumCTE
Where row_num > 1
---------------------------------------------------------------------------------
---Delete unwanted columns

Select * 
from dbo.Sheet1$

Alter table dbo.sheet1$
Drop column ownerstate,SaleDate,owneraddress,TaxDistrict,PropertyAddress