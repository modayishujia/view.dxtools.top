#!/usr/bin/env python3
"""Fetch DXTools AI Compute Capital Flow data."""

import argparse
import json
import sys
import urllib.request
from pathlib import Path

PRIMARY_URL = "https://view.dxtools.top/data"
GITHUB_RAW = "https://raw.githubusercontent.com/modayishujia/view.dxtools.top/main/data"
ENDPOINTS = ["indicators", "history", "sources"]
HEADERS = {"User-Agent": "DXTools-AI-Compute/1.0"}


def fetch(name: str, base: str = PRIMARY_URL) -> dict:
    url = f"{base}/{name}.json"
    req = urllib.request.Request(url, headers=HEADERS)
    with urllib.request.urlopen(req, timeout=15) as resp:
        return json.loads(resp.read())


def main():
    parser = argparse.ArgumentParser(description="Fetch DXTools dashboard data")
    parser.add_argument(
        "--type",
        choices=ENDPOINTS + ["all"],
        default="indicators",
        help="Which dataset to fetch (default: indicators)",
    )
    parser.add_argument("--output", type=str, help="Output directory (default: stdout)")
    parser.add_argument(
        "--github",
        action="store_true",
        help="Use GitHub raw URL instead of primary",
    )
    args = parser.parse_args()

    types = ENDPOINTS if args.type == "all" else [args.type]
    base = GITHUB_RAW if args.github else PRIMARY_URL

    for name in types:
        try:
            data = fetch(name, base)
        except Exception as e:
            if not args.github:
                print(f"Primary failed ({e}), trying GitHub...", file=sys.stderr)
                data = fetch(name, GITHUB_RAW)
            else:
                raise
        if args.output:
            outdir = Path(args.output)
            outdir.mkdir(parents=True, exist_ok=True)
            outfile = outdir / f"{name}.json"
            outfile.write_text(json.dumps(data, ensure_ascii=False, indent=2))
            print(f"✓ {name} → {outfile}", file=sys.stderr)
        else:
            print(json.dumps(data, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
