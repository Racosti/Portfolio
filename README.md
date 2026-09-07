# 📁 GitHub Portfolio — Mateusz Dubak

Six ready-to-publish repositories plus your profile README. Everything is
genericized: no client names, no employer data, no credentials, no personal paths.

## Publish everything in one command
Install **git** + **GitHub CLI** (`gh`), run `gh auth login` once, then:

```powershell
# Windows / PowerShell
.\publish.ps1 -GitHubUser YOUR_USERNAME
```
```bash
# macOS / Linux
./publish.sh YOUR_USERNAME
```

This creates and pushes all repos (and your `<username>/<username>` profile repo)
automatically. Add `-Private` (PS) or `PRIVATE=1` (bash) for private repos.

See `PUBLISH.md` for manual steps and GitHub Pages hosting of the demo.
