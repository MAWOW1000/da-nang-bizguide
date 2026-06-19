# System Requirements

## User Roles

Public user:

- Uses the website.
- Asks chatbot questions.
- Generates a checklist.
- Views official source citations and blockchain verification.
- Can be either a local Vietnamese entrepreneur or a foreign investor.

Registered user:

- Saves checklists.
- Saves conversation history.
- Receives reminders about required steps.

Reviewer:

- Reviews source documents.
- Approves extracted knowledge.
- Adds notes and corrections.

Admin:

- Manages users and roles.
- Publishes approved knowledge versions.
- Registers version hashes on blockchain.

## Functional Requirements

### Public Website

- The system shall provide an introduction to business setup support in Da Nang.
- The system shall allow users to start from common scenarios.
- The system shall support both local founder and foreign investor scenarios.
- The system shall provide a chatbot interface.
- The system shall display source citations in chatbot answers.
- The system shall display last-verified dates for trusted content.
- The system shall show a verification result for approved knowledge versions.

### Guided Questionnaire

- The system shall ask the user about nationality, business type, industry, number of founders, and investment context.
- The system shall use the answers to recommend a relevant checklist.
- The system shall allow the user to change answers and regenerate the checklist.

### Chatbot

- The chatbot shall retrieve answers from approved knowledge base content.
- The chatbot shall cite source documents where possible.
- The chatbot shall ask follow-up questions when the user request is unclear.
- The chatbot shall refuse to provide unsupported legal conclusions.
- The chatbot shall separate general guidance from official legal advice.

### Knowledge Base

- The system shall store source documents and metadata.
- The system shall store structured procedures and checklist templates.
- The system shall version every approved knowledge release.
- The system shall maintain review status for each item.
- The system shall support archiving outdated knowledge.

### Admin / Reviewer Workflow

- Reviewers shall be able to add, edit, and approve knowledge items.
- Admins shall be able to publish approved versions.
- The system shall compute a content hash for each approved version.
- The system shall register approved version hashes on blockchain.
- The system shall store blockchain transaction ids for verification.

### EVM Blockchain Verification

- The system shall verify whether a knowledge version hash matches the on-chain record.
- The system shall show verification status to users.
- The system shall preserve historical version records.
- The prototype shall use EVM-compatible smart contracts.
- The deployment target should be a low-cost EVM-compatible network or Layer 2.

## Non-Functional Requirements

Accuracy:

- Legal/regulatory answers should be grounded in approved source content.

Explainability:

- Answers should include source citations, dates, and confidence boundaries.

Privacy:

- Personal identity documents and private business files must not be stored on-chain.

Security:

- Admin and reviewer actions require authentication and authorization.

Maintainability:

- Knowledge updates should not require redeploying the whole application.

Performance:

- Chatbot answers should return within an acceptable response time for a web app.

Scalability:

- The architecture should support more procedures, more languages, and more cities later.

Auditability:

- Important approved knowledge versions must have traceable review and blockchain proof.

## Initial User Stories

- As a foreign investor, I want to know the basic steps to open a company in Da Nang so that I can plan my preparation.
- As a local founder, I want a checklist of required documents so that I do not miss important paperwork.
- As a user, I want the chatbot to show official sources so that I can trust the answer.
- As a reviewer, I want to approve updated regulatory content so that users see current information.
- As an admin, I want to publish a knowledge version to blockchain so that its integrity can be verified later.
- As a supervisor/examiner, I want to see the architecture and audit trail so that I can evaluate the technical contribution.

## MVP Feature List

Must have:

- Chatbot with RAG retrieval.
- Source citation display.
- Basic business setup checklist.
- Knowledge base admin review workflow.
- Blockchain version registry.
- Verification page.

Should have:

- Bilingual Vietnamese/English content for users, with English documentation for the project.
- Saved checklist.
- Conversation history.
- Source update dashboard.

Could have:

- AI expert marketplace.
- Multi-agent workflow.
- Automatic source monitoring.
- Mobile app.
- Integration with official portals.
