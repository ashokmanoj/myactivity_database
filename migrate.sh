#!/usr/bin/env bash
# ============================================================================
# migrate.sh — MyActivity Database Migration Runner
#
# Usage:
#   ./migrate.sh up            → apply all pending UP migrations
#   ./migrate.sh status        → show applied migrations
#   ./migrate.sh down <ver>    → rollback a specific version
#
# Environment (override via export or .env in database/ dir):
#   DB_HOST, DB_PORT, DB_NAME, DB_USER, DB_PASSWORD
# ============================================================================
set -euo pipefail

# ── Load .env from database folder if present ────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
if [ -f "$SCRIPT_DIR/../backend/.env" ]; then
  # shellcheck disable=SC1091
  set -a; source "$SCRIPT_DIR/../backend/.env"; set +a
fi

# ── Config ───────────────────────────────────────────────────────────────────
DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"
DB_NAME="${DB_NAME:-myactivitydb}"
DB_USER="${DB_USER:-postgres}"
DDL_DIR="$SCRIPT_DIR/ddl"

export PGPASSWORD="${DB_PASSWORD:-}"
PSQL="psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME"

# ── Helpers ──────────────────────────────────────────────────────────────────
log()  { echo "[$(date '+%H:%M:%S')] $*"; }
fail() { echo "❌  $*" >&2; exit 1; }

# ── Ensure schema_versions table exists (uses public schema) ─────────────────
ensure_versions_table() {
  $PSQL -q <<'SQL'
CREATE TABLE IF NOT EXISTS public.schema_versions (
    id             BIGSERIAL PRIMARY KEY,
    version        VARCHAR(20)  NOT NULL,
    migration_file VARCHAR(200) NOT NULL,
    direction      VARCHAR(4)   NOT NULL DEFAULT 'UP',
    applied_at     TIMESTAMPTZ  DEFAULT NOW(),
    applied_by     VARCHAR(100) DEFAULT current_user,
    status         VARCHAR(20)  DEFAULT 'SUCCESS',
    UNIQUE (migration_file, direction)
);
SQL
}

# ── Commands ─────────────────────────────────────────────────────────────────
CMD="${1:-up}"

case "$CMD" in

  up)
    log "🚀 Running UP migrations from $DDL_DIR"
    ensure_versions_table

    for file in "$DDL_DIR"/*.sql; do
      [ -f "$file" ] || continue
      filename=$(basename "$file")

      applied=$($PSQL -tAc "
        SELECT COUNT(*) FROM public.schema_versions
        WHERE migration_file = '$filename' AND direction = 'UP' AND status = 'SUCCESS';
      ")

      if [ "${applied:-0}" -gt 0 ]; then
        log "  ⏭  Skipping $filename (already applied)"
      else
        log "  ▶  Applying $filename ..."
        start_ms=$(date +%s%3N)
        $PSQL -f "$file" -q
        end_ms=$(date +%s%3N)
        elapsed=$((end_ms - start_ms))
        log "  ✅ $filename done in ${elapsed}ms"
      fi
    done

    log "✅ All migrations applied."
    ;;

  status)
    log "📋 Applied migrations:"
    $PSQL -c "
      SELECT migration_file, version, direction, status, applied_at
      FROM public.schema_versions
      ORDER BY applied_at;
    "
    ;;

  down)
    VERSION="${2:-}"
    [ -z "$VERSION" ] && fail "Usage: ./migrate.sh down <version>  e.g. v1.0.0"
    log "⏪ Rolling back version $VERSION ..."
    DOWN_DIR="$SCRIPT_DIR/migrations/$VERSION/DOWN"
    [ -d "$DOWN_DIR" ] || fail "No DOWN directory at $DOWN_DIR"
    for file in $(ls "$DOWN_DIR"/*.sql | sort -r); do
      log "  ▶  Reverting $(basename "$file") ..."
      $PSQL -f "$file" -q
    done
    log "✅ Rollback complete for $VERSION"
    ;;

  *)
    echo "Usage: ./migrate.sh [up | status | down <version>]"
    exit 1
    ;;
esac
