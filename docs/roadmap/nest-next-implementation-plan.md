# NestJS + Next.js Implementation Plan

This plan assumes the project will use a TypeScript-first stack:

- Frontend: Next.js, React, TypeScript, Tailwind CSS, shadcn/ui
- Backend: NestJS, TypeScript, Prisma, PostgreSQL
- AI/RAG: backend-integrated service first, separate worker process later if needed
- Blockchain: Solidity, Hardhat or Foundry, EVM-compatible testnet/demo network
- Cache/jobs: Redis or Valkey
- Event streaming: Kafka only if the event flow becomes complex

The project uses one repository with separate top-level folders for frontend, backend, contract, and AI work. The backend starts as a modular monolith; it should not be split into microservices during the MVP.

Planned folders:

| Folder      | Purpose                                                |
| ----------- | ------------------------------------------------------ |
| `docs/`     | Documentation, roadmap, architecture, thesis materials |
| `frontend/` | Next.js frontend                                       |
| `backend/`  | NestJS backend API                                     |
| `contract/` | Solidity contracts and deployment scripts              |
| `ai/`       | AI/RAG notes, experiments, ingestion, and evaluation   |

## MVP Target

Build a working Da Nang BizGuide prototype where users can:

- Open the website.
- Ask business establishment questions.
- Receive source-backed answers from approved knowledge.
- View generated business setup checklists.
- See citations and last-verified metadata.
- Verify that an approved knowledge version was registered on an EVM blockchain.
- Allow admins/reviewers to manage official source snapshots and approve knowledge versions.

Recommended MVP duration for one developer: 8 to 12 weeks.

Recommended thesis-ready version duration: 4 to 6 months.

## Phase Summary

| Phase |                                 Area | Estimated Time |
| ----- | -----------------------------------: | -------------: |
| 1     |                        Project setup |       2-3 days |
| 2     |      Database and backend foundation |       4-6 days |
| 3     |                  Frontend foundation |       4-6 days |
| 4     |                       Auth and roles |       4-6 days |
| 5     | Knowledge base and source management |      8-12 days |
| 6     |                   AI chatbot and RAG |      8-14 days |
| 7     |                  Checklist generator |       5-8 days |
| 8     |                  Blockchain registry |      7-12 days |
| 9     |                     Redis jobs/cache |       2-4 days |
| 10    |      Kafka event streaming, optional |       4-7 days |
| 11    |                         Admin portal |      7-10 days |
| 12    |           Testing and quality checks |      6-10 days |
| 13    |                           Deployment |       3-6 days |

## Phase 1: Project Setup

Estimated time: 2-3 days

Detailed guide: [Phase 1 Project Setup Guide](phase-1-project-setup-guide.md)

### Features

- Create top-level implementation folders.
- Document manual Next.js frontend setup.
- Document manual NestJS backend setup.
- Document manual smart contract setup.
- Use OpenAPI/Swagger from the API as the first contract between frontend and backend.
- Document planned ESLint, Prettier, and environment files.
- Document local PostgreSQL and Redis assumptions.
- Add basic README instructions.

### Suggested Structure

```text
da-nang-bizguide/
  docs/
  frontend/
  backend/
  contract/
  ai/
  data/
  materials/
  scripts/
```

### Deliverables

- One GitHub repository exists and is pushed.
- Top-level folders exist for frontend, backend, contract, and AI.
- No framework install/init has been done yet.
- Manual setup instructions are documented.
- Local PostgreSQL and Redis assumptions are documented.
- Tests will be created inside each implementation folder later.

## Phase 2: Database and Backend Foundation

Estimated time: 4-6 days

### Features

- PostgreSQL database.
- Prisma ORM.
- NestJS config module.
- Database migrations.
- Health check endpoint.
- Global validation pipe.
- Global exception filter.
- Standard API response format.
- Swagger/OpenAPI documentation.

### Main Entities

- User
- Role
- SourceDocument
- SourceSnapshot
- KnowledgeChunk
- KnowledgeVersion
- ChecklistTemplate
- ChecklistResult
- BlockchainRegistration
- AuditLog

### Deliverables

- Working database schema.
- Backend API documentation.
- Migration workflow.
- Basic seed data.

## Phase 3: Frontend Foundation

Estimated time: 4-6 days

### Features

- Next.js App Router setup.
- Tailwind CSS and shadcn/ui.
- Main layout.
- Public home page.
- Chat page shell.
- Checklist page shell.
- Verification page shell.
- Admin layout shell.
- API client.
- Loading, empty, and error states.
- Responsive desktop/mobile layout.

### Deliverables

- Usable frontend shell.
- Navigation between main pages.
- API client connected to backend health check.

