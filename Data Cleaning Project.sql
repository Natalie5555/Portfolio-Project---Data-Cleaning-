/* Data Cleaning Project*/


--Changing DateTime format to Date for SaleDate column
Select Saledateupdated,SaleDate
From Nashville

Alter Table Nashville
Drop Column SaleDataUpdated

Update Nashville
Set SaleDate = CONVERT(Date,SaleDate)

Alter Table Nashville
Add SaleDateUpdated Date;

Update Nashville
Set SaleDateUpdated = convert(Date,SaleDate)

Select *
From Nashville

--Populate property address data
Select *
From Nashville
--where propertyaddress is null
order by parcelid

Select a.parcelid,a.propertyaddress,b.parcelid,b.propertyaddress,ISNULL(a.propertyaddress,b.propertyaddress)
from [Portfolio project]..nashville a
join [Portfolio project]..nashville b
on a.parcelid=b.parcelid
and a.uniqueid<>b.uniqueid
where a.propertyaddress is null


Update a
set propertyaddress=ISNULL(a.propertyaddress,b.propertyaddress)
from [Portfolio project]..nashville a
join [Portfolio project]..nashville b
on a.parcelid=b.parcelid
and a.uniqueid<>b.uniqueid
where a.propertyaddress is null

-- Seperate the whole address into two columns
select 
SUBSTRING(propertyaddress,1,CHARINDEX(',',propertyaddress)-1)
,SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress)+1,LEN(propertyaddress))
from [Portfolio project]..nashville

Alter Table nashville
Add propertysplitaddress nvarchar(255)

update nashville
set propertysplitaddress=SUBSTRING(propertyaddress,1,CHARINDEX(',',propertyaddress)-1)

Alter table nashville
add propertysplitcity nvarchar(255)

update nashville
set propertysplitcity=SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress)+1,LEN(propertyaddress))

Select *
from nashville



select owneraddress
from nashville

select
PARSENAME(replace(owneraddress,',','.'),3)
,PARSENAME(replace(owneraddress,',','.'),2)
,PARSENAME(replace(owneraddress,',','.'),1)

from nashville

alter table nashville
add ownersplitaddress nvarchar(255)

Update nashville
set ownersplitaddress=PARSENAME(replace(owneraddress,',','.'),3)


alter table nashville
add ownersplitcity nvarchar(255)

Update nashville
set ownersplitcity=PARSENAME(replace(owneraddress,',','.'),2)


alter table nashville
add ownersplitstate nvarchar(255)

Update nashville
set ownersplitstate=PARSENAME(replace(owneraddress,',','.'),1)

Select*
from nashville


-- Under sold as vacant column change Y to Yes and N to No
select distinct(soldasvacant),count(soldasvacant)
from nashville
group by soldasvacant
order by 2

select soldasvacant
,case when soldasvacant='Y' then 'Yes'
     when soldasvacant='N' then 'No'
	 else soldasvacant
	 end
from nashville

update nashville
set soldasvacant=case when soldasvacant='Y' then 'Yes'
     when soldasvacant='N' then 'No'
	 else soldasvacant
	 end


	 -- Deleting Duplicate Rows

	 with CTErownumber as(
	 Select *,
	 ROW_NUMBER() over (partition by
	 parcelid,
	 propertyaddress,
	 saledate,
	 saleprice,
	 ownername
	 order by uniqueid) as row_num
	 from nashville)
	 select *-- A Delete command has been used to remove duplicate rows
	 from CTErownumber
	 where row_num>1
	 order by saledate

	 --Deleting unwanted columns
	 select *
	 from nashville

	 alter table nashville
	 drop column owneraddress, TaxDistrict,PropertyAddress

	 alter table nashville
	 drop column saledate
-- Extracting the maximum of sale price from data
	 Select *
	 from nashville
	 order by saleprice DESC

	 select MAX(saleprice) as MaximumSalePrice
	 From nashville


	 -- Splitting parts of date for SaleDateUpdated and adding relevant columns
	 select saledateupdated,
	 datename(year,saledateupdated) as Yearofsale
	 ,datename(month,saledateupdated) as Monthofsale
	 ,datename(weekday,saledateupdated) as Dayofsale
	 from nashville

	 	
	alter table nashville
	add Yearofsale int, Monthofsale nvarchar (255),Dayofsale nvarchar(255)
	

	Update [Portfolio project]..nashville
	set Yearofsale=datename(year,saledateupdated)
	    ,Monthofsale=datename(month,saledateupdated)
		,Dayofsale=datename(weekday,saledateupdated)

	 Select *
	 from nashville