#!/bin/bash
# <xbar.title>Anthropic Credits Balance</xbar.title>
# <xbar.version>1.0</xbar.version>
# <xbar.author>Adrian Narloch (narloch.dev)</xbar.author>
# <xbar.desc>Displays Anthropic prepaid credit balance.</xbar.desc>
# <xbar.dependencies>bash,curl,python3</xbar.dependencies>
# <xbar.author.github>AdrianNarloch</xbar.author.github>
# <xbar.abouturl>https://github.com/AdrianNarloch/xbar-anthropic-credits-balance</xbar.abouturl>

set -u

readonly PROVIDER_NAME="Anthropic"
readonly ENDPOINT_URL="https://platform.claude.com/api/organizations/<org-id>/prepaid/credits"
readonly SESSION_KEY="<your-session-key>"

print_error() {
  local message="$1"
  local raw_json="${2:-}"

  echo "${PROVIDER_NAME}: -- | color=red"
  echo "---"
  echo "Error: ${message}"

  if [[ -n "${raw_json}" ]]; then
    echo "Raw: ${raw_json}"
  fi
}

fetch_json() {
  curl -fsS --max-time 5 \
    -H "Cookie: sessionKey=${SESSION_KEY}" \
    "${ENDPOINT_URL}" 2>/dev/null
}

build_title() {
  local json_input="$1"

  printf '%s' "${json_input}" | python3 -c '
import json
import sys

try:
    payload = json.load(sys.stdin)
    amount_cents = payload.get("amount")
    if amount_cents is None:
        print("")
    else:
        amount = amount_cents / 100
        formatted = f"{amount:.2f}".rstrip("0").rstrip(".")
        print(f"Anthropic: ${formatted}")
except Exception:
    print("")
'
}

main() {
  local json_response
  local title

  json_response="$(fetch_json)"
  if [[ -z "${json_response}" ]]; then
    print_error "empty response"
    exit 0
  fi

  title="$(build_title "${json_response}")"
  if [[ -z "${title}" ]]; then
    print_error "failed to parse JSON or missing 'amount'" "${json_response}"
    exit 0
  fi

  echo "${title}"
  echo "---"
  echo "Refresh now | refresh=true"
}

main
