# Da Nang BizGuide — local development
#
#   make dev     start everything, follow the logs, Ctrl-C to stop
#
# Everything else is optional. `dev` performs its own setup and is safe to
# re-run: each step checks whether it is already done before doing it.

# Resolved rather than hardcoded: make execs SHELL directly, so it must be a
# real path — "/usr/bin/env bash" is read as a single filename and fails.
SHELL := $(shell command -v bash 2>/dev/null || echo /bin/bash)
.SHELLFLAGS := -eu -o pipefail -c
.ONESHELL:
.DEFAULT_GOAL := help

# --- Ports ------------------------------------------------------------------
# 8100 rather than 8000 for the AI service: 8000 collides with too much.
DB_PORT       ?= 5433
AI_PORT       ?= 8100
API_PORT      ?= 3456
WEB_PORT      ?= 3457

DB_CONTAINER  ?= bizguide-pg
DB_IMAGE      ?= pgvector/pgvector:pg17
DB_NAME       ?= bizguide
DATABASE_URL  ?= postgresql://postgres:postgres@localhost:$(DB_PORT)/$(DB_NAME)?schema=public

ROOT          := $(shell pwd)
LOG_DIR       := $(ROOT)/.dev-logs
PID_DIR       := $(ROOT)/.dev-pids
VENV          := $(ROOT)/ai/.venv
PY            := $(VENV)/bin/python

