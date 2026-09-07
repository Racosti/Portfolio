# Multi-Stage Approval Flow (with audit trail)

Reusable Power Automate pattern for approvals with a full SharePoint audit trail.

## Trigger
- When an item is created in a SharePoint list (`Requests`)

## Steps
1. Initialize variable `AuditLog` (String)
2. Start and wait for an approval (Approve/Reject – First to respond)
3. Condition on Outcome → set Status Approved/Rejected
4. Compose audit entry: `@{utcNow()} | outcome | approver`
5. Update item → append to `AuditTrail` column
6. Email the requester

## Notes
- Use a service account connection.
- Store secrets in Azure Key Vault, never in the flow.
