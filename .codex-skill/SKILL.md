---
name: dxtools-ai-compute
description: >
  Access and analyze AI compute capital flow data from the DXTools dashboard.
  Use when the user asks about AI infrastructure investment, hyperscaler capex,
  data center REITs, memory chip pricing, SPV financing, moratorium trends,
  or any topic related to AI compute capital flows. Also use when the user
  mentions "dxtools", "view.dxtools.top", "AI算力", "数据中心", "资本流向",
  or asks to fetch/analyze the dashboard data.
---

# DXTools AI Compute Capital Flow

Real-time investor-grade data tracking capital flows into AI compute infrastructure.

## Data Endpoints

All data is served as static JSON from the deployed dashboard:

| Endpoint | Description | Update Frequency |
|----------|-------------|-----------------|
| `https://view.dxtools.top/data/indicators.json` | Main dataset: capex, SPV deals, risk signals, memory pricing, REITs | Weekly |
| `https://view.dxtools.top/data/history.json` | Weekly snapshots with event timeline | Weekly |
| `https://view.dxtools.top/data/sources.json` | Data source registry with update timestamps | On change |

## Fetching Data

Run the bundled script:

```bash
python3 scripts/fetch_data.py [--type indicators|history|sources|all] [--output dir]
```

Or fetch directly with curl:

```bash
curl -s "https://view.dxtools.top/data/indicators.json" | python3 -m json.tool
```

## Data Structure (indicators.json)

```
meta                    — version, last_updated, investment_stance, rationale
capital_inflow
  hyperscaler_capex     — Amazon/Microsoft/Google/Meta capex with YoY
  morgan_stanley_forecast
  goldman_sachs_forecast
  spv_financing         — SPV deals, key_deals, latest_deals
  new_capital_entry     — recent large investments (deals array)
  ai_bond_market        — H1 issuance, forecasts, selloff events
  datacenter_reit       — DLR/EQIX/CRWV metrics, analyst actions
  apac_expansion        — regional deals by country
capital_outflow_risk
  project_cancellations — moratoriums, at-risk capacity, notable_cases
  utilization_rate      — DC utilization trend
  meta_compute_monetization
  spv_risk              — concerns, new_concerns
  bubble_warnings       — warnings array
  capex_cashflow_ratio  — capex vs operating cash flow
supply_demand
  vacancy_rate
  power_capacity
  memory_company_earnings — Samsung HBM/DRAM tracking
risk_triggers
  not_triggered
  new_monitoring
  escalating
```

## Analysis Patterns

When analyzing this data:

1. **Capital flow direction**: Check `capital_inflow` vs `capital_outflow_risk` balance
2. **Risk escalation**: Monitor `risk_triggers.escalating` and `new_monitoring` arrays
3. **Sentiment signal**: `meta.investment_stance` + `meta.rationale` give current stance
4. **Event impact**: `history.json` snapshots show how events shifted scores over time
5. **Memory cycle**: `supply_demand.memory_company_earnings` tracks HBM/DRAM supercycle

## Key Metrics to Quote

- 9-CSP Capex total (from `hyperscaler_capex.nine_csp_total`)
- Moratorium count (from `project_cancellations.data.moratorium_total`)
- DC utilization (from `utilization_rate.value`)
- AI bond market size (from `ai_bond_market.h1_2026_issuance`)
- SPV total exposure (from `spv_financing.value`)

## Dashboard

Live dashboard: https://view.dxtools.top/