## Phase 4: Auth and Roles

Estimated time: 4-6 days

### Features

- Email/password login for admin and reviewer users.
- JWT access token.
- Refresh token or session strategy.
- Role-based access control.
- Protected admin routes.
- Backend guards for admin/reviewer APIs.

### Roles

| Role        | Capabilities                                              |
| ----------- | --------------------------------------------------------- |
| Public user | Ask questions, view checklists, verify knowledge versions |
| Reviewer    | Review source snapshots and knowledge versions            |
| Admin       | Manage users, approve versions, publish to blockchain     |

### Deliverables

- Login/logout flow.
- Protected admin dashboard.
- Backend role guards.

## Phase 5: Knowledge Base and Source Management

Estimated time: 8-12 days

### Features

- Add official source document metadata.
- Upload or save source snapshots.
- Store extracted source text.
- Split source text into knowledge chunks.
- Mark chunks as draft, reviewed, approved, archived.
- Track source URL, publisher, access date, and language.
- Track source version history.
- Add reviewer notes.

### Important Rule

Only approved knowledge should be available to the chatbot. Draft or unreviewed content must not be used for trusted answers.

### Deliverables

- Source management API.
- Knowledge chunk management API.
- First approved source snapshot.
- First approved knowledge version.

## Phase 6: AI Chatbot and RAG

Estimated time: 8-14 days

### Features

- Chat endpoint.
- Intent classification for user questions.
- Retrieve approved knowledge chunks.
- Generate answer with citations.
- Include confidence or coverage status.
- Ask follow-up questions when user context is missing.
- Refuse unsupported legal/regulatory claims.
- Return source links and last-verified metadata.

### Chatbot Response Requirements

Every trusted answer should include:

- Direct answer.
- Relevant steps or checklist items.
- Source citations.
- Knowledge version ID.
- Last verified date.
- Blockchain verification status when available.
- Disclaimer that the answer is guidance, not formal legal advice.

### Deliverables

- Working chatbot endpoint.
- Frontend chat UI.
- Citation display.
- Unsupported-question refusal behavior.

## Phase 7: Checklist Generator

Estimated time: 5-8 days

### Features

- Guided questionnaire.
- Business scenario selection.
- Local Vietnamese founder flow.
- Foreign investor flow.
- Company type selection.
- Checklist generation from approved templates.
- Required document list.
- Procedure step list.
- Export or print-friendly view.

### Example Scenarios

- Vietnamese citizen opening a small local company.
- Foreign investor opening a software company.
- Founder comparing LLC and joint stock company.
- User checking required documents before registration.

### Deliverables

- Checklist template schema.
- Checklist API.
- Frontend checklist flow.
- At least one complete demo scenario.

## Phase 8: Blockchain Registry

Estimated time: 7-12 days

### Features

- Solidity `KnowledgeRegistry` contract.
- Register approved knowledge version hash.
- Register source bundle hash.
- Store metadata hash, status, approved timestamp, and approver identifier.
- Verify version hash from backend.
- Emit events for audit history.
- Display verification status in frontend.

### On-Chain Data

- Version ID.
- Content hash.
- Metadata hash.
- Approval timestamp.
- Status.

### Off-Chain Data

- Full legal text.
- Source documents.
- Admin notes.
- User conversations.
- Personal data.

### Deliverables

- Smart contract.
- Contract tests.
- Local deployment script.
- Testnet/demo deployment script.
- Backend blockchain service.
- Verification page.

## Phase 9: Redis or Valkey Jobs and Cache

Estimated time: 2-4 days

### Recommended Free Options

| Provider              | Best Use                                             |
| --------------------- | ---------------------------------------------------- |
| Upstash Redis Free    | Serverless cache, rate limits, small background jobs |
| Aiven Valkey Free     | Redis-compatible managed cache                       |
| Render Key Value Free | Tiny prototypes only                                 |

### Features

- Cache frequently used approved knowledge metadata.
- Cache blockchain verification results.
- Rate limit chatbot endpoints.
- Store short-lived nonces or temporary session data.
- Run background jobs with BullMQ.

### Suggested Jobs

- Source snapshot processing.
- Knowledge chunk generation.
- Blockchain transaction confirmation check.
- RAG index refresh.

### Deliverables

- Redis/Valkey connection.
- Rate limiting.
- Background worker.
- First job queue.

## Phase 10: Kafka Event Streaming

Estimated time: 4-7 days

Kafka is optional for the MVP. Use it only if the project needs stronger event-driven architecture.

### Recommended Free Option

Use Aiven Kafka Free for prototype event streaming. It is suitable for learning, demos, and low-throughput flows.

### Suggested Topics

