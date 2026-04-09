#!/usr/bin/env bash
# version: 1.0 | status: draft | last_updated: 2026-04-09
# C-15: Auto-Recall Relevance Filtering — UserPromptSubmit hook
# Purpose: Classify the user's intent and set a token budget for QMD auto-recall
#          queries, reducing noise from unfiltered 2000 tok/turn recall.
# Hook type: UserPromptSubmit
# Exit: 0 always (non-blocking, advisory)
#
# Intent categories and token budgets:
#   design   → 2000 tokens  (high-relevance: needs architecture context)
#   build    → 2000 tokens  (high-relevance: needs prior artifact context)
#   validate → 2000 tokens  (high-relevance: needs full acceptance criteria)
#   research → 2000 tokens  (high-relevance: needs broad background)
#   general  → 1000 tokens  (lower-relevance: conversational / ambiguous)

INPUT=$(cat)

PROMPT=$(echo "$INPUT" | jq -r '.prompt // ""')

# Convert to lowercase for keyword matching (bash 3 compatible)
LOWER=$(echo "$PROMPT" | tr '[:upper:]' '[:lower:]')

# Detect intent — ordered, first match wins
INTENT="general"

# Design: planning / architecture keywords
if echo "$LOWER" | grep -qE 'design|architecture|blueprint|plan the'; then
  INTENT="design"
# Build: implementation keywords
elif echo "$LOWER" | grep -qE 'build|implement|create|write|code|develop'; then
  INTENT="build"
# Validate: review / verification keywords
elif echo "$LOWER" | grep -qE 'validate|review|check|test|verify'; then
  INTENT="validate"
# Research: exploration / discovery keywords
elif echo "$LOWER" | grep -qE 'research|investigate|explore|what is|how does'; then
  INTENT="research"
fi

# Token budgets by intent category
# High-relevance tasks: 2000 tokens; lower-relevance: 1000 tokens
case "$INTENT" in
  design|validate) TOKEN_BUDGET=2000 ;;
  build|research)  TOKEN_BUDGET=2000 ;;
  *)               TOKEN_BUDGET=1000 ;;
esac

# Persist the intent and budget for consumption by other hooks / skills
echo "$INTENT:$TOKEN_BUDGET" > /tmp/recall-intent.tmp

echo "Auto-recall intent: $INTENT -> token budget: $TOKEN_BUDGET" >&2

exit 0