BOLD := \033[1m
DIM  := \033[2m
OK   := \033[32m
WARN := \033[33m
ERR  := \033[31m
OFF  := \033[0m

.PHONY: help dev setup stop restart status logs check submodules env db db-stop db-reset \
        migrate deps build ingest test test-ai test-api eval clean psql

## ---------------------------------------------------------------------------
## Main entry point
## ---------------------------------------------------------------------------

dev: check submodules env db migrate deps build ## Start the whole stack and follow logs
	@mkdir -p "$(LOG_DIR)" "$(PID_DIR)"
	printf "$(BOLD)Starting services$(OFF)\n"

	# Anything left over from a previous run would fail to bind its port.
	$(MAKE) -s stop

	# setsid gives each service its own process group. Without it they inherit
	# make's group, and `make stop` killing that group would kill make too.
	cd "$(ROOT)/ai"
	setsid "$(VENV)/bin/uvicorn" app.main:app --host 127.0.0.1 --port $(AI_PORT) \
		> "$(LOG_DIR)/ai.log" 2>&1 < /dev/null &
	echo $$! > "$(PID_DIR)/ai.pid"

	cd "$(ROOT)/backend"
	setsid node dist/main > "$(LOG_DIR)/api.log" 2>&1 < /dev/null &
	echo $$! > "$(PID_DIR)/api.pid"

	cd "$(ROOT)/frontend"
	setsid npm run dev -- -p $(WEB_PORT) > "$(LOG_DIR)/web.log" 2>&1 < /dev/null &
	echo $$! > "$(PID_DIR)/web.pid"

	cd "$(ROOT)"
	$(MAKE) -s wait-ready
	$(MAKE) -s ingest
	$(MAKE) -s banner

	# Ctrl-C must take the background services down with it, or the next run
	# fails on ports that are still bound.
	trap '$(MAKE) -s stop; exit 0' INT TERM
	tail -f "$(LOG_DIR)/ai.log" "$(LOG_DIR)/api.log" "$(LOG_DIR)/web.log" &
	wait $$!

.PHONY: wait-ready banner
wait-ready:
	@printf "$(DIM)waiting for services$(OFF)"
	for i in $$(seq 1 90); do
		ai=$$(curl -s -o /dev/null -m 5 -w '%{http_code}' "http://127.0.0.1:$(AI_PORT)/health" || true)
		api=$$(curl -s -o /dev/null -m 5 -w '%{http_code}' "http://localhost:$(API_PORT)/api/v1/health" || true)
		web=$$(curl -s -o /dev/null -m 15 -w '%{http_code}' "http://localhost:$(WEB_PORT)/" || true)
		if [[ "$$ai" == 200 && "$$api" == 200 && "$$web" == 200 ]]; then
			printf " $(OK)ready$(OFF)\n"; exit 0
		fi
		printf "."; sleep 1
	done
	printf " $(ERR)timed out$(OFF)\n"
	printf "  ai=%s api=%s web=%s — see .dev-logs/\n" "$$ai" "$$api" "$$web"
	printf "  tail -n 40 .dev-logs/ai.log .dev-logs/api.log .dev-logs/web.log\n"
	exit 1

banner:
	@chunks=$$(curl -sf "http://127.0.0.1:$(AI_PORT)/health" | sed -n 's/.*"approved_chunks":\([0-9]*\).*/\1/p')
	printf "\n$(BOLD)  Chat UI      $(OK)http://localhost:$(WEB_PORT)/chatbot$(OFF)\n"
	printf "$(BOLD)  API docs     $(OFF)http://localhost:$(API_PORT)/api-docs\n"
	printf "$(BOLD)  AI docs      $(OFF)http://127.0.0.1:$(AI_PORT)/docs\n"
	printf "$(BOLD)  Postgres     $(OFF)localhost:$(DB_PORT)/$(DB_NAME)\n"
	printf "$(DIM)  %s approved chunks · Ctrl-C to stop everything$(OFF)\n\n" "$${chunks:-0}"

## ---------------------------------------------------------------------------
## Setup steps — each is idempotent and re-run by `dev`
## ---------------------------------------------------------------------------

check: ## Verify required tools are installed
	@missing=0
	for tool in docker node npm python3 curl git; do
		if ! command -v $$tool >/dev/null 2>&1; then
			printf "$(ERR)missing:$(OFF) %s\n" "$$tool"; missing=1
		fi
	done
	if ! docker info >/dev/null 2>&1; then
		printf "$(ERR)docker is installed but not usable$(OFF) — is the daemon running?\n"; missing=1
	fi
	[[ $$missing -eq 0 ]] || { printf "\nInstall the above, then re-run.\n"; exit 1; }

submodules:
	@if [[ ! -f ai/pyproject.toml || ! -f backend/package.json || ! -f frontend/package.json ]]; then
		printf "$(BOLD)Initialising submodules$(OFF)\n"
		git submodule update --init ai backend frontend
	fi

env: ## Create .env files from the examples if absent
	@for dir in backend ai; do
		if [[ ! -f "$$dir/.env" ]]; then
			cp "$$dir/.env.example" "$$dir/.env"
			printf "$(WARN)created $$dir/.env from the example$(OFF)\n"
		fi
	done

	# Point both services at the database this Makefile actually starts.
	sed -i.bak "s|^DATABASE_URL=.*|DATABASE_URL=\"$(DATABASE_URL)\"|" backend/.env && rm -f backend/.env.bak
	sed -i.bak "s|^DATABASE_URL=.*|DATABASE_URL=\"$(DATABASE_URL)\"|" ai/.env && rm -f ai/.env.bak

	# The stack starts without keys but every answer will fail, so say so once
	# and loudly rather than letting it surface as a runtime error.
	missing=""
	grep -qE '^DEEPSEEK_API_KEY=.+' ai/.env    || missing="$$missing DEEPSEEK_API_KEY"
	grep -qE '^EMBEDDING_API_KEY=.+' ai/.env   || missing="$$missing EMBEDDING_API_KEY"
	if [[ -n "$$missing" ]]; then
		printf "\n$(ERR)Missing API keys in ai/.env:$(OFF)%s\n" "$$missing"
		printf "  DeepSeek  https://platform.deepseek.com\n"
		printf "  Voyage    https://dash.voyageai.com\n"
		printf "  Retrieval and answers will fail until these are set.\n\n"
	fi

db: ## Start Postgres with pgvector
	@if [[ -n "$$(docker ps -q -f name=^/$(DB_CONTAINER)$$)" ]]; then
		exit 0
	fi
	if [[ -n "$$(docker ps -aq -f name=^/$(DB_CONTAINER)$$)" ]]; then
		printf "$(BOLD)Starting existing $(DB_CONTAINER)$(OFF)\n"
		docker start $(DB_CONTAINER) >/dev/null
	else
		printf "$(BOLD)Creating $(DB_CONTAINER) on port $(DB_PORT)$(OFF)\n"
		docker run -d --name $(DB_CONTAINER) \
			-e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=$(DB_NAME) \
			-p $(DB_PORT):5432 $(DB_IMAGE) >/dev/null
	fi
	printf "$(DIM)waiting for postgres$(OFF)"
	for i in $$(seq 1 60); do
		if docker exec $(DB_CONTAINER) pg_isready -U postgres >/dev/null 2>&1; then
			printf " $(OK)ready$(OFF)\n"; exit 0
		fi
		printf "."; sleep 1
	done
	printf " $(ERR)timed out$(OFF)\n"; docker logs --tail 20 $(DB_CONTAINER); exit 1

migrate: ## Apply Prisma migrations
	@cd backend
	if [[ ! -d node_modules ]]; then
		printf "$(BOLD)Installing backend dependencies$(OFF)\n"; npm install --silent
	fi
	printf "$(BOLD)Applying migrations$(OFF)\n"
	npx prisma migrate deploy 2>&1 | grep -vE '^\s*$$' | tail -3

deps: ## Install dependencies for all three services
	@if [[ ! -x "$(PY)" ]]; then
		printf "$(BOLD)Creating the Python virtualenv$(OFF)\n"
		python3 -m venv "$(VENV)"
	fi
	if ! "$(PY)" -c 'import fastapi, asyncpg, yaml' >/dev/null 2>&1; then
		printf "$(BOLD)Installing AI service dependencies$(OFF)\n"
		"$(VENV)/bin/pip" install -q --upgrade pip
		"$(VENV)/bin/pip" install -q -e './ai[dev]'
	fi
	if [[ ! -d frontend/node_modules ]]; then
		printf "$(BOLD)Installing frontend dependencies$(OFF)\n"
		cd frontend && npm install --silent
	fi

build: ## Compile the backend
	@cd backend
	# dist/main.js is what `node dist/main` runs; rebuild when sources are newer.
	if [[ ! -f dist/main.js ]] || [[ -n "$$(find src prisma -newer dist/main.js -type f 2>/dev/null | head -1)" ]]; then
		printf "$(BOLD)Building the backend$(OFF)\n"
		npm run build
	fi

ingest: ## Load the fixture documents if the knowledge base is empty
	@chunks=$$(curl -sf "http://127.0.0.1:$(AI_PORT)/health" | sed -n 's/.*"approved_chunks":\([0-9]*\).*/\1/p')
	if [[ "$${chunks:-0}" -gt 0 ]]; then exit 0; fi
	printf "$(BOLD)Knowledge base is empty — loading fixtures$(OFF)\n"
	printf "$(WARN)  These are synthetic test documents, not official sources.$(OFF)\n"
	printf "$(WARN)  Put real curated sources in data/raw-official-sources/.$(OFF)\n"
	cd ai
	"$(PY)" scripts/ingest_file.py tests/fixtures/tnhh-vi.txt \
		--title "Hướng dẫn thành lập công ty TNHH tại Đà Nẵng (FIXTURE)" \
		--publisher "Test Fixture — not an official source" \
		--url "fixture://tnhh-vi" --language vi --service "http://127.0.0.1:$(AI_PORT)" || true
	"$(PY)" scripts/ingest_file.py tests/fixtures/foreign-investor-en.txt \
		--title "Guidance for foreign investors in Da Nang (FIXTURE)" \
		--publisher "Test Fixture — not an official source" \
		--url "fixture://foreign-en" --language en --service "http://127.0.0.1:$(AI_PORT)" || true

setup: check submodules env db migrate deps build ## Prepare everything without starting it
	@printf "$(OK)Setup complete.$(OFF) Run: make dev\n"

## ---------------------------------------------------------------------------
## Operating the stack
## ---------------------------------------------------------------------------

stop: ## Stop the three services (Postgres keeps running)
	@for name in ai api web; do
		f="$(PID_DIR)/$$name.pid"
		if [[ -f "$$f" ]]; then
			pid=$$(cat "$$f")
			# Kill the process group: npm and uvicorn both spawn children that
			# would otherwise keep their ports bound.
			kill -- -$$pid 2>/dev/null || kill "$$pid" 2>/dev/null || true
			rm -f "$$f"
		fi
	done
	# Belt and braces — a run interrupted before writing its pidfile leaves a
	# listener behind and the next `make dev` fails to bind. Matched by port so
	# this cannot touch another project's server, and --oldest-first is avoided
	# in favour of exact ports for the same reason.
	for port in $(AI_PORT) $(API_PORT) $(WEB_PORT); do
		pid=$$(ss -ltnp 2>/dev/null | grep -oP ":$$port\s.*pid=\K[0-9]+" | head -1 || true)
		if [[ -n "$${pid:-}" ]]; then kill "$$pid" 2>/dev/null || true; fi
	done
	exit 0

restart: stop dev ## Restart the services

db-stop: ## Stop the Postgres container
	@docker stop $(DB_CONTAINER) >/dev/null 2>&1 || true
	printf "$(OK)stopped$(OFF) $(DB_CONTAINER)\n"

db-reset: ## Destroy and recreate the database, then re-migrate and re-ingest
	@printf "$(WARN)This deletes all ingested knowledge.$(OFF) Ctrl-C within 3s to cancel."
	sleep 3; printf "\n"
	docker rm -f $(DB_CONTAINER) >/dev/null 2>&1 || true
	$(MAKE) -s db migrate
	printf "$(OK)Database reset.$(OFF) Run `make dev` to reload fixtures.\n"

status: ## Show what is currently running
	@printf "$(BOLD)%-12s %-28s %s$(OFF)\n" SERVICE URL STATUS
	if [[ -n "$$(docker ps -q -f name=^/$(DB_CONTAINER)$$)" ]]; then
		s="$(OK)up$(OFF)"; else s="$(ERR)down$(OFF)"; fi
	printf "%-12s %-28s %b\n" postgres "localhost:$(DB_PORT)" "$$s"
	for entry in "ai:127.0.0.1:$(AI_PORT):/health" "api:localhost:$(API_PORT):/api/v1/health" "web:localhost:$(WEB_PORT):/"; do
		name=$${entry%%:*}; rest=$${entry#*:}
		host=$${rest%%:*}; rest=$${rest#*:}
		port=$${rest%%:*}; path=$${rest#*:}
		code=$$(curl -s -o /dev/null -m 5 -w '%{http_code}' "http://$$host:$$port$$path" || true)
		if [[ "$$code" == 200 ]]; then s="$(OK)up$(OFF)"; else s="$(ERR)down ($$code)$(OFF)"; fi
		printf "%-12s %-28s %b\n" "$$name" "$$host:$$port" "$$s"
	done

logs: ## Follow the service logs
	@tail -f "$(LOG_DIR)"/*.log

psql: ## Open a psql shell on the dev database
	@docker exec -it $(DB_CONTAINER) psql -U postgres -d $(DB_NAME)

## ---------------------------------------------------------------------------
## Tests
## ---------------------------------------------------------------------------

test: test-ai test-api ## Run all unit tests

test-ai: ## Python unit tests (no database or API calls needed)
	@printf "$(BOLD)AI service tests$(OFF)\n"
	cd ai && "$(PY)" -m pytest tests -q

test-api: ## Backend unit tests
	@printf "$(BOLD)Backend tests$(OFF)\n"
	cd backend && npm test --silent

eval: ## Run the evaluation harness against the running stack
	@printf "$(BOLD)Evaluation$(OFF) $(DIM)(needs make dev running; takes a few minutes)$(OFF)\n"
	cd ai
	"$(PY)" evaluation/run_eval.py --service "http://127.0.0.1:$(AI_PORT)" \
		--json evaluation/results/latest.json

clean: stop db-stop ## Stop everything and remove logs and pidfiles
	@rm -rf "$(LOG_DIR)" "$(PID_DIR)"
	printf "$(OK)cleaned$(OFF)\n"

## ---------------------------------------------------------------------------

help:
	@printf "$(BOLD)Da Nang BizGuide$(OFF)\n\n"
	printf "  $(BOLD)make dev$(OFF)   start everything and follow the logs\n\n"
	printf "$(BOLD)All targets$(OFF)\n"
	grep -E '^[a-z-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'
	printf "\n$(BOLD)Ports$(OFF) web $(WEB_PORT) · api $(API_PORT) · ai $(AI_PORT) · db $(DB_PORT)\n"
