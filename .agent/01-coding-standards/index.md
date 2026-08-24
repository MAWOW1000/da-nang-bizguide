---
title: Coding Standards
description: Coding standards and conventions for the project — security, React/TypeScript, PHP, REST API design, and Laravel. Read the relevant guide before writing or reviewing code so every change is consistent, secure, and reviewable.
---

The conventions every change must follow. Each guide is self-contained with bad/good examples you can copy. Pair these with `../02-product-docs` (what to build) when turning a requirement into code or tests.

## Guides

| Guide | What it covers |
|-------|----------------|
| [Security](./01-security.md) | Common backend vulnerabilities (SQLi, XSS, CSRF, SSRF, mass assignment, JWT, timing attacks) with mitigations, graded by severity. |
| [React](./02-react.md) | React + TypeScript — structure, naming, typing components/hooks, state, performance, testing, common patterns. |
| [PHP](./03-php.md) | PSR-12 PHP standard — naming, structure, error handling, SOLID, testing, and tooling (Pint, PHPStan, Pest). |
| [REST API](./04-rest-api.md) | API design — resource naming, HTTP methods, status codes, versioning, error format, pagination, rate limiting. |
| [Laravel](./05-laravel.md) | Laravel conventions — naming, FormRequest validation, DRY/SRP, service container, config over `.env`, date handling. |

## How to use

- **Writing code:** open the guide(s) matching the language/layer you touch.
- **Reviewing:** each guide doubles as a review checklist.
- **Automating:** map a rule → its enforcing tool (Pint/PHPStan, ESLint) → a test.
