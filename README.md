# Da Nang BizGuide

Final title: Da Nang BizGuide: A Trusted AI and EVM Blockchain Platform for Business Establishment Guidance in Da Nang City

This repository is the master project workspace for designing, building, documenting, and evaluating a website that helps both local Vietnamese entrepreneurs and foreign investors understand how to open a company in Da Nang, Vietnam.

The system will combine:

- A public website for business setup guidance.
- An AI chatbot that answers questions using verified official sources.
- A regulatory knowledge base with citations, version control, and human review.
- An EVM-compatible blockchain registry for proving the integrity and history of important information.
- Admin tools for updating and approving legal/regulatory knowledge.

Important note: this project should provide guidance and source-backed explanations, not formal legal advice. All legal content must be verified against official sources before being shown as trusted information.

## Current Stage

Initial project definition and documentation structure.

The first required sections from the whiteboard/photo are drafted in:

- [Project Brief](docs/00-project-brief.md)
- [Brainstorming Notes](docs/01-brainstorming.md)
- [System Requirements](docs/requirements/system-requirements.md)
- [Architecture V1](docs/architecture/architecture-v1.md)
- [Research Plan](docs/research/research-plan.md)
- [One-Year Roadmap](docs/roadmap/one-year-roadmap.md)
- [Official Source Candidates](docs/sources/official-sources.md)

## Repository Strategy

This repository is the documentation, planning, research, and architecture repository for Da Nang BizGuide. Deployable applications are split into separate repositories so each service can use a free hosting platform with its own build and deployment settings.

Planned GitHub repositories:

| Repository                   | Purpose                                                                                 | Deployment Target                           |
| ---------------------------- | --------------------------------------------------------------------------------------- | ------------------------------------------- |
| `da-nang-bizguide`           | Documentation, thesis materials, roadmap, architecture, diagrams                        | No app deployment                           |
| `da-nang-bizguide-frontend`  | Next.js public website, chatbot UI, checklist UI, admin UI                              | Vercel Free                                 |
| `da-nang-bizguide-api`       | NestJS backend API, auth, knowledge base, chatbot orchestration, blockchain integration | Render/Railway/Fly free or low-cost service |
| `da-nang-bizguide-contracts` | Solidity smart contracts and deployment scripts                                         | EVM testnet/demo network                    |
| `da-nang-bizguide-worker`    | Optional later background worker for indexing, queues, blockchain event processing      | Free worker service if needed               |

The backend should start as a modular monolith, not as many microservices. Separate repositories are used for deployment simplicity, while the API code should still be organized by modules such as auth, sources, knowledge, chatbot, checklist, blockchain, and admin.

## Documentation Repository Structure

```text
.
|-- docs/
|   |-- 00-project-brief.md
|   |-- 01-brainstorming.md
|   |-- architecture/
|   |-- requirements/
|   |-- research/
|   |-- roadmap/
|   `-- sources/
|-- src/
|   `-- README.md
|-- data/
|   |-- raw-official-sources/
|   `-- knowledge-base/
|-- materials/
|   `-- images/
|-- research/
|   `-- literature/
|-- scripts/
`-- tests/
```

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

- Final title: Da Nang BizGuide: A Trusted AI and EVM Blockchain Platform for Business Establishment Guidance in Da Nang City.
- Target users: both local Vietnamese entrepreneurs and foreign investors.
- Blockchain direction: use EVM for the prototype because it is popular, mature, well-supported, and easy to demonstrate.
- Deployment direction: deploy to a lower-cost EVM-compatible network or Layer 2 instead of Ethereum mainnet.
- Documentation language: English.
- Product language direction: bilingual Vietnamese and English support, with English project documentation.
