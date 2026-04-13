# Bazaar Pro Unified Merge Blueprint

## Objective

Merge two Flutter codebases (current mobile-first codebase + desktop codebase) into one scalable project with clear boundaries, predictable layering, and platform-specific adaptation points.

This document is the implementation source of truth for both teams.

---

## Current Project Signals (from this repo)

- Uses Flutter + BLoC + GetIt + GoRouter.
- Has `core`, `features`, and config folders already, which is a good starting point.
- Mobile assets are being moved under `assets/mobile/*` and desktop assets are intended but currently commented.
- Platform split currently happens in app bootstrap (`BazaarProMobile`, `BazaarProDesktop`, `BazaarProWeb`), but desktop/web are placeholders.
- Some business logic and infrastructure details are currently mixed in BLoCs and constants.
- DI is centralized in one file and can become hard to scale as features grow.

---

## Target End-State Architecture

Use **Feature-first Clean Architecture** with shared cross-platform core.

### Layer Rules (strict)

- `presentation`:
  - Widgets, pages, BLoC/Cubit, view models, mappers for UI only.
  - Must not call Dio/DB directly.
- `domain`:
  - Entities, repository contracts, use-cases.
  - No Flutter imports, no Dio, no Hive, no Sqflite.
- `data`:
  - DTO/models, data sources, repository implementations.
  - Handles API, local DB, cache, and mapping DTO -> entity.
- `core`:
  - Truly shared infrastructure only (network client, error model, logging, shared tokens, base widgets utilities).
- `platform`:
  - Platform-specific adapters (mobile/desktop/web differences, file paths, window manager integration, notifications).

### Dependency Direction

`presentation -> domain -> data(inversion via contracts)`

`data` depends on domain contracts and core infrastructure.

No reverse dependency from domain to presentation/data.

---

## Recommended Folder Structure

```text
lib/
  app/
    bootstrap/
      app_initializer.dart
      env_initializer.dart
    di/
      service_locator.dart
      modules/
        core_module.dart
        auth_module.dart
        profile_module.dart
        ...
    routing/
      app_router.dart
      route_guards.dart
      routes.dart
    platform/
      platform_type.dart
      platform_adapter.dart

  core/
    network/
      api_client.dart
      request_interceptor.dart
      response_parser.dart
    storage/
      key_value_store.dart
      local_db.dart
    errors/
      app_failure.dart
      app_exception.dart
    design_system/
      tokens/
      components/
    constants/
      durations.dart
      text_strings.dart
    utils/

  features/
    auth/
      domain/
        entities/
        repositories/
        usecases/
      data/
        models/
        datasources/
          auth_remote_data_source.dart
          auth_local_data_source.dart
        repositories/
          auth_repository_impl.dart
        mappers/
      presentation/
        bloc/
        pages/
          mobile/
          desktop/
          adaptive/
        widgets/

    profile/
      ... same pattern ...

  assets/
    shared/
    mobile/
    desktop/
```

---

## Merge Strategy (Two Codebases -> One)

## Phase 1: Stabilize Foundation

1. Freeze feature development on both repos (short merge window).
2. Choose one repo as base (recommended: this repo as base since architecture scaffolding already exists).
3. Create a merge branch:
   - `chore/unified-architecture-merge`
4. Define canonical package name, app id, and env strategy once.

## Phase 2: Shared Core Extraction

Move into shared `core` first (before feature migration):

- Design tokens (`spacing`, `typography`, `elevation`, colors).
- Shared base widgets and extensions that are truly platform-agnostic.
- Networking stack (`runApi`, parser, interceptors, retry, dedup).
- Error and result abstraction (replace loosely typed parser responses over time).
- Storage abstractions:
  - `KeyValueStore` (Hive/secure storage wrapper)
  - `LocalDatabase` (Sqflite wrapper)

## Phase 3: Feature-by-Feature Migration

For each feature (`auth`, `profile`, `dashboard`, `watchlist`, `trade`, `position`, etc.):

1. Align folder structure to domain/data/presentation.
2. Extract domain entities + repository contracts.
3. Move API/DB calls from bloc/service layers into data sources and repository implementations.
4. Keep BLoC focused on orchestration and state transitions only.
5. Merge desktop UI into same feature under `presentation/pages/desktop`.
6. Keep adaptive entry point under `presentation/pages/adaptive`.

