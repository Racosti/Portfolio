# Employee Onboarding — App Spec

## Data sources
- NewStarters (people + start date)
- OnboardingTasks (checklist template)

## Key formulas
```
CountRows(Filter(TasksForStarter, Done=true)) / CountRows(TasksForStarter)
Patch(OnboardingTasks, ThisItem, {Done: !ThisItem.Done})
```

## IT checklist template
- Create AD account
- Assign M365 license
- Prepare laptop & phone
- Grant SharePoint/Teams access
- Welcome email + first-day guide
