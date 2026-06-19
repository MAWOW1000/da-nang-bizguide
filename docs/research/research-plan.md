# Research Plan

## Research Direction

The project studies how AI and EVM blockchain can be combined to create a trusted regulatory guidance platform for business establishment in Da Nang.

The focus is not only implementation. The research should evaluate whether the architecture improves:

- Information accessibility.
- Answer accuracy.
- Source traceability.
- User trust.
- Integrity verification.

## Main Research Question

How can an AI chatbot with EVM blockchain-based knowledge provenance support trustworthy business establishment guidance for local entrepreneurs and foreign investors in Da Nang?

## Sub-Questions

- What information do local Vietnamese entrepreneurs and foreign investors need most when opening a company in Da Nang?
- How should regulatory knowledge be collected, structured, reviewed, and versioned?
- How can RAG reduce unsupported chatbot answers in a legal/regulatory domain?
- What information should be stored on an EVM-compatible blockchain and what should stay off-chain?
- How can users verify that guidance came from an approved knowledge version?
- How effective is the prototype in usability, accuracy, and trust?

## Proposed Methodology

1. Domain research

Collect official sources and identify common business establishment procedures, user questions, agencies, and documents.

2. Requirement analysis

Define user personas, functional requirements, non-functional requirements, and system constraints.

3. System design

Design the web platform, chatbot/RAG pipeline, knowledge base, admin workflow, and blockchain registry.

4. Prototype implementation

Build a working prototype with a limited but high-quality knowledge base.

5. Evaluation

Evaluate the system using chatbot answer tests, user tasks, usability survey, and blockchain verification tests.

6. Thesis writing

Document background, design, implementation, results, limitations, and future work.

## Evaluation Plan

Answer accuracy:

- Prepare a set of common business registration questions.
- Compare chatbot answers against approved source-based reference answers.
- Measure correctness, completeness, citation quality, and unsupported claims.

Usability:

- Ask test users to complete tasks such as finding required documents or generating a checklist.
- Measure task completion, time, error rate, and satisfaction.

Trust:

- Ask users whether source citations and blockchain verification increase confidence.
- Compare answers with and without verification information.

Blockchain verification:

- Test that approved knowledge hashes match on-chain records.
- Test that modified off-chain content fails verification.
- Test version status changes and historical lookup.

Performance:

- Measure response time for chatbot answers.
- Measure vector retrieval latency.
- Measure smart contract transaction and verification behavior.

## Suggested Thesis Chapters

1. Introduction
2. Background and Related Work
3. Problem Analysis and Requirements
4. System Design and Architecture
5. Implementation
6. Evaluation and Results
7. Discussion, Limitations, and Future Work
8. Conclusion

## Risks and Mitigation

Legal accuracy risk:

- Use only approved knowledge sources.
- Show citations and last-verified dates.
- Add clear guidance disclaimer.

AI hallucination risk:

- Use retrieval-grounded prompting.
- Refuse unsupported answers.
- Evaluate with controlled question sets.

Blockchain overuse risk:

- Store only hashes and proof metadata on-chain.
- Keep full documents off-chain.

Data privacy risk:

- Avoid collecting unnecessary personal data.
- Never store identity documents on-chain.

Scope risk:

- Start with a small set of high-value procedures and expand gradually.
