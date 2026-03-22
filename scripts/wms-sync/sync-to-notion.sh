#!/usr/bin/env bash
# LEP WMS Sync: .exec/ → Notion (STUB — Iteration 2)
#
# Notion sync is deferred to Iteration 2 per spec §9.3 and §9.5.
# The Notion adapter requires the notion-planner Iteration Item Level refactor first.
#
# For MVP (Iteration 1): Use the OE.6.3 notion-planner skill directly for manual sync.
# See: skills/ltc-wms-adapters/notion/adapter.md §7 (MVP Workaround)

echo "INFO: Notion sync is deferred to Iteration 2."
echo ""
echo "For Iteration 1 manual sync:"
echo "  1. Load the OE.6.3 notion-planner skill"
echo "  2. Map .exec/ task fields to Notion properties using:"
echo "     skills/ltc-wms-adapters/notion/field-map.md"
echo "  3. Follow hierarchy rules in:"
echo "     skills/ltc-wms-adapters/notion/task-protocol.md"
echo "  4. Set Canonical Key = task ID (D{n}-T{m}) for future idempotent sync"
echo ""
echo "Iteration 2 requirements:"
echo "  - notion-planner Iteration Item Level refactor"
echo "  - Notion Task Board 'Canonical Key' property"
echo "  - End-to-end Agent Pull Pattern test with Notion comments"
echo ""
echo "See: skills/ltc-wms-adapters/notion/adapter.md §6"

exit 0
