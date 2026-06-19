# Five-Section Project Draft

## 1. Title

**Da Nang BizGuide: A Trusted AI Regulatory Navigator with EVM Blockchain-Based Knowledge Provenance for Business Establishment in Da Nang City**

Short name: **Da Nang BizGuide**

Meaning:

- **Biz** means business.
- **Guide** means a tool that helps users understand steps and make decisions.
- **Da Nang BizGuide** means a guidance platform for people who want to establish a company in Da Nang.

Main keywords:

- AI chatbot
- Retrieval-Augmented Generation (RAG)
- Regulatory technology
- Business establishment
- Da Nang
- EVM blockchain
- Knowledge provenance
- Smart contract
- E-government

## 2. Details / Problem Description

Da Nang is developing as a city for innovation, startups, digital economy, and investment. Local Vietnamese entrepreneurs and foreign investors may want to establish companies in Da Nang, but they often face difficulty understanding the correct procedures, documents, agencies, official portals, and legal requirements.

Business establishment is not a simple one-step process. Depending on the user scenario, it may involve enterprise registration, investment registration for foreign investors, tax registration, post-registration obligations, business lines, official forms, and updated legal documents. This information is distributed across many official sources and is often written in formal administrative or legal language.

The problem becomes more serious when users rely on normal AI chatbots. A normal chatbot may produce confident but unsupported answers. In a legal and regulatory context, this can lead to wrong document preparation, misunderstanding of obligations, wasted time, or reduced trust in digital public services.

This project focuses on two main user groups:

- Local Vietnamese entrepreneurs who want to open a company in Da Nang.
- Foreign investors who want to establish a company in Da Nang.

The key user problems are:

- Users do not know where to start.
- Users do not know which procedure applies to their case.
- Official information is spread across different portals and documents.
- Legal language is difficult for non-experts.
- Regulations and procedures may change over time.
- AI answers may hallucinate if they are not based on official sources.
- Users need to know which sources support the chatbot answer.

The proposed solution is a website with an AI chatbot and checklist system. The chatbot will not answer only from model memory. It will use official documents and reviewed knowledge through RAG, so answers can include citations, source links, and last-verified information.

Blockchain is used in a narrow and practical way. It is not used because government websites are untrusted. In a government environment, official portals already provide strong institutional trust. Instead, EVM blockchain is used as an optional audit and transparency layer for the AI system. It records hashes of approved knowledge versions, source snapshots, and approval metadata. This helps prove which reviewed knowledge version was used by the chatbot and whether that version still matches the approved record.

Core problem statement:

**There is a need for a trusted AI-based platform that helps local entrepreneurs and foreign investors understand business establishment procedures in Da Nang using official-source-backed guidance, while providing verifiable provenance for the regulatory knowledge used by the chatbot.**

Preliminary official source candidates:

- Da Nang official portal: https://www.danang.gov.vn/
- National Business Registration Portal: https://dangkykinhdoanh.gov.vn/
- National Public Service Portal: https://dichvucong.gov.vn/
- National Legal Document Database: https://vbpl.vn/
- Da Nang investment/startup support sources

## 3. Objective

General objective:

**To design and implement a trusted AI regulatory guidance platform that helps local Vietnamese entrepreneurs and foreign investors understand business establishment procedures in Da Nang City through official-source-backed answers and EVM blockchain-based knowledge provenance.**

Specific objectives:

1. Build a user-friendly website for business establishment guidance in Da Nang.
2. Develop an AI chatbot that answers questions using official-source-based RAG.
3. Create a structured knowledge base for procedures, source documents, checklists, business scenarios, and version metadata.
4. Provide checklist guidance for local-founder and foreign-investor scenarios.
5. Add a reviewer/admin workflow for approving important regulatory knowledge.
6. Implement an EVM smart contract registry for approved knowledge version hashes and source snapshot hashes.
7. Provide a verification page showing the knowledge version, source references, and blockchain proof.
8. Evaluate the system using chatbot accuracy, citation quality, usability, user trust, and hash verification tests.

Research questions:

1. How can AI help users understand business establishment procedures in Da Nang?
2. How can official-source-based RAG reduce hallucination in regulatory guidance?
3. How can EVM blockchain provide knowledge provenance for AI-generated regulatory answers?
4. How effective is the prototype for local Vietnamese entrepreneurs and foreign investors?

Expected contribution:

- A practical architecture for trusted AI regulatory guidance.
- A chatbot that answers with official-source citations.
- A checklist system for company establishment in Da Nang.
- A blockchain-based proof layer for approved knowledge versions.
- A prototype that can be evaluated through measurable tests.

Initial evaluation targets:

