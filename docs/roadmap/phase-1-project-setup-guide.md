# Phase 1: Multi-Repo Project Setup Guide

This guide expands Phase 1 of the NestJS + Next.js implementation plan.

Goal: create separate repositories for the deployable services while keeping the architecture simple enough for an MVP.

Estimated time: 2-3 days.

## Step 1: Confirm Tooling

### What to do

Install or confirm these tools:

```bash
node --version
pnpm --version
docker --version
docker compose version
git --version
gh auth status
```

If `pnpm` is not available:

```bash
corepack enable
corepack prepare pnpm@latest --activate
```

### Why

The project has several deployable parts. `pnpm` gives fast TypeScript package management for each repository. Docker is needed so PostgreSQL and Redis/Valkey can run locally without installing them directly on your machine. `gh` is used to create GitHub repositories without doing the setup manually in the browser.

## Step 2: Use This Repository Split

### What to do

Use one repository per deployable service:

```text
da-nang-bizguide/
  docs and thesis materials

da-nang-bizguide-frontend/
  Next.js app

da-nang-bizguide-api/
  NestJS API

da-nang-bizguide-contracts/
  Solidity contracts

da-nang-bizguide-worker/
  optional later worker
```

### Why

Free deployment platforms are usually easier when each app has its own repository:

- `da-nang-bizguide-frontend`: deploy to Vercel Free.
- `da-nang-bizguide-api`: deploy to Render, Railway, Fly, or another free/low-cost API host.
- `da-nang-bizguide-contracts`: run deployment scripts for Sepolia or another EVM demo network.
- `da-nang-bizguide`: keep documentation, architecture, roadmap, and thesis materials.

This is a multi-repo setup, but the backend should still begin as a modular monolith. Do not split every backend feature into a separate service yet.

## Step 3: Keep Current Repo as Documentation

### What to do

Use the current `da-nang-bizguide` repository for:

```text
docs/
materials/
research/
data/
```

### Why

The current repository already contains project definition, requirements, architecture, diagrams, and roadmap files. Keeping it as a docs repository avoids mixing thesis/project planning with app deployment settings.

## Step 4: Create the Next.js Frontend Repo

### What to do

Create the frontend project:

```bash
pnpm create next-app@latest da-nang-bizguide-frontend
```

Recommended prompt choices:

```text
TypeScript: Yes
ESLint: Yes
Tailwind CSS: Yes
src/ directory: Yes
App Router: Yes
Turbopack: Yes
Import alias: Yes
```

Make sure `da-nang-bizguide-frontend/package.json` has:

```json
{
  "name": "da-nang-bizguide-frontend"
}
```

Run:

```bash
cd da-nang-bizguide-frontend
pnpm dev
```

### Why

Next.js gives React plus routing, server rendering, production build tooling, and deployment support. App Router is a good fit because the app will have public pages, admin pages, verification pages, and API-connected server/client components.

Tailwind is useful because this project needs fast UI iteration for dashboard, chat, checklist, and admin screens.

## Step 5: Create the NestJS API Repo

### What to do

Create the API project:

```bash
pnpm dlx @nestjs/cli new da-nang-bizguide-api --package-manager pnpm --strict
```

Make sure `da-nang-bizguide-api/package.json` has:

```json
{
  "name": "da-nang-bizguide-api"
}
```

Run:

```bash
cd da-nang-bizguide-api
pnpm start:dev
```

### Why

NestJS gives the backend a clear structure from day one:

- modules for feature boundaries
- controllers for HTTP routes
- services for business logic
- guards for auth and roles
- providers for database, blockchain, AI, and cache clients

Using strict TypeScript is worth it because this project handles legal/regulatory knowledge and blockchain verification. Strong types catch mistakes earlier.

## Step 6: Use OpenAPI Instead of a Shared Package First

### What to do

In the API repository, add Swagger/OpenAPI during Phase 2. The frontend should use the API contract instead of importing backend code directly.

Later, if repeated API types become painful, generate a frontend API client from the OpenAPI JSON.

### Why

Separate repositories cannot easily import a local shared package without package publishing or Git dependencies. For the MVP, the cleanest contract is the backend OpenAPI spec. This keeps deployment simple and still gives the frontend a reliable API reference.

## Step 7: Create Environment Templates

### What to do

Frontend `.env.example`:

```bash
NEXT_PUBLIC_API_URL=http://localhost:3001
```

