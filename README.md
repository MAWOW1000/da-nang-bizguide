# Da Nang BizGuide

Final title: Da Nang BizGuide: A Trusted AI and EVM Blockchain Platform for Business Establishment Guidance in Da Nang City

This repository is the parent workspace for designing, building, documenting, and evaluating a website that helps both local Vietnamese entrepreneurs and foreign investors understand how to open a company in Da Nang, Vietnam.

The system will combine:

- A public website for business setup guidance.
- A NestJS backend API for users, knowledge, chatbot orchestration, checklist logic, and blockchain integration.
- An AI chatbot that answers questions using verified official sources.
- A regulatory knowledge base with citations, version control, and human review.
- An EVM-compatible blockchain registry for proving the integrity and history of important information.
- Admin tools for updating and approving legal/regulatory knowledge.

Important note: this project should provide guidance and source-backed explanations, not formal legal advice. All legal content must be verified against official sources before being shown as trusted information.

## Current Stage

Project planning and workspace organization.

Each main project folder is its own Git repository and is attached to this workspace as a Git submodule. Framework setup will be done manually later inside the relevant folder repo.

## Repository Structure

```text
.
|-- docs/
|   `-- ...
|-- frontend/
|   `-- ...
|-- backend/
|   `-- ...
|-- contract/
|   `-- ...
|-- ai/
|   `-- ...
|-- data/
|   `-- ...
`-- README.md
```

## Workspace Repositories

| Folder      | GitHub Repository                                             |
| ----------- | ------------------------------------------------------------- |
| `docs/`     | `git@github-personal:MAWOW1000/da-nang-bizguide-docs.git`     |
| `frontend/` | `git@github-personal:MAWOW1000/da-nang-bizguide-frontend.git` |
| `backend/`  | `git@github-personal:MAWOW1000/da-nang-bizguide-backend.git`  |
| `contract/` | `git@github-personal:MAWOW1000/da-nang-bizguide-contract.git` |
| `ai/`       | `git@github-personal:MAWOW1000/da-nang-bizguide-ai.git`       |
| `data/`     | `git@github-personal:MAWOW1000/da-nang-bizguide-data.git`     |
| Workspace   | `git@github-personal:MAWOW1000/da-nang-bizguide.git`          |

Clone the full workspace with:

```bash
git clone --recurse-submodules git@github-personal:MAWOW1000/da-nang-bizguide.git
```

If the workspace is already cloned:

```bash
git submodule update --init --recursive
```

## Planned Stack

| Area       | Planned Technology                               |
| ---------- | ------------------------------------------------ |
| Frontend   | Next.js, React, TypeScript, Tailwind CSS         |
| Backend    | NestJS, TypeScript, Prisma, PostgreSQL           |
| AI/RAG     | Approved-source retrieval, embeddings, LLM API   |
| Blockchain | Solidity, Hardhat or Foundry, EVM test network   |
| Cache/Jobs | Local Redis first, managed Redis/Valkey later    |
| Database   | Local PostgreSQL first, managed PostgreSQL later |

## Implementation Folders

- `frontend/`: Next.js frontend repo, initialized manually later.
- `backend/`: NestJS backend API repo, initialized manually later.
- `contract/`: Solidity smart contract repo, initialized manually later.
- `ai/`: AI/RAG experiments, prompts, evaluation scripts, and ingestion notes.
- `docs/`: thesis, architecture, requirements, roadmap, and planning documents.
- `data/`: source snapshots and knowledge-base data.

Each implementation folder will own its own tests after setup. Do not keep a shared root `tests/` folder.

## Important Docs

- [Project Brief](docs/00-project-brief.md)
- [Brainstorming Notes](docs/01-brainstorming.md)
- [System Requirements](docs/requirements/system-requirements.md)
- [Architecture V1](docs/architecture/architecture-v1.md)
- [One-Year Roadmap](docs/roadmap/one-year-roadmap.md)
- [Implementation Plan](docs/roadmap/nest-next-implementation-plan.md)
- [Phase 1 Setup Guide](docs/roadmap/phase-1-project-setup-guide.md)

## Proposed Product Idea

Da Nang BizGuide will act as a trusted digital assistant for local Vietnamese founders and foreign investors who want to start a business in Da Nang but do not understand the procedures, documents, and regulatory steps.

The chatbot should answer questions such as:

- "I am a foreign investor. What steps do I need to open a software company in Da Nang?"
- "Should I register a limited liability company or a joint stock company?"
- "What documents should I prepare before submitting a business registration application?"
- "Which official portal should I use?"
- "Has this checklist changed recently?"

The blockchain layer will not store private files or full legal text. Instead, it will store hashes and metadata that prove a regulation snapshot, checklist, chatbot answer package, or admin approval existed in a specific version at a specific time.

## Confirmed Direction

- Use a parent workspace GitHub repository with folder repos attached as submodules.
- Keep implementation in top-level folder repos: `frontend/`, `backend/`, `contract/`, and `ai/`.
- Use EVM for the prototype because it is popular, mature, well-supported, and easy to demonstrate.
- Use local PostgreSQL and Redis during development because they are already installed.
- Deploy to low-cost/free services later.
- Documentation language: English.
- Product language direction: bilingual Vietnamese and English support.
