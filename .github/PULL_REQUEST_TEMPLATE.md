<!--
Thanks for contributing! Please fill in the checklist below.
See CONTRIBUTING.md for the full quality bar.
-->

## What does this PR do?

<!-- One or two sentences. Link any related issue (e.g. Closes #123). -->

## Type of change

- [ ] New tool
- [ ] Remove / rename a tool
- [ ] Fix to `install.sh`
- [ ] Docs / metadata only
- [ ] Other (describe above)

## Catalog sync (required when adding, removing, or renaming a tool)

The installer and the catalog must stay in sync — a tool lives in **both** places.

- [ ] Added/updated the tool's row in **`tools.tsv`** (category, name, command, method, source, description).
- [ ] Added/updated the tool in **`README.md`** (regenerated via `./scripts/gen-readme.sh`, not hand-edited, so ToC anchors stay correct).
- [ ] `./install.sh --list` shows the tool in the right category.
- [ ] `method` is one of the documented conventions (`go`, `apt`, `pipx`, `cargo`, `gh-release`, `git-venv`, `git-make`, `git-shim`, `script`, `manual`).
- [ ] If a version is pinned, the row/notes say **why**.

## Quality gate (CI will check these)

- [ ] `bash -n install.sh` passes.
- [ ] `shellcheck --severity=error install.sh` passes.
- [ ] Ran plain `shellcheck install.sh` and fixed new warnings in code I touched (intentional disables carry an inline `# shellcheck disable=...`).
- [ ] Path expansions are quoted; used `safe_cd` instead of bare `cd`; generated launchers forward args with `"$@"`.
- [ ] Tested the install on a clean Kali/Debian box or container (if applicable).

## Scope / policy

- [ ] This change packages an **existing, published** tool for **authorized** testing/education, and does **not** add malware, non-consensual surveillance tooling, or anything whose primary purpose is unauthorized access (see `DISCLAIMER.md` / `CONTRIBUTING.md`).