API `.env.example`:

```bash
NODE_ENV=development
PORT=3001

DATABASE_URL=postgresql://postgres:postgres@localhost:5432/bizguide
REDIS_URL=redis://localhost:6379

JWT_ACCESS_SECRET=replace-me
JWT_REFRESH_SECRET=replace-me

EVM_RPC_URL=
EVM_PRIVATE_KEY=
KNOWLEDGE_REGISTRY_ADDRESS=
```

Contracts `.env.example`:

```bash
EVM_RPC_URL=
EVM_PRIVATE_KEY=
ETHERSCAN_API_KEY=
```

### Why

Each repo deploys separately, so each repo needs its own environment template. This is especially important for blockchain because private keys and RPC keys must never be committed to Git.

## Step 8: Add Local Docker Compose to the API Repo

### What to do

Create `docker-compose.yml` in `da-nang-bizguide-api`:

```yaml
services:
  postgres:
    image: postgres:16-alpine
    container_name: bizguide-postgres
    ports:
      - "5432:5432"
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: bizguide
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: valkey/valkey:8-alpine
    container_name: bizguide-redis
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

volumes:
  postgres_data:
  redis_data:
```

Start local services from the API repo:

```bash
docker compose up -d
```

### Why

PostgreSQL is the main app database. Redis/Valkey is useful for caching, rate limiting, short-lived data, and background jobs. The API owns these local development dependencies because the frontend should not connect directly to the database or Redis.

## Step 9: Add Formatting and README Files

### What to do

Install Prettier in each code repository:

```bash
pnpm add -D prettier
```

Create `.prettierrc`:

```json
{
  "semi": true,
  "singleQuote": false,
  "trailingComma": "all"
}
```

Create README setup instructions in each repo.

### Why

Each repo will be built and deployed independently, so each one must explain its own local setup, environment variables, build command, and deployment target.

## Step 10: Add Basic Health Checks

### What to do

API:

- Keep or add `GET /` for a simple API response.
- Add `GET /health` later in Phase 2.

Frontend:

- Add a simple call to the backend health route later.
- Use `NEXT_PUBLIC_API_URL` for API calls.

### Why

Before building real features, confirm that the frontend can reach the API. This avoids wasting time debugging feature code when the real problem is CORS, ports, or environment variables.

## Step 11: Push Each Repo to GitHub

### What to do

Use `gh` to create repositories and set SSH remotes using the `github-personal` host alias:

```bash
gh repo create MAWOW1000/da-nang-bizguide-frontend --private
git remote add origin git@github-personal:MAWOW1000/da-nang-bizguide-frontend.git
git push -u origin main
```

Repeat for:

```text
da-nang-bizguide-api
da-nang-bizguide-contracts
```

### Why

The `github-personal` SSH alias lets Git push through your personal GitHub SSH configuration. Creating separate repos also makes Vercel, Render, and contract deployment workflows simpler.

## Step 12: Verify Phase 1

### What to do

Run these checks:

```bash
cd da-nang-bizguide-frontend
pnpm install
pnpm dev
pnpm lint
pnpm build

cd ../da-nang-bizguide-api
pnpm install
docker compose up -d
pnpm start:dev
pnpm lint
pnpm build

cd ../da-nang-bizguide-contracts
pnpm install
pnpm test
```

Expected result:

- Frontend runs on `http://localhost:3000`.
- API runs on `http://localhost:3001` or the configured NestJS port.
- PostgreSQL runs on port `5432`.
- Redis/Valkey runs on port `6379`.
- Contracts compile and tests run.

### Why

Phase 1 is done only when every repository can actually run. The goal is not just folders and GitHub repos. The goal is a repeatable foundation for the real product features.

## Phase 1 Definition of Done

Phase 1 is complete when:

- The docs repository is updated for multi-repo architecture.
- Next.js frontend repo runs locally.
- NestJS API repo runs locally.
- Contracts repo exists and compiles.
- Docker Compose starts PostgreSQL and Redis/Valkey for API development.
- `.env.example` files document required environment variables.
- Each repository has README setup instructions.
- Each repository has a GitHub remote and initial push.

## References

- Next.js installation: https://nextjs.org/docs/app/getting-started/installation
- NestJS first steps: https://docs.nestjs.com/first-steps
- NestJS CLI: https://docs.nestjs.com/cli/overview
