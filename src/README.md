# Source Code

This repository is now the documentation and planning repository. Deployable source code is split into separate GitHub repositories so each service can be deployed independently on free hosting platforms.

Planned implementation repositories:

- `da-nang-bizguide-frontend`: Next.js web app.
- `da-nang-bizguide-api`: NestJS backend API.
- `da-nang-bizguide-contracts`: Solidity smart contracts, deployment scripts, blockchain tests.
- `da-nang-bizguide-worker`: optional later worker for RAG indexing, queues, and blockchain events.

Keep this `src/` folder only for small documentation examples or placeholders. Production application code should live in the repositories above.
