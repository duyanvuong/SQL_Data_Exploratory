use AdventureWork_internet_sales

---------------------------------------------------------------------
-- DimDate

DELETE FROM DimDate
where YEAR([Date]) < 2020

---------------------------------------------------------------------
-- DimGeography

UPDATE DimGeography
set [State] = 'Seine'
where City = 'Paris'

---------------------------------------------------------------------
-- DimCustomer

alter table DimCustomer
add FullName nvarchar(50)

update DimCustomer
set FullName = IIF(MiddleName is Null, FirstName + ' ' + LastName, FirstName + ' ' + MiddleName + ' ' + LastName)

update DimCustomer
set Gender = IIF(Gender = 'M', 'Male','Female')

UPDATE DimCustomer -- Update customer's birthdate
SET BirthDate = DATEADD(
    DAY, 
    ABS(CHECKSUM(NEWID())) % DATEDIFF(DAY, '1960-01-01', '2006-12-31') + 1,
    '1960-01-01'
);

---------------------------------------------------------------------
-- DimProduct

select ProductKey -- Identify if null values is in fact table
from FactInternetSales
where ProductKey in (
    select ProductKey
    from DimProduct
    where ModelName is NULL and ProductSubcategoryKey is NULL
)

delete from DimProduct
where ModelName is NULL and ProductSubcategoryKey is NULL
