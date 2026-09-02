# Serverless Scaffold Optimization Checklist

> Context: this repository is positioned as a teaching/scaffold project, not a production-grade application. The goal of these optimizations is to make the example safer, clearer, and more internally consistent for learners and future extension work.

> Execution status: P0 complete (merged in #8). P1-P4 are implemented on the unified feature branch `codex/optimization-checklist`.

## Prioritization Rules

- Fix issues that teach the wrong architectural or coding pattern first.
- Prefer changes that improve both correctness and teaching value.
- Keep the scaffold simple; do not add production-only complexity unless it improves the example materially.

## P0: Fix Incorrect Todo Data Modeling

- [x] Align the `Todo` persistence model with the API contract so `id` is the true unique identifier.
- [x] Remove the current mismatch where the router treats `id` as unique but DynamoDB uses `title` as a range key.
- [x] Simplify `get`, `update`, and `delete` handlers so they no longer depend on looking up `title` to complete a composite key.
- [x] Re-check whether the `user_id` access pattern still needs a GSI after the schema correction.
- [x] Update sample data or request/response assumptions if the storage shape changes.

Acceptance criteria:

- `GET /todos/<id>` always resolves at most one item by primary key.
- `PUT /todos/<id>` and `DELETE /todos/<id>` do not require `title` to locate the record.
- The model, API handlers, and Terraform table definition all describe the same identity semantics.

Likely files:

- `src/portal/app/database/models.py`
- `src/portal/app/routers/todo.py`
- `src/portal/app/models/todo.py`
- `terraform/source/units/dynamodb/main.tf`
- `data/todos.json`

## P1: Fix Timestamp Defaults And Persistence Examples

- [x] Replace eager timestamp defaults with callables so new records get the creation time at write time, not import time.
- [x] Make `Todo` timestamps follow the same pattern instead of defaulting to empty strings.
- [x] Standardize timestamp formatting between create and update paths.
- [x] Ensure response models and stored values stay compatible after the timestamp cleanup.

Acceptance criteria:

- Two records created at different times do not share the same default timestamp accidentally.
- No persisted item relies on empty-string timestamps as the default example.
- `created_at` and `updated_at` semantics are consistent across `Todo` and `User`.

Likely files:

- `src/portal/app/database/models.py`
- `src/portal/app/models/todo.py`
- `src/portal/app/models/user.py`
- `src/portal/app/routers/user.py`
- `src/portal/app/routers/todo.py`

## P2: Tighten Error Handling And HTTP Boundary Behavior

- [x] Remove broad catch-and-rethrow patterns that hide the original exception type.
- [x] Let framework-managed exceptions pass through when appropriate.
- [x] Keep business errors explicit, especially `404` cases for missing resources.
- [x] Normalize logging so unexpected exceptions are logged once at the right boundary.
- [x] Decide whether to restore a dedicated not-found handler or rely on the framework default, and document that choice in code.

Acceptance criteria:

- Unexpected failures preserve useful traceback information.
- Expected missing-resource cases consistently return `404`.
- The Lambda entrypoint does not wrap every exception in a generic `Exception`.

Likely files:

- `src/portal/app/main.py`
- `src/portal/app/routers/todo.py`
- `src/portal/app/routers/user.py`
- `src/portal/app/routers/system.py`

## P3: Build A Minimal Real Test Suite And Python CI Gate

- [x] Replace the placeholder unit test with meaningful tests around routing and handler behavior.
- [x] Add tests for the corrected `Todo` identity semantics.
- [x] Add tests for timestamp behavior and missing-resource paths.
- [x] Add a Python-focused CI workflow for unit tests and linting.
- [x] Keep the test scope lightweight so the scaffold stays easy to run locally.

Acceptance criteria:

- The repository has at least one real unit test per main router area or critical behavior.
- CI fails when Python unit tests fail.
- The placeholder “always passes” test is removed.

Likely files:

- `src/tests/unit/test_main.py`
- `src/tests/unit/`
- `.github/workflows/`
- `src/requirements-dev.txt`
- `.pre-commit-config.yaml`

## P4: Repair Local Developer Experience Drift

- [x] Fix broken `just` recipes in `src/justfile`, especially references to missing helpers.
- [x] Correct incorrect test paths in local commands.
- [x] Verify the documented commands in `README.md` and `docs/DEVELOPMENT.md` still match the repository.
- [x] Make sure a new contributor can follow the documented path without hitting obvious command failures.

Acceptance criteria:

- `just` recipes referenced in docs exist and run with the documented working directory.
- Local unit test commands point to valid paths.
- Documentation and executable commands agree on how to develop and test the project.

Likely files:

- `src/justfile`
- `README.md`
- `src/README.md`
- `docs/DEVELOPMENT.md`

## Nice To Have After Core Fixes

- [ ] Review naming consistency between `portal`, `Todos/Users API`, and `sls-template`.
- [ ] Audit dead code or template leftovers such as unused imports, stale comments, or currently unused modules.
- [ ] Consider adding one short architecture note explaining why the repo uses Powertools + PynamoDB + Terragrunt.

## Recommended Execution Order

1. P0: Fix incorrect Todo data modeling
2. P1: Fix timestamp defaults and persistence examples
3. P2: Tighten error handling and HTTP boundary behavior
4. P3: Build a minimal real test suite and Python CI gate
5. P4: Repair local developer experience drift

## Definition Of Done For This Optimization Pass

- The scaffold no longer demonstrates misleading data modeling patterns.
- The Python example code has basic but real automated protection.
- Local docs and commands are internally consistent.
- The repository is still simple enough for teaching and onboarding use.
