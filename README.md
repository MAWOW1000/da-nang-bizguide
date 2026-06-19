# Da Nang BizGuide

Working title: Da Nang BizGuide: AI and Blockchain-Based Regulatory Guidance Platform for Business Establishment in Da Nang City

This repository is the master project workspace for designing, building, documenting, and evaluating a website that helps entrepreneurs and investors understand how to open a company in Da Nang, Vietnam.

The system will combine:

- A public website for business setup guidance.
- An AI chatbot that answers questions using verified official sources.
- A regulatory knowledge base with citations, version control, and human review.
- A blockchain registry for proving the integrity and history of important information.
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

## Repository Structure

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
|   |-- frontend/
|   |-- backend/
|   |-- ai/
|   `-- blockchain/
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

Da Nang BizGuide will act as a trusted digital assistant for people who want to start a business in Da Nang but do not understand the procedures, documents, and regulatory steps.

The chatbot should answer questions such as:

- "I am a foreign investor. What steps do I need to open a software company in Da Nang?"
- "Should I register a limited liability company or a joint stock company?"
- "What documents should I prepare before submitting a business registration application?"
- "Which official portal should I use?"
- "Has this checklist changed recently?"

The blockchain layer will not store private files or full legal text. Instead, it will store hashes and metadata that prove a regulation snapshot, checklist, chatbot answer package, or admin approval existed in a specific version at a specific time.

## Next Decisions

- Confirm the final project title.
- Choose the first target user group: local Vietnamese founders, foreign investors, or both.
- Choose prototype technology: EVM smart contracts for speed, or Hyperledger Fabric for a more government-style permissioned model.
- Decide whether the first version supports English only, Vietnamese only, or bilingual Vietnamese and English.

