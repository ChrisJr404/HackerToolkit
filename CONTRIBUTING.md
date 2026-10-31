# Contributing to HackerToolkit

Thanks for helping keep this toolkit useful and safe.

## Golden rule: the installer and the catalog must stay in sync

Every tool lives in **two** places that must agree:

1. **`tools.tsv`** — the manifest the installer reads (category, name, method,
   source, binary, description).
2. **`README.md`** — the human catalog and its Table of Contents.

When you add, remove, or rename a tool:

- [ ] Add/update its row in `tools.tsv`.
- [ ] Regenerate the README catalog (`./scripts/gen-readme.sh`) rather than
      hand-editing the tool list, so the ToC anchors stay correct.
- [ ] Run `./install.sh --list` and confirm your tool appears in the right
      category.
- [ ] Test the install on a clean Kali/Debian box (or a container).
- [ ] If you pin a version, say why in the row's notes.

## Install-method conventions

`method` in `tools.tsv` is one of: `go`, `apt`, `pipx`, `cargo`, `gh-release`,
`git-venv`, `git-make`, `git-shim`, `script`, `manual`. Prefer a maintained
upstream and a release over `curl | bash` where possible.

## Scope / policy boundary

This project packages **existing, published** offensive-security tools for
**authorized** testing and education (see `DISCLAIMER.md`). Pull requests that
add malware, non-consensual surveillance tooling, or anything whose primary
purpose is unauthorized access will be closed. Issues describing or requesting
help with illegal use will be closed.

## Shell style

- `install.sh` must pass `shellcheck install.sh` with no warnings.
- Quote expansions; use the provided `safe_cd` helper instead of bare `cd`.
