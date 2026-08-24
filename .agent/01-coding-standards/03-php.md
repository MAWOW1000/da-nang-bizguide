---
title: PHP
description: Unified PHP coding standard (PSR-12) covering naming, code structure, avoiding hard-coded values, comments/docblocks, error handling, testing, SOLID principles, and recommended tooling (Pint, PHPStan, Pest).
---

> **Purpose:** Establish a unified PHP coding standard across all projects to ensure code quality, maintainability, testability, and consistency.  
> This document serves as the foundation for automation (lint, format, CI/CD checks) and AI-assisted code reviews.

---

## 🎯 1. Objectives

- Define **clear, practical, and enforceable** coding standards applicable to all PHP projects (Laravel, Symfony, or custom frameworks).
- Ensure all code is:
  - **Clean** – easy to read and understand.
  - **Maintainable** – easy to modify or extend.
  - **Testable** – structured for unit and integration testing.
  - **Reviewable** – consistent and easy to evaluate in pull requests.
- Prevent common coding issues such as:
  - Hard-coded values and magic numbers.
  - Missing or poor comments.
  - Inconsistent naming.
  - Duplicated logic.
  - Violation of clean code and SOLID principles.

---

## ⚙️ 2. General Conventions

| Rule | Description | ✅ Good Example | ❌ Bad Example |
|------|--------------|----------------|----------------|
| **PSR-12** | All projects must follow [PSR-12](https://www.php-fig.org/psr/psr-12/) standard. | `class OrderService {}` | `class order_service {}` |
| **Encoding & Line Ending** | Use UTF-8 (no BOM), LF line endings. | — | — |
| **Indentation** | Use 4 spaces (no tabs). | `    return true;` | `↹return true;` |
| **Max Line Length** | 120 characters per line max. | — | Overly long line without wrapping. |

---

## 🧩 3. Naming Conventions

| Element | Rule | ✅ Good Example | ❌ Bad Example |
|----------|------|----------------|----------------|
| **Classes / Interfaces / Traits** | PascalCase | `UserRepository`, `OrderService` | `user_repo`, `orderservice` |
| **Methods / Functions** | camelCase | `calculateTotal()`, `getUserInfo()` | `Calculate_total()`, `Get_user_info()` |
| **Variables** | camelCase and meaningful | `$totalPrice`, `$userEmail` | `$tp`, `$ue`, `$data` |
| **Constants** | UPPER_CASE | `MAX_RETRY_COUNT` | `maxRetryCount` |
| **File Names** | Match the class name | `OrderService.php` | `orderservice.php` |
| **API / Route Names** | kebab-case, noun-based (see [REST API](./04-rest-api.md)) | `/user-orders` | `/getUserOrders`, `/get_user_orders` |

> 🔸 **Rule:** Always use meaningful names. Avoid vague or generic terms like `tmp`, `info`, `data`, etc.

---

## 🧱 4. Code Structure & Organization

- Each PHP file must define **one class, interface, or trait**.
- **No business logic** directly in routes or controllers – delegate to **Service Layer**.
- Avoid **nested if/else** deeper than 3 levels.
- Keep business logic separate from presentation or API response logic.
- No “orphan” code blocks – all logic must belong to a defined class or function.

**✅ Example (Good):**
```php
class OrderService {
    public function calculateTotal(array $items): float
    {
        return array_sum(array_column($items, 'price'));
    }
}
```

**❌ Example (Bad):**
```php
// Inside a controller
$total = 0;
foreach ($items as $item) {
    $total += $item['price'];
}
```

---

## 🚫 5. Avoid Hard-Coded Values & Magic Numbers

| Scenario | Recommendation |
|-----------|----------------|
| Fixed values | Use constants or config files. |
| Keys / URLs / Tokens | Store in `.env` file. |
| Text messages | Define in language files or constants. |

**✅ Example:**
```php
const DEFAULT_PAGE_SIZE = 20;
$users = $this->userRepo->paginate(self::DEFAULT_PAGE_SIZE);
```

**❌ Example:**
```php
$users = $this->userRepo->paginate(20); // hard-coded
```

---

## 🧠 6. Comments & DocBlocks

- Every **public method** must include a docblock.
- Comments should describe **what and why**, not **how**.
- Use standard PHPDoc syntax:
```php
/**
 * Calculate order total after applying discounts.
 *
 * @param array $items
 * @return float
 */
```

- Avoid useless comments:
```php
// Loop through items ❌
```

---

## 🔄 7. Avoid Code Duplication

- If the same logic appears in 2+ places → refactor into a **Helper**, **Trait**, or **Service**.
- Never copy-paste controller logic.
- Use **Repository Pattern** for complex queries.

---

## ⚡ 8. Error Handling & Validation

| Rule | Description |
|------|--------------|
| Always validate user input | Use FormRequest or Validator. |
| Don’t suppress errors (`@`) | Causes silent failures. |
| Throw specific exceptions | Create custom exception classes. |
| Log meaningful messages | Include context (user, request ID, etc.). |

**✅ Example:**
```php
if (!$user) {
    throw new UserNotFoundException("User not found: $id");
}
```

**❌ Example:**
```php
if (!$user) {
    throw new Exception("Error");
}
```

---

## 🧪 9. Testing & Automation

- Each feature or module **must** have unit or feature tests.
- Tests must be **isolated** (no dependency on real DB or external services).
- Recommended tools:
  - **PHPUnit / Pest** → Unit & Feature Testing
  - **PHPStan / Larastan** → Static Analysis
  - **Laravel Pint / PHPCS** → Code Style
  - **Infection** → Mutation Testing (optional)
- CI/CD pipeline should include:
  ```bash
  composer lint
  composer test
  composer analyse
  ```

---

## 🧰 10. Clean Code & SOLID Principles

| Principle | Description |
|------------|--------------|
| **S – Single Responsibility** | A class should have one reason to change. |
| **O – Open/Closed** | Open for extension, closed for modification. |
| **L – Liskov Substitution** | Subclasses should be substitutable for their base classes. |
| **I – Interface Segregation** | Prefer small, specific interfaces. |
| **D – Dependency Inversion** | Depend on abstractions, not concretions. |

> ✅ Readability > Cleverness.  
> Code that’s easy to read is easier to maintain and test.

---

## 🧾 11. Common Mistakes & How to Fix Them

| Common Issue | Description | Recommended Fix |
|---------------|--------------|------------------|
| Hard-coded values | Fixed value written directly in code | Move to constants or config |
| Poor naming | Ambiguous or unclear | Rename descriptively |
| Duplicated logic | Repeated across files | Extract to shared method or trait |
| Missing comments | No method description | Add docblocks |
| Business logic in controller | Controller too heavy | Move to service layer |
| Magic strings | Repeated string literals | Use constants or enums |
| Generic exception handling | Using `Exception` everywhere | Use specific exception classes |

---

## 🧩 12. Purpose of This Document

- Define a **standardized PHP coding rule set** for all company projects.
- Serve as **AI input** for generating and validating clean, compliant code.
- Provide a **baseline for performance reviews** and code quality evaluations.
- Act as the **foundation for CI/CD quality gates** (lint, format, coverage).

---

## 🧮 13. Recommended Tooling Setup

| Tool | Purpose |
|------|----------|
| **Laravel Pint / PHPCS** | Code style and formatting |
| **PHPStan / Larastan** | Static analysis and type checking |
| **Pest / PHPUnit** | Automated testing |
| **Composer scripts** | Unified task runner |
| **Husky / pre-commit hooks** | Prevent bad commits (lint + test before push) |

**Example `composer.json` scripts:**
```json
"scripts": {
    "lint": "pint --test",
    "format": "pint",
    "analyse": "phpstan analyse --memory-limit=1G",
    "test": "phpunit --colors=always"
}
```

---

## ✅ 14. Compliance & Review

- All developers **must follow** these guidelines.
- Code violating the rules will:
  - Fail automated lint/CI checks, or
  - Be flagged during peer review.
- Repeated violations may be subject to formal evaluation in team reviews.

---

> 🧠 **Summary:**  
> Clean code is not about perfection — it’s about **clarity, consistency, and responsibility**.  
> Following these guidelines ensures that every developer contributes to a scalable, maintainable, and professional codebase.

---