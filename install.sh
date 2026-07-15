#!/usr/bin/env sh
# Agents Flow installer.
# Copies the skill and its six companion agent definitions into your
# omp (Oh My Pi) configuration so the harness can discover them.
#
# Override destinations with environment variables if your layout differs:
#   AGENTSFLOW_SKILLS_DIR   (default: ~/.agents/skills)
#   PI_CODING_AGENT_DIR     (default: ~/.omp/agent)   -> agents go in <base>/agents
#   AGENTSFLOW_AGENTS_DIR   (default: <PI_CODING_AGENT_DIR>/agents)

set -eu

SRC="$(cd "$(dirname "$0")" && pwd)"

SKILLS_DIR="${AGENTSFLOW_SKILLS_DIR:-$HOME/.agents/skills}"
AGENT_BASE="${PI_CODING_AGENT_DIR:-$HOME/.omp/agent}"
AGENTS_DIR="${AGENTSFLOW_AGENTS_DIR:-$AGENT_BASE/agents}"

# Safety guard: never operate on an empty destination path.
[ -n "$SKILLS_DIR" ] || { echo "SKILLS_DIR is empty; aborting." >&2; exit 1; }
[ -n "$AGENTS_DIR" ] || { echo "AGENTS_DIR is empty; aborting." >&2; exit 1; }

echo "Installing Agents Flow"
echo "  skill  -> $SKILLS_DIR/agentsflow"
echo "  agents -> $AGENTS_DIR"

mkdir -p "$SKILLS_DIR" "$AGENTS_DIR"

# Replace any previous skill copy cleanly.
rm -rf "$SKILLS_DIR/agentsflow"
cp -R "$SRC/skills/agentsflow" "$SKILLS_DIR/agentsflow"

for a in plan reviewer smol designer vision inspector_semantic; do
  cp "$SRC/agents/$a.md" "$AGENTS_DIR/$a.md"
done

echo "Done."
echo "Start a new omp session (or restart) so skill + agent discovery pick these up."
echo "Verify with:  omp   then type:  /skill:agentsflow"
