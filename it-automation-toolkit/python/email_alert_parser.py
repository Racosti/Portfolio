#!/usr/bin/env python3
"""
email_alert_parser.py
---------------------
Parse device / printer alert emails (.eml files) into structured JSON or CSV.

Point it at a folder of exported .eml files and it extracts device name,
alert type, serial and timestamp. No mailbox connection, no credentials.

Usage:
    python email_alert_parser.py --input ./samples --output alerts.json
    python email_alert_parser.py --input ./samples --output alerts.csv --format csv

Author: Mateusz Dubak
License: MIT
"""
from __future__ import annotations

import argparse
import csv
import email
import json
import re
from email import policy
from pathlib import Path

PATTERNS = {
    "device_name": re.compile(r"Device Name[:\s]+(.+)", re.IGNORECASE),
    "serial":      re.compile(r"Serial(?:\s*Number)?[:\s]+([A-Z0-9\-]+)", re.IGNORECASE),
    "alert_type":  re.compile(r"(Toner Low|Paper Jam|Out of Paper|Service Required|Error)", re.IGNORECASE),
    "ip_address":  re.compile(r"(\d{1,3}(?:\.\d{1,3}){3})"),
}


def parse_eml(path: Path) -> dict:
    msg = email.message_from_bytes(path.read_bytes(), policy=policy.default)
    body = ""
    if msg.is_multipart():
        for part in msg.walk():
            if part.get_content_type() == "text/plain":
                body += part.get_content()
    else:
        body = msg.get_content()

    record = {
        "file": path.name,
        "subject": msg.get("subject", "").strip(),
        "from": msg.get("from", "").strip(),
        "date": msg.get("date", "").strip(),
    }
    for field, pattern in PATTERNS.items():
        match = pattern.search(body)
        record[field] = match.group(1).strip() if match else None
    return record


def collect(input_dir: Path) -> list[dict]:
    files = sorted(input_dir.glob("*.eml"))
    if not files:
        print(f"[warn] no .eml files found in {input_dir}")
    return [parse_eml(f) for f in files]


def write_output(records: list[dict], output: Path, fmt: str) -> None:
    if fmt == "json":
        output.write_text(json.dumps(records, indent=2, ensure_ascii=False))
    else:
        if not records:
            output.write_text("")
            return
        with output.open("w", newline="", encoding="utf-8") as fh:
            writer = csv.DictWriter(fh, fieldnames=list(records[0].keys()))
            writer.writeheader()
            writer.writerows(records)
    print(f"[ok] wrote {len(records)} record(s) to {output}")


def main() -> None:
    ap = argparse.ArgumentParser(description="Parse device alert emails into JSON/CSV")
    ap.add_argument("--input", required=True, type=Path)
    ap.add_argument("--output", required=True, type=Path)
    ap.add_argument("--format", choices=["json", "csv"], default="json")
    args = ap.parse_args()
    write_output(collect(args.input), args.output, args.format)


if __name__ == "__main__":
    main()
