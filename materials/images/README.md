# Images and Project Materials

Store whiteboard photos, diagrams, screenshots, presentation images, and demo images here.

## System Context Diagram

**Image 1: System Context Diagram** - This diagram illustrates the high-level architecture of the Da Nang BizGuide platform, showing how different actors interact with the system and its integration with external services.

### Components Overview

**Actors:**

- **Admin / Reviewer**: Responsible for knowledge approval, managing users, sources, and approvals. Receives reports and audit statistics from the system.
- **Guest**: Can view public guidance and general information without authentication.
- **User**: Local founders and foreign investors who can submit scenarios, questions, and checklist requests. Receives guidance, citations, and verification status in return.

**Core System:**

- **Da Nang BizGuide**: The central platform that orchestrates all interactions between users, external data sources, blockchain, and AI services. It handles:
  - User authentication and authorization
  - Content retrieval and validation
  - Blockchain hash registration and verification
  - AI-powered query processing
  - Public information display

**Third-Party Services:**

- **Official Sources**: External repositories including business registration databases, public service portals, legal databases, and Da Nang government portals. Provides official documents and procedures that are snapshotted with metadata.
- **EVM Blockchain**: Acts as a knowledge hash registry for ensuring data integrity and provenance. Handles hash registration and verification, returning receipts and verification results.
- **AI / LLM Service**: Provides intelligent answer generation based on retrieved context. Receives prompts with context and generates draft answers for user queries.

### Data Flow

1. Users submit queries through the platform
2. BizGuide retrieves relevant official documents and procedures
3. Source snapshots and metadata are requested from official sources
4. Document hashes are registered on the blockchain for verification
5. Retrieved context is sent to the AI/LLM service for answer generation
6. Final guidance with citations and verification status is returned to users
7. Admin/reviewers monitor and audit the entire process

This architecture ensures transparency, traceability, and trustworthiness of business guidance provided to users by leveraging blockchain for verification and AI for intelligent responses.

---

## Original Images

Current original images are still in the repository root:

- `549a36ca231da243fb0c4.jpg`
- `ae23817394a415fa4cb52.jpg`

They can be moved here later if you want the repository root to stay clean.
