# HackerToolkit — convenience targets.
# Run `make help` for the list. Pass extra installer flags with ARGS=...,
# e.g. `make install ARGS="--yes --only-cat=Vulnerability-Scanners"`.

SHELL       := /bin/bash
IMAGE       ?= hackertoolkit:latest
ARGS        ?=
# Categories skipped by the default container build (mirrors the Dockerfile).
DEFAULT_SKIP := C2,Phishing-Smishing-Etc,Stealth,Distribution

.DEFAULT_GOAL := help
.PHONY: help install install-all doctor update lint docker-build docker-run

help: ## Show this help
	@echo "HackerToolkit make targets:"
	@grep -E '^[a-zA-Z0-9_-]+:.*?## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN{FS=":.*?## "}{printf "  \033[36m%-14s\033[0m %s\n", $$1, $$2}'

install: ## Run the installer (interactive; pass flags via ARGS=...)
	./install.sh $(ARGS)

install-all: ## Install every tool, non-interactively (accepts the legal terms)
	./install.sh --yes $(ARGS)

doctor: ## Health-check: is every tool resolvable?
	./install.sh doctor

update: ## Update installed tools (pipx/nuclei templates/etc.)
	./install.sh update

lint: ## Static-check install.sh (bash -n + shellcheck errors only)
	bash -n install.sh
	@command -v shellcheck >/dev/null 2>&1 \
		|| { echo "shellcheck not installed — skipping (install: apt-get install shellcheck)"; exit 1; }
	shellcheck --severity=error install.sh

docker-build: ## Build the container image (override tag with IMAGE=...)
	docker build -t $(IMAGE) .

docker-run: ## Open an interactive shell in the built image
	docker run --rm -it $(IMAGE)
