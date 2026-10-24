#!/usr/bin/env bash
# Smoke test for https://guestpermits.com: every page loads, every local
# asset a page references loads, and CNAME is present in the repo.
# Exit code is non-zero if anything fails.
set -u

BASE="${SITE_BASE:-https://guestpermits.com}"
fail=0

check() {
  local url="$1" code
  code=$(curl -s -o /dev/null -w "%{http_code}" -L --max-time 20 "${url}?cb=$(date +%s)")
  if [ "$code" != "200" ]; then
    echo "FAIL $code $url"
    fail=1
  else
    echo "ok   $url"
  fi
}

for page in "" beta.html support.html privacy.html; do
  check "$BASE/$page"
  html=$(curl -s -L --max-time 20 "$BASE/$page?cb=$(date +%s)")
  refs=$(printf '%s' "$html" \
    | grep -oE '(src|href)="[^"#]+"' \
    | sed -E 's/^(src|href)="//; s/"$//' \
    | grep -vE '^(https?:|mailto:|tel:|//|data:)' \
    | sed -E 's/\?.*$//; s#^/##' \
    | sort -u)
  for ref in $refs; do
    [ -n "$ref" ] && check "$BASE/$ref"
  done
done

if [ -f CNAME ] && grep -qx "guestpermits.com" CNAME; then
  echo "ok   CNAME present"
else
  echo "FAIL CNAME missing or not 'guestpermits.com'"
  fail=1
fi

exit $fail
