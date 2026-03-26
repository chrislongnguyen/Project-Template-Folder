#!/bin/bash
# LTC Project Scaffold — v1.0
# Usage: bash scaffold.sh <project-name>
# Creates a new project using the LTC Standard Project Folder Structure
#
# Derived From: LTC Capital Partners — Standard Project Folder Structure
# Core Equation: Success = Efficient & Scalable Management of Failure Risks

set -e

PROJECT_NAME=${1:-"new-project"}

echo "Creating LTC project structure: $PROJECT_NAME"

# Zone 0 — Agent Governance
mkdir -p "$PROJECT_NAME"/{.claude,.gemini/antigravity/brain,.mcp}

# Zone 1 — ALIGN
mkdir -p "$PROJECT_NAME"/1-ALIGN/{charter,okrs,decisions}

# Zone 2 — PLAN
mkdir -p "$PROJECT_NAME"/2-PLAN/{risks,drivers,learning/{research,spikes},architecture/{diagrams,ADRs},roadmap}

# Zone 3 — EXECUTE
mkdir -p "$PROJECT_NAME"/3-EXECUTE/{src/{core,ui,api,infra,shared},tests/{unit,integration,e2e,quality-gates},config/{env,security,ci-cd},docs/{api,runbooks,onboarding}}

# Zone 4 — IMPROVE
mkdir -p "$PROJECT_NAME"/4-IMPROVE/{reviews,retrospectives,risk-log,metrics,changelog}

# Shared Knowledge Base
mkdir -p "$PROJECT_NAME"/_shared/{brand/assets,security,frameworks,templates,sops}

# Create root README
cat > "$PROJECT_NAME/README.md" << 'EOF'
# PROJECT_NAME_PLACEHOLDER

## Quick Start
See `3-EXECUTE/docs/onboarding/GETTING_STARTED.md`.

## Structure
Zone 0 — Agent Governance       → CLAUDE.md, AGENTS.md, .claude/, .gemini/, .mcp/
Zone 1 — ALIGN (Right Outcome)  → 1-ALIGN/
Zone 2 — PLAN (Minimize Risks)  → 2-PLAN/
Zone 3 — EXECUTE (Deliver)      → 3-EXECUTE/
Zone 4 — IMPROVE (Learn & Grow) → 4-IMPROVE/
Shared  — Org Knowledge Base    → _shared/

**Core Equation:** Success = Efficient & Scalable Management of Failure Risks
EOF

sed -i "s/PROJECT_NAME_PLACEHOLDER/$PROJECT_NAME/g" "$PROJECT_NAME/README.md"

# Create .gitkeep files for empty directories
find "$PROJECT_NAME" -type d -empty -exec touch {}/.gitkeep \;

echo ""
echo "LTC project structure created at ./$PROJECT_NAME"
echo ""
echo "Next steps:"
echo "  1. Copy agent configs (CLAUDE.md, AGENTS.md, GEMINI.md) from the template"
echo "  2. Copy _shared/ contents from the LTC template repository"
echo "  3. Fill in 1-ALIGN/charter/PROJECT_CHARTER.md"
echo "  4. Identify risks in 2-PLAN/risks/UBS_REGISTER.md"
echo "  5. Start building in 3-EXECUTE/src/"
