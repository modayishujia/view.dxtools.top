#!/bin/bash
# AI 算力市场资本流向监控系统 - 周更新辅助脚本
# 用法: bash scripts/weekly-update.sh
# 
# 此脚本用于辅助每周数据更新流程：
# 1. 创建本周快照备份
# 2. 提示需要检查的指标
# 3. 记录更新日志

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
DATA_DIR="$PROJECT_DIR/data"
LOG_DIR="$PROJECT_DIR/logs"
TODAY=$(date +%Y-%m-%d)
WEEK_NUM=$(date +%V)

mkdir -p "$LOG_DIR"

echo "=========================================="
echo "  AI 算力市场资本流向监控 - 周更新"
echo "  日期: $TODAY (第${WEEK_NUM}周)"
echo "=========================================="
echo ""

# 备份当前数据
BACKUP_DIR="$LOG_DIR/snapshots/$TODAY"
mkdir -p "$BACKUP_DIR"
cp "$DATA_DIR/indicators.json" "$BACKUP_DIR/" 2>/dev/null || echo "[WARN] indicators.json 不存在"
cp "$DATA_DIR/history.json" "$BACKUP_DIR/" 2>/dev/null || echo "[WARN] history.json 不存在"

echo "✅ 数据已备份至: $BACKUP_DIR"
echo ""

# 更新提示
echo "📋 本周需要检查的指标："
echo ""
echo "【一级指标 - 每周必查】"
echo "  □ 超大规模厂商 Capex 指引变化"
echo "  □ SPV 新交易/违约/重组新闻"
echo "  □ 数据中心项目取消/延期"
echo "  □ REIT 股价 (DLR, EQIX)"
echo "  □ 北美数据中心空置率"
echo ""
echo "【二级指标 - 每两周查】"
echo "  □ 新资本入场 (PE/主权基金)"
echo "  □ 分析师评级变化"
echo "  □ 社区反对/立法进展"
echo "  □ 电力接入进度"
echo "  □ Capex/现金流比率"
echo ""
echo "【搜索关键词】"
echo "  英文: data center cancelled/delayed 2026, SPV data center, hyperscale capex"
echo "  中文: 数据中心 取消/延期, SPV 数据中心, AI capex 2026"
echo ""

# 检查上次更新时间
if [ -f "$LOG_DIR/last_update.txt" ]; then
    LAST_UPDATE=$(cat "$LOG_DIR/last_update.txt")
    echo "📅 上次更新: $LAST_UPDATE"
else
    echo "📅 首次运行，无历史记录"
fi

# 记录本次更新
echo "$TODAY" > "$LOG_DIR/last_update.txt"

echo ""
echo "📝 更新完成后，请手动编辑 data/indicators.json 和 data/history.json"
echo "   然后重新生成 index.html"
echo ""
echo "=========================================="
