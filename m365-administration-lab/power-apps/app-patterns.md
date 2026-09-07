# Power Apps — Canvas App Patterns

## Forms
- SubmitForm / ResetForm / EditForm; validate with `Form.Valid`

## Galleries
- Delegable filters: `Filter(Source, StartsWith(Title, txtSearch.Text))`

## Roles
- Drive visibility from a `Roles` list + `LookUp`

## Performance
- `Concurrent()` at OnStart; delegate everything
