# IT Automation Toolkit

Reusable **PowerShell** and **Python** scripts for everyday IT operations:
reporting, auditing, monitoring and housekeeping. **No hard-coded credentials,
tenant names, servers or personal data** — everything is parameterised.

## 📂 Contents
### PowerShell (`/powershell`)
| Script | Purpose |
|---|---|
| `Get-ADUserReport.ps1` | Export enabled AD users to CSV |
| `Get-FileOwnerAudit.ps1` | Report who created/last-modified files in a folder |
| `Get-PrinterStatusReport.ps1` | Ping a device list and summarise status |
| `Get-DiskSpaceReport.ps1` | Flag low-disk-space drives across servers |

### Python (`/python`)
| Script | Purpose |
|---|---|
| `email_alert_parser.py` | Parse device alert emails (.eml) into JSON/CSV |
| `csv_cleaner.py` | Clean & normalise messy CSV exports |

## 🚀 Quick start
```powershell
.\powershell\Get-ADUserReport.ps1 -OutputPath .\users.csv
```
```bash
python python/email_alert_parser.py --input ./samples --output alerts.json
```

## 🔒 Safety
Placeholders only (`example.local`, `SERVER01`, `192.0.2.x`); `.gitignore` blocks
secrets and data files. See `.env.example`.

## 📄 License
MIT
