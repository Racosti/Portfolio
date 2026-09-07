#!/usr/bin/env python3
"""
csv_cleaner.py
--------------
Clean and normalise messy CSV exports: strip whitespace, drop empty rows,
standardise headers to snake_case, and de-duplicate rows.

Usage:
    python csv_cleaner.py --input messy.csv --output clean.csv

Author: Mateusz Dubak
License: MIT
"""
from __future__ import annotations

import argparse
import csv
import re
from pathlib import Path


def to_snake(header: str) -> str:
    header = header.strip().lower()
    header = re.sub(r"[^\w]+", "_", header)
    return header.strip("_")


def clean(rows: list[dict]) -> list[dict]:
    if not rows:
        return rows
    mapping = {k: to_snake(k) for k in rows[0].keys()}
    cleaned, seen = [], set()
    for row in rows:
        new = {mapping[k]: (v.strip() if isinstance(v, str) else v) for k, v in row.items()}
        if not any(v for v in new.values()):
            continue
        key = tuple(new.items())
        if key in seen:
            continue
        seen.add(key)
        cleaned.append(new)
    return cleaned


def main() -> None:
    ap = argparse.ArgumentParser(description="Clean a messy CSV file")
    ap.add_argument("--input", required=True, type=Path)
    ap.add_argument("--output", required=True, type=Path)
    args = ap.parse_args()

    with args.input.open(newline="", encoding="utf-8-sig") as fh:
        rows = list(csv.DictReader(fh))
    cleaned = clean(rows)
    if cleaned:
        with args.output.open("w", newline="", encoding="utf-8") as fh:
            writer = csv.DictWriter(fh, fieldnames=list(cleaned[0].keys()))
            writer.writeheader()
            writer.writerows(cleaned)
    print(f"[ok] {len(rows)} rows in -> {len(cleaned)} rows out ({args.output})")


if __name__ == "__main__":
    main()
