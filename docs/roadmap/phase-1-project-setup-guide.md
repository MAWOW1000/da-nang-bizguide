# Phase 1: Manual Project Setup Guide

This guide expands Phase 1 of the NestJS + Next.js implementation plan.

Goal: keep one GitHub repository and prepare clear folders where the frontend, backend, smart contract, and AI/RAG work can be initialized manually later.

Estimated time: 1-2 days for folder setup and documentation. Framework installation will be done later by the developer.

## Step 1: Confirm Local Tools

### What to do

Confirm these tools are available:

```bash
node --version
pnpm --version
psql --version
redis-cli --version
git --version
gh auth status
```

### Why

The project will use TypeScript across frontend, backend, and blockchain tooling. PostgreSQL and Redis are already installed locally, so Docker is not needed for Phase 1.

## Step 2: Use One Repository

### What to do

Keep all project work in:

```text
da-nang-bizguide/
```

Do not create separate GitHub repositories for frontend, backend, or contracts.

### Why

One repository is easier for a master project because documentation, implementation, evaluation, and deployment notes stay together. It also avoids cross-repo coordination while the system is still being designed.

## Step 3: Use This Folder Structure

### What to do

Use these top-level folders:

```text
docs/
frontend/
backend/
contract/
ai/
data/
materials/
scripts/
tests/
```

### Why

Each major concern has a clear home:

- `docs/`: thesis docs, architecture, requirements, roadmap.
- `frontend/`: Next.js app, initialized manually later.
- `backend/`: NestJS API, initialized manually later.
- `contract/`: Solidity project, initialized manually later.
- `ai/`: prompts, RAG notes, ingestion scripts, evaluation scripts.
- `data/`: local source snapshots and knowledge-base samples.

## Step 4: Keep Implementation Folders Empty First

### What to do

Do not install or initialize frameworks yet. Keep only placeholder README files in:

```text
frontend/
backend/
contract/
ai/
```

### Why

This lets the project structure settle before dependencies and generated framework files are added. It also gives the developer control over every setup command later.

## Step 5: Configure Local Database Assumptions

### What to do

Use local PostgreSQL and Redis:

```bash
createdb bizguide
redis-cli ping
```

Planned backend env values:

```bash
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/bizguide
REDIS_URL=redis://localhost:6379
```

Update the database username/password later if your local PostgreSQL config is different.

### Why

PostgreSQL will store users, sources, knowledge versions, checklist templates, and audit logs. Redis will be used later for cache, rate limiting, and background jobs.

## Step 6: Manual Frontend Setup Later

### What to do later

Inside `frontend/`, manually initialize:

```bash
pnpm create next-app@latest .
```

Recommended choices:

```text
TypeScript: Yes
ESLint: Yes
Tailwind CSS: Yes
src/ directory: Yes
App Router: Yes
Import alias: Yes
```

### Why

Next.js gives React plus routing, production build tooling, and deployment support. It is a good fit for chatbot UI, checklist UI, admin pages, and verification pages.

## Step 7: Manual Backend Setup Later

### What to do later

Inside `backend/`, manually initialize:

```bash
pnpm dlx @nestjs/cli new . --package-manager pnpm --strict
```

Planned modules:

```text
auth/
users/
sources/
knowledge/
chatbot/
checklist/
blockchain/
admin/
```

### Why

NestJS gives a clean modular backend structure. The backend should begin as a modular monolith, not separate microservices.

## Step 8: Manual Contract Setup Later

### What to do later

Inside `contract/`, manually initialize either Hardhat or Foundry.

Recommended first contract:

```text
KnowledgeRegistry
```

It should store only:

- knowledge version ID
- content hash
- metadata hash
- approver
- approval timestamp
- status

### Why

The blockchain layer is for provenance and verification, not for storing private data or full legal text.

## Step 9: Manual AI Folder Setup Later

### What to do later

Use `ai/` for:

- RAG experiment notes.
- prompt templates.
- source ingestion scripts.
- chatbot evaluation question sets.
- retrieval quality reports.

### Why

AI work changes quickly during research. Keeping it separate from the backend at first makes experimentation easier.

## Step 10: Push One GitHub Repo

### What to do

Use the existing GitHub repository:

```bash
git remote -v
git push
```

Remote should be:

```text
git@github-personal:MAWOW1000/da-nang-bizguide.git
```

### Why

One GitHub repository is enough now. Separate deployment can still happen later from subfolders if needed.

## Phase 1 Definition of Done

Phase 1 is complete when:

- The project uses one GitHub repository.
- Top-level folders exist: `docs/`, `frontend/`, `backend/`, `contract/`, `ai/`.
- The old `src/` placeholder structure is removed.
- No framework has been installed or initialized yet.
- Local PostgreSQL and Redis assumptions are documented.
- Phase 1 documentation explains manual setup steps for later.

## References

- Next.js installation: https://nextjs.org/docs/app/getting-started/installation
- NestJS first steps: https://docs.nestjs.com/first-steps
- NestJS CLI: https://docs.nestjs.com/cli/overview
