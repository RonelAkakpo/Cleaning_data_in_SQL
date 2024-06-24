select *
from [dbo].[Sheet1$]

-- Modification du format de la date (Standardize date format)

select SaleDate, 
convert(Date,SaleDate)  --conversion sous format date (conversion to date format)
from [dbo].[NashvilleHousing]

alter table [dbo].[NashvilleHousing] -- ajout d'une nouvelle colonne au format date
add SaleDateConverted date;

update [dbo].[NashvilleHousing]
set SaleDateConverted=convert(Date,SaleDate)

select SaleDateConverted
from [dbo].[NashvilleHousing]

-- Populate property address data (Renseigner les données relatives à l'adresse de la propriété)

select PropertyAddress
from [dbo].[NashvilleHousing]
where PropertyAddress is null

-- remplacement des valeurs manquantes dans PropertyAddress

select *
from [dbo].[NashvilleHousing]
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull (a.PropertyAddress,b.PropertyAddress)
from [dbo].[NashvilleHousing] a
join [dbo].[NashvilleHousing] b
 on a.ParcelID=b.ParcelID
 AND a.UniqueID <> b.UniqueID
 where a.PropertyAddress is null

 update a
 set a.PropertyAddress=isnull (a.PropertyAddress,b.PropertyAddress)
 from [dbo].[NashvilleHousing] a
join [dbo].[NashvilleHousing] b
 on a.ParcelID=b.ParcelID
 AND a.UniqueID <> b.UniqueID
 where a.PropertyAddress is null

select PropertyAddress
from [dbo].[NashvilleHousing]
where PropertyAddress is null

--Breaking out address into individual columns (address, city, state) (Décomposition de l'adresse en colonnes individuelles (adresse, ville, état))

select PropertyAddress
from [dbo].[NashvilleHousing]

select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as address, 
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress)) as city
from [dbo].[NashvilleHousing]

alter table [dbo].[NashvilleHousing] 
add Propertysplitaddress nvarchar(255);

update [dbo].[NashvilleHousing]
set Propertysplitaddress=SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

alter table [dbo].[NashvilleHousing] 
add Propertysplitcity nvarchar(255);

update [dbo].[NashvilleHousing]
set Propertysplitcity=SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress))

select Propertysplitaddress, Propertysplitcity
from [dbo].[NashvilleHousing]

--Decomposition de l'adresse (2e methode en utilisant parsename)

select OwnerAddress
from [dbo].[NashvilleHousing]

select
parsename(replace(OwnerAddress, ',','.'), 3),
parsename(replace(OwnerAddress, ',','.'), 2),
parsename(replace(OwnerAddress, ',','.'), 1)
from [dbo].[NashvilleHousing]

alter table [dbo].[NashvilleHousing] 
add Ownersplitaddress nvarchar(255);

update [dbo].[NashvilleHousing]
set Ownersplitaddress=parsename(replace(OwnerAddress, ',','.'), 3)

alter table [dbo].[NashvilleHousing] 
add Ownersplitcity nvarchar(255);

update [dbo].[NashvilleHousing]
set Ownersplitcity=parsename(replace(OwnerAddress, ',','.'), 2)

alter table [dbo].[NashvilleHousing] 
add Ownersplitstate nvarchar(255);

update [dbo].[NashvilleHousing]
set Ownersplitstate=parsename(replace(OwnerAddress, ',','.'), 1)

select distinct(SoldAsVacant), count(SoldAsVacant)
from [dbo].[NashvilleHousing]
group by SoldAsVacant
order by 2

select SoldAsVacant,
case when SoldAsVacant='Y' then 'Yes'
     when SoldAsVacant='N' then 'No'
	 else SoldAsVacant
	 end
from [dbo].[NashvilleHousing]

update [dbo].[NashvilleHousing]
set SoldAsVacant=case when SoldAsVacant='Y' then 'Yes'
     when SoldAsVacant='N' then 'No'
	 else SoldAsVacant
	 end



