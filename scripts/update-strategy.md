# AI Compute Capital Flow - Update Strategy

## Overview

This document describes the complete data pipeline, sources, and scraping strategy for the AI Compute Capital Flow Dashboard.

## Data Architecture

```
Data Flow:
  External Sources → Manual/Semi-auto Collection → indicators.json → Dashboard HTML → Cloudflare Pages
                                                   ↑
                                              history.json (weekly snapshots)
```

## Source Directory

### Tier 1: Primary Data (Weekly Update)

| Source | URL | Data Type | Update Freq | Method |
|--------|-----|-----------|-------------|--------|
| Korea Customs | customs.go.kr | DRAM/NAND/HBM export prices | Monthly | Manual extraction |
| TrendForce | trendforce.com | Contract prices QoQ | Weekly | Newsletter subscription |
| Goldman Sachs | Research reports | Supply-demand gap % | Quarterly | Research report |
| Jefferies | Research reports | Price forecasts Q3/Q4 | Quarterly | Research report |
| Bloomberg | bloomberg.com | Capex, project status | Daily | News monitoring |

### Tier 2: Secondary Data (Bi-weekly)

| Source | URL | Data Type | Update Freq | Method |
|--------|-----|-----------|-------------|--------|
| SemiAnalysis | semianalysis.com | Capacity analysis | Monthly | Subscription |
| Data Center Watch | datacenterwatch.org | Moratorium tracking | Weekly | News monitoring |
| IDC | idc.com | Shipment forecasts | Quarterly | Report |
| Gartner | gartner.com | Memory/power forecasts | Quarterly | Report |
| Arizton | arizton.com | Regional investment | Quarterly | Report |

### Tier 3: Reference Data (Monthly)

| Source | URL | Data Type | Update Freq | Method |
|--------|-----|-----------|-------------|--------|
| Financial Times | ft.com | SPV/structured finance | As needed | News monitoring |
| Reuters | reuters.com | Project cancellations | As needed | News monitoring |
| SEC Filings | sec.gov | Actual capex, FCF | Quarterly | Manual |

## Key Metrics to Track

### Storage Prices

| Metric | Source | Current | Update Method |
|--------|--------|---------|---------------|
| DRAM YoY (Korea Customs) | Korea Customs | +497% | Manual from customs report |
| NAND YoY (Korea Customs) | Korea Customs | +352% | Manual from customs report |
| HBM YoY (Korea Customs) | Korea Customs | +166% | Manual from customs report |
| DRAM QoQ contract | TrendForce | +58-63% | TrendForce newsletter |
| NAND QoQ contract | TrendForce | +70-75% | TrendForce newsletter |
| Q3 forecast | Jefferies/GS | TBD | Research reports |

### AI Infrastructure

| Metric | Source | Current | Update Method |
|--------|--------|---------|---------------|
| 9-CSP Capex | TrendForce/SEC | $830B | Earnings + reports |
| Capex/Revenue | UBS/MS | >30% | Calculated |
| DC Utilization | Industry reports | 68% | Quarterly reports |
| Moratorium count | Data Center Watch | 300+ | News monitoring |

### Consumer Electronics Impact

| Metric | Source | Current | Update Method |
|--------|--------|---------|---------------|
| Smartphone shipments YoY | IDC | -13.9% | IDC quarterly |
| Memory BOM ratio | TrendForce | 30-40% | TrendForce |
| Apple memory BOM | Supply chain | ~45% | Supply chain reports |
| PC price impact | Industry | +500-1500 RMB | Industry reports |

## Scraping Strategy

### Automated (where possible)

1. **GitHub API** - Track repository updates for open-source research
2. **RSS Feeds** - Subscribe to TrendForce, SemiAnalysis newsletters
3. **SEC EDGAR** - Monitor 10-Q/10-K filings for capex data

### Semi-automated

1. **Browser scraping** - Use Kimi WebBridge for:
   - Alibaba Cloud DNS changes
   - Cloudflare Pages deployment status
   - Stock price data from Yahoo Finance

2. **API calls** - Use Cloudflare API for:
   - Pages deployment status
   - Custom domain verification

### Manual (required)

1. **Research reports** - Extract data from:
   - Goldman Sachs memory pricing tracker
   - Jefferies memory outlook
   - Morgan Stanley AI capex forecasts
   - TrendForce weekly reports

2. **News monitoring** - Track:
   - Hyperscaler capex announcements
   - DC project cancellations/approvals
   - Moratorium legislation updates
   - Apple/memory company earnings

## Deployment Pipeline

```
1. Edit data/indicators.json manually
2. Update data/history.json with snapshot
3. Run: wrangler pages deploy . --project-name=view-dxtools-top --branch=main
4. Verify: curl -s -o /dev/null -w "%{http_code}" https://view.dxtools.top/
5. Optional: git push origin main
```

## Emergency Update Procedure

If a breaking event occurs (e.g., major capex cut, SPV default):

1. Immediately update indicators.json with new data
2. Add snapshot to history.json
3. Deploy: `wrangler pages deploy . --project-name=view-dxtools-top --branch=main`
4. Notify stakeholders
