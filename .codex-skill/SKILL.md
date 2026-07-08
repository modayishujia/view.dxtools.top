---
name: dxtools-ai-compute
description: >
  Access and analyze AI compute capital flow data from the DXTools dashboard (view.dxtools.top).
  Use when the user asks about AI infrastructure investment, hyperscaler capex,
  data center REITs, memory chip pricing, SPV financing, moratorium trends,
  or any topic related to AI compute capital flows. Also use when the user
  mentions "dxtools", "view.dxtools.top", "AI算力", "数据中心", "资本流向",
  or asks to fetch/analyze the dashboard data.
  Works with any AI tool: Codex, MiMoCode, Claude Code, Cursor, Windsurf, etc.
---

# DXTools AI Compute Capital Flow

Real-time investor-grade data tracking capital flows into AI compute infrastructure.

## Data Endpoints

All data is served as static JSON — no API key required, no rate limits:

| Endpoint | Description |
|----------|-------------|
| `https://view.dxtools.top/data/indicators.json` | Main dataset: capex, SPV deals, risk signals, memory pricing, REITs |
| `https://view.dxtools.top/data/history.json` | Weekly snapshots with event timeline |
| `https://view.dxtools.top/data/sources.json` | Data source registry with update timestamps |

GitHub fallback: `https://raw.githubusercontent.com/modayishujia/view.dxtools.top/main/data/`

## How to Fetch

Any method works:

```bash
# curl
curl -s "https://view.dxtools.top/data/indicators.json"

# Python
import urllib.request, json
data = json.loads(urllib.request.urlopen("https://view.dxtools.top/data/indicators.json").read())

# Node.js
const data = await fetch("https://view.dxtools.top/data/indicators.json").then(r=>r.json())
```

Or use the bundled script:
```bash
python3 scripts/fetch_data.py [--type indicators|history|sources|all] [--output dir] [--github]
```

## Data Structure

```
meta                    — version, last_updated, investment_stance, rationale
capital_inflow
  hyperscaler_capex     — Amazon/Microsoft/Google/Meta capex with YoY
  morgan_stanley_forecast / goldman_sachs_forecast
  spv_financing         — SPV deals, key_deals, latest_deals
  new_capital_entry     — recent large investments
  ai_bond_market        — H1 issuance, forecasts, selloff events
  datacenter_reit       — DLR/EQIX/CRWV metrics
  apac_expansion        — regional deals
capital_outflow_risk
  project_cancellations — moratoriums, at-risk capacity
  utilization_rate      — DC utilization trend
  spv_risk / bubble_warnings / capex_cashflow_ratio
supply_demand
  vacancy_rate / power_capacity / memory_company_earnings
risk_triggers
  not_triggered / new_monitoring / escalating
```

See `references/data-schema.md` for the full schema.

## Analysis Patterns

1. **Capital flow direction**: Check `capital_inflow` vs `capital_outflow_risk` balance
2. **Risk escalation**: Monitor `risk_triggers.escalating` and `new_monitoring`
3. **Sentiment signal**: `meta.investment_stance` + `meta.rationale`
4. **Event impact**: `history.json` snapshots show how events shifted scores
5. **Memory cycle**: `supply_demand.memory_company_earnings` tracks HBM/DRAM supercycle

## Key Metrics

- 9-CSP Capex total → `hyperscaler_capex.nine_csp_total`
- Moratorium count → `project_cancellations.data.moratorium_total`
- DC utilization → `utilization_rate.value`
- AI bond market size → `ai_bond_market.h1_2026_issuance`
- SPV total exposure → `spv_financing.value`

## Dashboard

Live: https://view.dxtools.top/
