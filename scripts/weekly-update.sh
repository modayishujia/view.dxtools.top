#!/bin/bash
# ============================================================================
# AI Compute Capital Flow Dashboard - Weekly Update Script
# ============================================================================
# Usage: bash scripts/weekly-update.sh [--dry-run]
# 
# This script:
#   1. Fetches latest data from multiple sources
#   2. Updates data/indicators.json with new values
#   3. Updates data/history.json with weekly snapshot
#   4. Deploys to Cloudflare Pages
#   5. Optionally pushes to GitHub
# ============================================================================

set -e

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DATA_DIR="$PROJECT_DIR/data"
TODAY=$(date +%Y-%m-%d)
WEEK=$(date +%V)
DRY_RUN=false

[[ "$1" == "--dry-run" ]] && DRY_RUN=true

echo "=========================================="
echo "  AI Compute Capital Flow - Weekly Update"
echo "  Date: $TODAY (Week $WEEK)"
echo "  Mode: $([ "$DRY_RUN" = true ] && echo 'DRY RUN' || echo 'LIVE')"
echo "=========================================="
echo ""

# ============================================================================
# STEP 1: Data Collection Sources & Strategy
# ============================================================================

echo "📋 STEP 1: Data Collection Strategy"
echo ""
echo "Primary Sources (automated where possible):"
echo "  1. Korea Customs Export Data"
echo "     URL: https://customs.go.kr"
echo "     Method: Manual extraction from monthly reports"
echo "     Metrics: DRAM/NAND/HBM unit price YoY, MoM"
echo ""
echo "  2. TrendForce Contract Prices"
echo "     URL: https://trendforce.com"
echo "     Method: Subscribe to weekly newsletter"
echo "     Metrics: DRAM/NAND/HBM QoQ contract price changes"
echo ""
echo "  3. Goldman Sachs Memory Pricing Tracker"
echo "     URL: Research reports (subscription required)"
echo "     Metrics: Supply-demand gap forecasts, DRAM/NAND/HBM"
echo ""
echo "  4. Jefferies Memory Report"
echo "     URL: Research reports"
echo "     Metrics: Price forecasts Q3/Q4"
echo ""
echo "  5. Bloomberg / Reuters"
echo "     Metrics: Hyperscaler capex announcements, DC project status"
echo ""
echo "  6. Data Center Watch"
echo "     URL: datacenterwatch.org"
echo "     Metrics: Moratorium tracking, project cancellations"
echo ""
echo "  7. SemiAnalysis"
echo "     Metrics: Capacity analysis, contrarian views"
echo ""
echo "  8. SEC Filings (10-Q, 10-K)"
echo "     Companies: MSFT, GOOGL, AMZN, META, ORCL"
echo "     Metrics: Actual capex, FCF, guidance"
echo ""

# ============================================================================
# STEP 2: Check for data updates
# ============================================================================

echo "📊 STEP 2: Checking for data updates..."
echo ""

# Check last update time
if [ -f "$DATA_DIR/indicators.json" ]; then
    LAST_UPDATE=$(python3 -c "import json; print(json.load(open('$DATA_DIR/indicators.json'))['meta']['last_updated'])" 2>/dev/null || echo "unknown")
    echo "  Last update: $LAST_UPDATE"
    echo "  Current: $TODAY"
    echo ""
fi

# ============================================================================
# STEP 3: Manual data entry prompts
# ============================================================================

echo "📝 STEP 3: Manual Data Entry Required"
echo ""
echo "The following data must be manually updated from research sources:"
echo ""
echo "  [ ] Korea Customs: DRAM/NAND/HBM export price YoY, MoM"
echo "  [ ] TrendForce: Q2 contract prices (DRAM, NAND, LPDDR5X, SSD, UFS)"
echo "  [ ] TrendForce: Q3 forecast"
echo "  [ ] Goldman Sachs: Supply-demand gap % (DRAM, NAND, HBM)"
echo "  [ ] Jefferies: Q3/Q4 price forecasts"
echo "  [ ] Hyperscaler capex changes (if any)"
echo "  [ ] DC project cancellations/new approvals"
echo "  [ ] Moratorium count updates"
echo "  [ ] Apple/memory company earnings (if applicable)"
echo "  [ ] SK Hynix ADR status"
echo ""

