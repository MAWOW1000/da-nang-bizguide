# Da Nang BizGuide — Antigravity Agent Guidelines

> **Project Name**: Da Nang BizGuide: Trusted AI and EVM Blockchain Platform for Business Establishment Guidance in Da Nang City.

---

## 1. Architecture Overview (4-Tier Multi-Repo Stack)

This workspace integrates 4 distinct submodules under a unified architecture:

1. **Smart Contracts (`contract/`)**:
   - Solidity `^0.8.28` compiled & tested with Hardhat.
   - Core contract: `KnowledgeRegistry.sol` for immutable SHA-256 regulatory hash anchoring.
   - Test command: `npx hardhat test`
2. **Backend API (`backend/`)**:
   - NestJS (TypeScript) with Prisma ORM (CJS format) on PostgreSQL + pgvector.
   - Test command: `npm test` / `npm run test:e2e`
3. **AI Service (`ai/`)**:
   - FastAPI (Python >= 3.12) with DeepSeek generation, VoyageAI/FlagEmbedding vectors, and Citation Verification Gate.
   - Test command: `uv run pytest tests/`
4. **Frontend (`frontend/`)**:
   - Next.js (React, Tailwind CSS, Radix UI, Orval client).
   - API sync command: `npm run generate:api`

---

## 2. Standard 5-Step Workflow

When implementing any task or feature:

1. **HTML Plan First**: Always generate an easy-to-read plan at `.claude/local/plans/<task>.html` using `.claude/skills/gh-workflow/workflow.sh plan "<Task Name>"` for user approval.
2. **GitHub Issue**: Recommend or create issues across parent repo (`MAWOW1000/da-nang-bizguide`) or submodules via `.claude/skills/gh-workflow/workflow.sh issue create`.
3. **Implementation**: Code in clean, atomic steps following `.claude/rules/pr-review.md`.
4. **Full E2E Testing**: Run `.claude/skills/test-e2e/e2e.sh all` to verify all 4 layers (100% tests must pass).
5. **PR & Report**: Create PR via `gh pr create` and generate the final HTML verification report.

---

## 3. Essential Commands Reference

```bash
# Start local stack
make dev
make status
make stop

# E2E test suite across all layers
.claude/skills/test-e2e/e2e.sh all

# Generate HTML test report
.claude/skills/test-e2e/e2e.sh report --open

# Workflow and issue manager
.claude/skills/gh-workflow/workflow.sh plan "<Task Name>" --open
.claude/skills/gh-workflow/workflow.sh issue list
.claude/skills/gh-workflow/workflow.sh test
```
