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
