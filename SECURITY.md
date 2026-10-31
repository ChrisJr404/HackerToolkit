# Security Policy

## Scope

This repository is an **installer and catalog** — it downloads and builds
third-party security tools. It contains no network services of its own.

## Reporting an issue with this repository

If you find a problem in `install.sh` or the manifest that could harm a user
who runs it (for example: an insecure download, a command-injection vector in
the installer, a typo-squatted or compromised upstream source, or a supply-
chain concern), please open a GitHub issue, or for sensitive reports use
GitHub's **Report a vulnerability** (Security Advisories) on this repo.

Please include the affected line(s), what happens, and a suggested fix.

## Reporting a vulnerability in one of the installed tools

Report those **upstream**, to the tool's own project (see the links in
`README.md`). This repository only packages them.

## Supply-chain notes

- `install.sh` fetches code from third-party GitHub repositories and release
  assets. Pin and review upstreams you do not trust.
- A few tools are installed via `curl | bash` from their official installers;
  these are called out in the script. Review them before running on a host you
  care about.