- At least 90% of tested chatbot answers include relevant official citations.
- Unsupported legal claims stay below 5% in the test question set.
- Users complete common guidance tasks faster than manual search in a small user test.
- Blockchain verification detects changed approved knowledge through hash mismatch.

## 4. Tech Used

Recommended technology stack:

| Layer | Technology | Purpose |
| --- | --- | --- |
| Frontend | Next.js, React, TypeScript, Tailwind CSS | Website, chatbot UI, checklist UI, verification page |
| Backend | Python FastAPI | APIs, chatbot orchestration, business logic |
| Database | PostgreSQL | Users, sources, checklists, review workflow, metadata |
| Vector Search | pgvector or Qdrant | Retrieve official-source chunks for chatbot answers |
| AI / Chatbot | RAG pipeline, embeddings, LLM API or local LLM | Source-grounded question answering |
| Blockchain | Solidity, Hardhat, OpenZeppelin, Ethers.js | EVM smart contract development |
| Deployment Network | Low-cost EVM-compatible network or Layer 2 | Reduce deployment and transaction cost |
| Storage | Local storage, S3-compatible storage, MinIO, or IPFS | Store source snapshots off-chain |
| Testing | Pytest, Playwright, Hardhat tests | Backend, UI, and smart contract testing |

Why AI is used:

- Users can ask questions in natural language.
- The system can explain complex procedures in simpler steps.
- The chatbot can generate scenario-based guidance.
- The system can summarize official-source information.

Why RAG is used:

- The chatbot retrieves approved official-source content before answering.
- Answers can include citations and last-verified information.
- The risk of hallucination is reduced.

Why EVM blockchain is used:

- EVM is popular, mature, and easy to demonstrate.
- Solidity and Hardhat provide strong development tools.
- Smart contracts can record proof metadata for approved knowledge versions.
- Deployment can use a low-cost EVM-compatible network instead of Ethereum mainnet.

Blockchain stores only proof metadata:

- Approved knowledge version hash.
- Source snapshot hash.
- Approval metadata hash.
- Version ID.
- Timestamp.
- Status.

Blockchain does not store:

- Full legal documents.
- User identity documents.
- Private chatbot conversations.
- Passport, ID card, or business files.
- Passwords, emails, or personal data.

## 5. Architecture

High-level architecture:

```mermaid
flowchart TD
    U[Local Entrepreneur / Foreign Investor] --> FE[Web Frontend]
    FE --> API[Backend API]
    API --> CHAT[AI Chatbot Service]
    CHAT --> RAG[RAG Retrieval]
    RAG --> VDB[(Vector Database)]
    RAG --> KB[Verified Knowledge Base]
    API --> DB[(PostgreSQL)]
    API --> BC[EVM Smart Contract Registry]
    ADMIN[Admin / Reviewer] --> API
    ADMIN --> KB
    KB --> STORAGE[Off-chain Source Snapshot Storage]
    FE --> VERIFY[Verification Page]
    VERIFY --> BC
```

Main components:

- **Web frontend**: chatbot, checklist, source citation display, verification page.
- **Backend API**: user session logic, chatbot orchestration, checklist generation, blockchain integration.
- **AI chatbot service**: retrieves official-source content, generates cited answers, refuses unsupported claims.
- **Knowledge base**: stores official sources, extracted chunks, checklists, scenarios, version metadata, and review status.
- **Admin/reviewer portal**: adds sources, reviews knowledge, approves versions.
- **EVM smart contract registry**: stores hashes and proof metadata for approved knowledge versions.
- **Off-chain storage**: stores official source snapshots and documents outside blockchain.

Chatbot answer flow:

1. User asks a question.
2. Backend identifies the user scenario.
3. RAG retrieves approved official-source chunks.
4. AI generates an answer using retrieved content.
5. Answer shows citations and last-verified date.
6. System checks the knowledge version against the blockchain registry.
7. User sees the answer, sources, and verification status.

Knowledge update flow:

1. Admin adds or updates an official source.
2. System stores the source snapshot off-chain.
3. Reviewer checks and approves the extracted knowledge.
4. System creates an approved knowledge version.
5. System calculates the version hash.
6. Smart contract stores the hash and metadata hash.
7. Verification page confirms whether the displayed knowledge matches the approved version.

Suggested smart contract:

`KnowledgeRegistry`

Main functions:

- `registerVersion(versionId, contentHash, metadataHash)`
- `updateVersionStatus(versionId, status)`
- `getVersion(versionId)`
- `verifyVersion(versionId, contentHash, metadataHash)`

The architecture keeps the main system practical: the database stores real content, RAG supports AI answers, and blockchain only verifies important approved knowledge versions.
