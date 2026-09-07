# Equipment Checkout — App Spec

## Data source: SharePoint list `Assets`
| Column | Type |
|---|---|
| AssetTag | Text |
| Category | Choice (Laptop/Phone/Monitor) |
| Status | Choice (Available/Issued/Repair) |
| AssignedTo | Person |
| IssuedDate | DateTime |
| DueDate | DateTime |

## Key formulas
```
Patch(Assets, galAssets.Selected,
      {Status:"Issued", AssignedTo:cmbPerson.Selected,
       IssuedDate:Now(), DueDate:DateAdd(Now(),30)})

Patch(Assets, galAssets.Selected,
      {Status:"Available", AssignedTo:Blank(), DueDate:Blank()})
```
