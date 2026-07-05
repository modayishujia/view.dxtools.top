#!/usr/bin/env python3
"""
AI Compute Capital Flow - Data Fetch Helper
Usage: python3 scripts/fetch-data.py [--check] [--update]

This script helps with:
1. Checking data freshness
2. Generating update prompts
3. Validating data structure
"""

import json
import os
import sys
from datetime import datetime, timedelta

PROJECT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DATA_DIR = os.path.join(PROJECT_DIR, 'data')

def load_json(filename):
    filepath = os.path.join(DATA_DIR, filename)
    if os.path.exists(filepath):
        with open(filepath, 'r') as f:
            return json.load(f)
    return None

def check_freshness():
    """Check when data was last updated"""
    indicators = load_json('indicators.json')
    if not indicators:
        print("❌ indicators.json not found")
        return
    
    last_update = indicators.get('meta', {}).get('last_updated', 'unknown')
    print(f"📅 Last update: {last_update}")
    
    # Check if update is needed
    try:
        last_date = datetime.strptime(last_update, '%Y-%m-%d')
        days_old = (datetime.now() - last_date).days
        if days_old > 7:
            print(f"⚠️  Data is {days_old} days old - UPDATE RECOMMENDED")
        else:
            print(f"✅ Data is {days_old} days old - FRESH")
    except:
        print("⚠️  Could not parse date")

def show_checklist():
    """Show manual data entry checklist"""
    print("\n📝 MANUAL DATA ENTRY CHECKLIST")
    print("=" * 50)
    print("\nTier 1 (Weekly):")
    print("  [ ] Korea Customs: DRAM/NAND/HBM export prices")
    print("  [ ] TrendForce: QoQ contract prices")
    print("  [ ] Hyperscaler capex changes")
    print("  [ ] DC project cancellations")
    print("  [ ] Moratorium count")
    print("\nTier 2 (Bi-weekly):")
    print("  [ ] Goldman Sachs supply-demand gap")
    print("  [ ] SemiAnalysis capacity report")
    print("  [ ] IDC shipment forecasts")
    print("\nTier 3 (Monthly):")
    print("  [ ] FT/Reuters SPV tracking")
    print("  [ ] SEC filings review")
    print("  [ ] Apple/memory earnings")

def validate_data():
    """Validate data structure"""
    indicators = load_json('indicators.json')
    if not indicators:
        print("❌ indicators.json not found")
        return
    
    required_keys = ['meta', 'capital_inflow', 'capital_outflow_risk', 'supply_demand']
    for key in required_keys:
        if key in indicators:
            print(f"✅ {key}: present")
        else:
            print(f"❌ {key}: MISSING")
    
    # Check meta
    meta = indicators.get('meta', {})
    print(f"\n📋 Meta info:")
    print(f"  Version: {meta.get('version', 'unknown')}")
    print(f"  Last updated: {meta.get('last_updated', 'unknown')}")
    print(f"  Investment stance: {meta.get('investment_stance', 'unknown')}")

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 scripts/fetch-data.py [--check|--update|--validate]")
        sys.exit(1)
    
    cmd = sys.argv[1]
    
    if cmd == '--check':
        check_freshness()
    elif cmd == '--update':
        show_checklist()
    elif cmd == '--validate':
        validate_data()
    else:
        print(f"Unknown command: {cmd}")
        print("Usage: python3 scripts/fetch-data.py [--check|--update|--validate]")

if __name__ == '__main__':
    main()