- `source.snapshot.created`
- `knowledge.version.approved`
- `knowledge.version.registered`
- `blockchain.tx.confirmed`
- `chat.answer.generated`

### Features

- Produce events from backend services.
- Consume events in worker process.
- Persist important events to audit logs.
- Decouple blockchain confirmation from admin approval flow.

### When To Skip Kafka

Skip Kafka if:

- The MVP has only one backend service.
- Event volume is low.
- Redis queues already solve the problem.
- The project timeline is tight.

### Deliverables

- Kafka producer.
- Kafka consumer.
- Topic configuration.
- Event payload types documented in the API contract.

## Phase 11: Admin Portal

Estimated time: 7-10 days

### Features

- Admin dashboard.
- Source document list.
- Source snapshot detail.
- Knowledge chunk review.
- Checklist template editor.
- Approve knowledge version.
- Publish approved version to blockchain.
- View blockchain transaction status.
- User and role management.
- Audit log page.

### Deliverables

- Working admin flow from source upload to blockchain registration.
- Reviewer approval workflow.
- Audit history.

## Phase 12: Testing and Quality Checks

Estimated time: 6-10 days

### Backend Tests

- Auth and role guards.
- Source document APIs.
- Knowledge version approval.
- Chatbot refusal rules.
- Blockchain verification service.
- Redis job handling.

### Frontend Tests

- Public navigation.
- Chat loading/error states.
- Citation rendering.
- Checklist generation.
- Admin approval workflow.
- Verification page.

### Smart Contract Tests

- Register version.
- Prevent invalid updates.
- Verify correct hash.
- Reject wrong hash.
- Emit expected events.

### Deliverables

- Unit tests.
- Integration tests.
- Contract tests.
- Basic Playwright flow.

## Phase 13: Deployment

Estimated time: 3-6 days

### Free or Low-Cost Deployment Plan

| Component      | Free/Low-Cost Option                                           |
| -------------- | -------------------------------------------------------------- |
| Frontend       | Vercel Free                                                    |
| Backend        | Render Free, Railway trial, Fly.io free allowance if available |
| PostgreSQL     | Supabase Free, Neon Free, Aiven Free                           |
| Redis/Valkey   | Upstash Redis Free or Aiven Valkey Free                        |
| Kafka          | Aiven Kafka Free, optional                                     |
| EVM RPC        | Alchemy, Infura, QuickNode free tier                           |
| Smart contract | Sepolia or low-cost EVM-compatible demo network                |

### Deployment Features

- Production environment variables.
- Database migration command.
- CORS configuration.
- Health check route.
- Basic logging.
- Error monitoring.
- Contract address configuration.
- RPC key configuration.

### Deliverables

- Public frontend URL.
- Public backend API URL.
- Deployed database.
- Deployed Redis/Valkey.
- Optional Kafka service.
- Deployed smart contract.
- Deployment guide.

## Suggested MVP Build Order

1. Project setup.
2. Database and backend foundation.
3. Frontend foundation.
4. Auth and admin roles.
5. Knowledge base source management.
6. Basic chatbot with approved knowledge retrieval.
7. Checklist generator.
8. Blockchain registry.
9. Verification page.
10. Redis cache/jobs.
11. Deployment.
12. Tests and polish.

Kafka should be added after the MVP unless the project explicitly needs event streaming for evaluation.

## Practical Feature Priorities

### Must Have

- Public website.
- Chatbot with citations.
- Approved knowledge base.
- Admin/reviewer approval workflow.
- Checklist generation.
- Blockchain hash registration.
- Verification page.
- Basic deployment.

### Should Have

- Redis cache.
- Background jobs.
- Bilingual Vietnamese and English UI.
- Audit logs.
- Playwright smoke tests.

### Nice To Have

- Kafka event streaming.
- Automatic official-source monitoring.
- Advanced analytics.
- Expert handoff flow.
- Multi-network blockchain comparison.

## Risk Notes

- Legal/regulatory content must be manually verified before being treated as trusted.
- Blockchain should store hashes and metadata only, not full documents or personal data.
- Kafka can slow the MVP if added too early.
- Free hosting tiers can sleep, throttle, or provide no SLA.
- RAG quality depends more on clean approved source data than on the model alone.

## Definition of Done For MVP

The MVP is complete when:

- A public user can ask a question and receive a cited answer from approved knowledge.
- A public user can generate one complete business setup checklist.
- An admin can create, review, approve, and publish a knowledge version.
- The approved knowledge version hash is registered on an EVM testnet or demo network.
- The frontend can verify and display the blockchain proof status.
- The app is deployed with frontend, backend, database, and Redis/Valkey.
- Core flows have basic automated tests.
