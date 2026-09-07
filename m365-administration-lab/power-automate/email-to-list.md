# Email → SharePoint List (alert ingestion)

Turn structured alert emails into rows in a SharePoint list that can power a
Power BI dashboard.

## Trigger
- When a new email arrives (V3) — filter by sender/subject

## Steps
1. Html to text on the body
2. Compose parsing (split/substring) → Device, Serial, Alert, Timestamp
3. Create item in list `DeviceAlerts`
4. Optional: if Alert = Service Required → post to Teams