# ============================================================================
# STEP 4: Update data files (template)
# ============================================================================

if [ "$DRY_RUN" = false ]; then
    echo "💾 STEP 4: Updating data files..."
    echo ""
    
    # Backup current data
    BACKUP_DIR="$DATA_DIR/backups/$TODAY"
    mkdir -p "$BACKUP_DIR"
    cp "$DATA_DIR/indicators.json" "$BACKUP_DIR/" 2>/dev/null || true
    cp "$DATA_DIR/history.json" "$BACKUP_DIR/" 2>/dev/null || true
    echo "  Backup created: $BACKUP_DIR"
    echo ""
    
    # Prompt for manual updates
    echo "  Please update the following fields in data/indicators.json:"
    echo "    - capital_inflow.hyperscaler_capex (if changed)"
    echo "    - capital_outflow_risk.project_cancellations.data (moratorium count)"
    echo "    - capital_outflow_risk.bubble_warnings.warnings (new warnings)"
    echo "    - capital_outflow_risk.utilization_rate.value (if changed)"
    echo ""
    echo "  Run: nano $DATA_DIR/indicators.json"
    echo "  Press Enter when done..."
    read -r
fi

# ============================================================================
# STEP 5: Update history snapshot
# ============================================================================

if [ "$DRY_RUN" = false ]; then
    echo "📸 STEP 5: Creating history snapshot..."
    echo ""
    
    python3 << 'PYEOF'
import json
from datetime import datetime

data_file = "data/indicators.json"
history_file = "data/history.json"

try:
    with open(data_file, 'r') as f:
        indicators = json.load(f)
    
    with open(history_file, 'r') as f:
        history = json.load(f)
    
    # Create new snapshot
    snapshot = {
        "date": datetime.now().strftime("%Y-%m-%d"),
        "week": f"W{datetime.now().strftime('%V')}",
        "summary": "Weekly update - see indicators.json for details",
        "capital_inflow_score": 9,  # Update manually
        "risk_score": 6,  # Update manually
        "net_signal": "positive_with_warnings",
        "key_events": [],  # Add this week's key events
        "notes": ""  # Add observations
    }
    
    history["snapshots"].append(snapshot)
    
    with open(history_file, 'w') as f:
        json.dump(history, f, indent=2, ensure_ascii=False)
    
    print(f"  Snapshot added for {snapshot['date']}")
except Exception as e:
    print(f"  Error updating history: {e}")
PYEOF
    echo ""
fi

# ============================================================================
# STEP 6: Deploy to Cloudflare Pages
# ============================================================================

if [ "$DRY_RUN" = false ]; then
    echo "🚀 STEP 6: Deploying to Cloudflare Pages..."
    echo ""
    
    cd "$PROJECT_DIR"
    wrangler pages deploy . --project-name=view-dxtools-top --branch=main
    
    echo ""
    echo "  Deployment URL: https://view.dxtools.top"
    echo ""
fi

# ============================================================================
# STEP 7: Push to GitHub (optional)
# ============================================================================

if [ "$DRY_RUN" = false ]; then
    echo "📤 STEP 7: Push to GitHub? (y/n)"
    read -r PUSH_GH
    if [[ "$PUSH_GH" == "y" || "$PUSH_GH" == "Y" ]]; then
        cd "$PROJECT_DIR"
        git add -A
        git commit -m "Weekly update $TODAY W$WEEK"
        git push origin main
        echo "  Pushed to GitHub"
    else
        echo "  Skipped GitHub push"
    fi
fi

echo ""
echo "=========================================="
echo "  ✅ Weekly update complete!"
echo "  Date: $TODAY (Week $WEEK)"
echo "  URL: https://view.dxtools.top"
echo "=========================================="