Do this feature-by-feature, not all at once.

## Phase 4: Unified Routing and Guards

- Keep one router in `app/routing`.
- Move auth redirect logic from comments into tested guard logic.
- Keep route names/paths centralized in `routes.dart`.
- Add platform route handling only where needed (not per feature by default).

## Phase 5: Asset and Platform Convergence

- Finalize:
  - `assets/shared/*` for common assets
  - `assets/mobile/*` for mobile-only
  - `assets/desktop/*` for desktop-only
- Create typed asset accessors by scope (shared/mobile/desktop), avoid hardcoded strings spread across code.

## Phase 6: Test and Hardening

- Add unit tests for:
  - use-cases
  - repository impls (with mocked data sources)
  - critical blocs
- Add integration smoke tests:
  - auth flow
  - dashboard load
  - profile fetch/edit
- Validate all 3 platforms build from same code branch.

---

## Desktop Team Adaptation Contract

Desktop code should adapt to this project by following these non-negotiables:

1. Do not introduce a second DI container.
2. Do not add feature code directly into `core`.
3. Desktop-specific UI goes under `features/<feature>/presentation/pages/desktop`.
4. Shared business logic must go to `domain` use-cases, not desktop widgets.
5. Platform APIs must be wrapped by `app/platform` adapters.
6. Do not bypass repository contracts from presentation layer.
7. Reuse shared routing and state contracts.

---

## Coding Standards for Scalability

- One source of truth for each feature repository contract (`domain/repositories`).
- Prefer immutable state + equatable models for BLoCs.
- Keep request/response DTOs only in `data/models`.
- Use explicit mappers between DTO and domain entity.
- Ban raw JSON parsing in BLoC/UI.
- Keep environment values in typed config, never inline in feature code.
- Every new feature must provide:
  - use-case(s)
  - repository contract + implementation
  - presentation state management
  - at least basic tests

---

## Suggested Immediate Refactors in This Repo

1. Move app bootstrap concerns from `main.dart` into `app/bootstrap`.
2. Split `core/di/di.dart` into module-based registration files.
3. Promote `AuthService` pattern into explicit use-cases (`LoginUseCase`, `FetchSettingsUseCase`).
4. Move DB logic from `AuthBloc` into auth local data source and repository implementation.
5. Move auth route redirect into router guards and enable it.
6. Introduce `assets/shared` and normalize asset constants by platform scope.

---

## Merge Execution Checklist

- [ ] Base branch decided and frozen.
- [ ] Unified folder structure created.
- [ ] DI modularized.
- [ ] Shared core extracted.
- [ ] Auth feature fully migrated and used as template.
- [ ] Remaining features migrated one by one.
- [ ] Router guards finalized and tested.
- [ ] Assets split into shared/mobile/desktop.
- [ ] CI pipeline builds mobile + desktop from same branch.
- [ ] Regression test pass for critical user journeys.

---

## Definition of Done (Final Merge)

Merge is complete only when:

1. One repository builds mobile and desktop without conditional hacks scattered across features.
2. Every feature follows the same domain/data/presentation boundaries.
3. Platform-specific code exists only in platform adapter layer or platform presentation pages.
4. Authentication, profile, and dashboard flows pass on both codepaths.
5. New feature onboarding can be done by cloning the same feature template.

---

## Risk Register and Mitigation

- Risk: Business logic remains in BLoCs after merge.
  - Mitigation: enforce use-case and repository contract review in PR checklist.
- Risk: Duplicate models between desktop and mobile.
  - Mitigation: keep domain entities shared; map platform DTOs to shared entities.
- Risk: Router drift and navigation loops.
  - Mitigation: central route guards + integration tests for auth redirects.
- Risk: Asset path regressions.
  - Mitigation: typed asset constants + smoke test screen per feature.

---

## PR Review Gate (Mandatory)

Any merge PR must pass:

1. Layering check (no forbidden imports).
2. Platform boundary check.
3. Test updates for modified feature.
4. Route impact review.
5. Build run for targeted platforms.

---

## Communication Format for Cross-Team Sync

Use this simple format in every merge PR:

- Scope: Feature(s) migrated
- Architecture changes: contracts/use-cases/data-sources touched
- Platform impact: mobile/desktop/shared
- Risk: possible regressions
- Test proof: unit/integration/manual checklist

This keeps desktop and mobile teams aligned while migrating incrementally.
