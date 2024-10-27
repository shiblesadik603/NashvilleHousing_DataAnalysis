select *
From PortfolioProject.dbo.NashvilleHousing

--Standardize Date Format

select SaleDateConverted,CONVERT(Date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing

use PortfolioProject

Update NashvilleHousing
SET SaleDate=CONVERT(Date,SaleDate)

Alter table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted=CONVERT(Date,SaleDate)


--Populate property address data

select *
From PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID

select a.parcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.parcelID=b.parcelID
	AND a.[UniqueID]<>b.[UniqueID]
Where a.PropertyAddress is null


Update a
SET PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.parcelID=b.parcelID
	AND a.[UniqueID]<>b.[UniqueID]
Where a.PropertyAddress is null


--Breaking out Address into Individual Columns(Address,City,State)

select * 
from PortfolioProject.dbo.NashvilleHousing
 
--breaking out address into individual columns(address,city,state)

select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing

select 
substring(PropertyAddress,1,charindex(',',PropertyAddress) -1) as Address
,substring(PropertyAddress,charindex(',',PropertyAddress)+1,len(PropertyAddress)) as Address

From PortfolioProject.dbo.NashvilleHousing

use PortfolioProject

Alter table dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
Set PropertySplitAddress=substring(PropertyAddress,1,charindex(',',PropertyAddress) -1)

Alter table dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
Set PropertySplitCity=substring(PropertyAddress,charindex(',',PropertyAddress)+1,len(PropertyAddress))

Select * 
From PortfolioProject.dbo.NashvilleHousing 

Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing 

Select 
Parsename(Replace(OwnerAddress,',','.'),3),
Parsename(Replace(OwnerAddress,',','.'),2),
Parsename(Replace(OwnerAddress,',','.'),1)
From PortfolioProject.dbo.NashvilleHousing 

Alter table dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitAddress=Parsename(Replace(OwnerAddress,',','.'),3)

Alter table dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitCity=Parsename(Replace(OwnerAddress,',','.'),2)

Alter table dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitState=Parsename(Replace(OwnerAddress,',','.'),1)

--change y and N to yes and no in "sold as vacant" field


Alter table nashvillehousing 
Add SoldAsVacant_new Nvarchar(255);

update NashvilleHousing
Set SoldAsVacant_new=Case
					when SoldAsVacant='0' Then 'N'
					When SoldAsVacant='1' Then 'Y'
				End;

Alter Table nashvillehousing
Drop Column SoldAsVacant;

EXEC sp_rename 'nashvillehousing.soldasvacant_new', 'soldasvacant', 'COLUMN';

Select Distinct(SoldAsVacant),Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2 

--Remove Duplicate

with ROWNumCTE As(
Select * ,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order by UniqueID
				 )row_num
From PortfolioProject.dbo.NashvilleHousing
--order by parcelID
)
select * 
From RowNumCTE
Where row_num>1
order by PropertyAddress

with ROWNumCTE As(
Select * ,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order by UniqueID
				 )row_num
From PortfolioProject.dbo.NashvilleHousing
--order by parcelID
)
delete 
From RowNumCTE
Where row_num>1
--order by PropertyAddress

with ROWNumCTE As(
Select * ,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order by UniqueID
				 )row_num
From PortfolioProject.dbo.NashvilleHousing
--order by parcelID
)
select * 
From RowNumCTE
Where row_num>1
order by PropertyAddress

Select * 
From PortfolioProject.dbo.NashvilleHousing

--Delete columnn

Select * 
From PortfolioProject.dbo.NashvilleHousing

Alter table PortfolioProject.dbo.NashvilleHousing
Drop Column OwnerAddress,TaxDistrict,PropertyAddress

