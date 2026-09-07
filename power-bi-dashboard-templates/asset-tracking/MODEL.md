# Asset Tracking — Data Model & DAX

## Tables
- FactAssets: AssetId, Category, Status, AssignedTo, IssuedDate, ReturnedDate
- DimDate, DimUser, DimCategory

## Measures
```DAX
Total Assets = COUNTROWS ( FactAssets )
Issued = CALCULATE ( [Total Assets], FactAssets[Status] = "Issued" )
Available = CALCULATE ( [Total Assets], FactAssets[Status] = "Available" )
Overdue Returns =
CALCULATE ( [Total Assets],
    FILTER ( FactAssets,
        FactAssets[Status] = "Issued" && FactAssets[IssuedDate] < TODAY () - 180 ) )
```
