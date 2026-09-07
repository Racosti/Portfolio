# Printer Monitoring — Data Model & DAX

## Tables
- FactAlerts: AlertId, DeviceName, AlertType, Severity, DateKey
- DimDevice: DeviceName, IP, Location, Model
- DimDate: DateKey, Date, Month, Weekday

## Measures
```DAX
Alerts Today = CALCULATE ( COUNTROWS ( FactAlerts ), DimDate[Date] = TODAY () )
Toner Low Count = CALCULATE ( COUNTROWS ( FactAlerts ), FactAlerts[AlertType] = "Toner Low" )
Devices Online = DISTINCTCOUNT ( DimDevice[DeviceName] )
```
