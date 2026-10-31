#!/usr/bin/env bash
# Fast, offline self-test for the HackerToolkit repo. Runs every static gate CI
# enforces, so you can check your change in one command before pushing.
#   ./scripts/selftest.sh
set -uo pipefail
cd "$(dirname "$0")/.."
fail=0
step() { printf '\n\033[1m• %s\033[0m\n' "$1"; }
ok()   { printf '  \033[32m✓\033[0m %s\n' "$1"; }
bad()  { printf '  \033[31m✗\033[0m %s\n' "$1"; fail=1; }

step "bash -n (syntax)"
for f in install.sh scripts/*.sh; do
    bash -n "$f" && ok "$f" || bad "$f"
done

step "shellcheck --severity=error"
if command -v shellcheck >/dev/null 2>&1; then
    shellcheck --severity=error install.sh scripts/*.sh && ok "no errors" || bad "shellcheck errors"
else
    echo "  (shellcheck not installed — skipped)"
fi

step "CLI: --help / --list"
bash install.sh --help >/dev/null 2>&1 && ok "--help exits 0" || bad "--help"
n=$(bash install.sh --list 2>/dev/null | grep -c '•'); rm -rf HackerToolkit
[ "${n:-0}" -ge 20 ] && ok "--list printed $n tools" || bad "--list printed only ${n:-0}"

step "doctor runs"
bash install.sh doctor >/dev/null 2>&1; rc=$?
[ "$rc" -eq 0 ] || [ "$rc" -eq 1 ] && ok "doctor ran (exit $rc)" || bad "doctor crashed (exit $rc)"

step "manifest <-> README in sync"
bash scripts/check-sync.sh && ok "in sync" || bad "drift"

step "gen-toc is idempotent"
cp README.md /tmp/.st.a 2>/dev/null
bash scripts/gen-toc.sh >/dev/null
if diff -q /tmp/.st.a README.md >/dev/null 2>&1; then ok "no ToC drift"; else bad "ToC not regenerated/committed — run scripts/gen-toc.sh"; fi
rm -f /tmp/.st.a

echo
if [ "$fail" -eq 0 ]; then printf '\033[32mSELF-TEST PASSED\033[0m\n'; else printf '\033[31mSELF-TEST FAILED\033[0m\n'; fi
exit "$fail"
