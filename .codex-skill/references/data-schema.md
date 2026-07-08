# Data Schema Reference

## indicators.json — Full Schema

### meta
- `last_updated` (date): ISO date of last update
- `version` (string): Data schema version
- `investment_stance` (string): Current investment recommendation
- `rationale` (string): Explanation of stance
- `update_log` (array): Version history with date/version/note

### capital_inflow
- `hyperscaler_capex` — Per-company capex with YoY, nine_csp_total
- `morgan_stanley_forecast` — MS US hyperscaler AI capex forecast
- `goldman_sachs_forecast` — GS 2025-2030 AI spending forecast
- `spv_financing` — Off-balance-sheet financing: value, key_deals, latest_deals, approval_rate
- `new_capital_entry` — Recent large deals: investor, amount, target, date
- `ai_bond_market` — Bond issuance data: h1_2026_issuance, full_year_forecast, latest_event
- `datacenter_reit` — REIT stocks: ticker, price, p_affo, ev_ebitda, analyst_actions
- `apac_expansion` — Regional expansion: region, status, key_deals

### capital_outflow_risk
- `project_cancellations` — Moratorium data, at_risk_pct, notable_cases
- `utilization_rate` — DC utilization trend (value, previous_value, trend)
- `meta_compute_monetization` — Meta compute sales event and market reaction
- `spv_risk` — SPV concerns array
- `bubble_warnings` — Warnings from analysts/institutions
- `capex_cashflow_ratio` — Capex vs operating cash flow ratio

### supply_demand
- `vacancy_rate` — North America DC vacancy
- `power_capacity` — Global DC power capacity
- `memory_company_earnings` — Samsung HBM/DRAM financials

### risk_triggers
- `not_triggered` — Risks that haven't materialized
- `new_monitoring` — New risks being watched
- `escalating` — Risks that are intensifying

## history.json — Snapshots Array

Each snapshot:
- `date` (date): Snapshot date
- `week` (string): Week identifier
- `summary` (string): One-line summary
- `capital_inflow_score` (0-10): Inflow strength
- `risk_score` (0-10): Risk level
- `net_signal` (string): Overall signal
- `key_events` (array): Event descriptions
- `risk_escalation` (array): New risk items
- `countervailing_signals` (array): Positive offsets
- `notes` (string): Analyst notes

## sources.json — Source Registry

- `primary_sources` — Array of {name, url, type, frequency, priority}
- `chinese_sources` — Array of Chinese-language sources
