# Da Nang BizGuide

Final title: Da Nang BizGuide: A Trusted AI and EVM Blockchain Platform for Business Establishment Guidance in Da Nang City

This repository is the single project workspace for designing, building, documenting, and evaluating a website that helps both local Vietnamese entrepreneurs and foreign investors understand how to open a company in Da Nang, Vietnam.

The system will combine:

- A public website for business setup guidance.
- A NestJS backend API for users, knowledge, chatbot orchestration, checklist logic, and blockchain integration.
- An AI chatbot that answers questions using verified official sources.
- A regulatory knowledge base with citations, version control, and human review.
- An EVM-compatible blockchain registry for proving the integrity and history of important information.
- Admin tools for updating and approving legal/regulatory knowledge.

Important note: this project should provide guidance and source-backed explanations, not formal legal advice. All legal content must be verified against official sources before being shown as trusted information.

## Current Stage

Project planning and folder organization.

Implementation folders are intentionally empty placeholders. Framework setup will be done manually later.

## Repository Structure

```text
.
|-- docs/
|   |-- architecture/
|   |-- requirements/
|   |-- roadmap/
|   `-- research/
|-- frontend/
|   `-- README.md
|-- backend/
|   `-- README.md
|-- contract/
|   `-- README.md
|-- ai/
|   `-- README.md
|-- data/
|   |-- raw-official-sources/
|   `-- knowledge-base/
|-- materials/
|   `-- images/
`-- scripts/
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

- `frontend/`: Next.js frontend will be initialized here manually.
- `backend/`: NestJS backend API will be initialized here manually.
- `contract/`: Solidity smart contract project will be initialized here manually.
- `ai/`: AI/RAG experiments, prompts, evaluation scripts, and ingestion notes will live here.
- `docs/`: thesis, architecture, requirements, roadmap, and planning documents.

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

- Use one GitHub repository for the whole project.
- Keep implementation in top-level folders: `frontend/`, `backend/`, `contract/`, and `ai/`.
- Use EVM for the prototype because it is popular, mature, well-supported, and easy to demonstrate.
- Use local PostgreSQL and Redis during development because they are already installed.
- Deploy to low-cost/free services later.
- Documentation language: English.
- Product language direction: bilingual Vietnamese and English support.
