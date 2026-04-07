#!/usr/bin/env bash
set -euo pipefail

YAMDC_BIN="${YAMDC_BIN:-yamdc}"
RULESET_DIR="${RULESET_DIR:-./}"
CASEFILE="${CASEFILE:-./cases}"

RESULT="$(${YAMDC_BIN} ruleset-test --ruleset "${RULESET_DIR}" --casefile "${CASEFILE}" --output=json)"
printf '%s\n' "${RESULT}"

RESULT_JSON="${RESULT}" python3 - <<'INNER'
import json
import os
import sys

raw = os.environ.get("RESULT_JSON", "")
try:
    data = json.loads(raw)
except Exception as exc:
    print(f"invalid ruleset-test output: {exc}", file=sys.stderr)
    sys.exit(1)

if data.get("pass"):
    sys.exit(0)

errmsg = data.get("errmsg") or "ruleset test failed"
print(errmsg, file=sys.stderr)
for item in data.get("cases") or []:
    if item.get("pass"):
        continue
    name = item.get("name") or "unknown"
    case_err = item.get("errmsg") or "case failed"
    print(f"- {name}: {case_err}", file=sys.stderr)

sys.exit(1)
INNER
