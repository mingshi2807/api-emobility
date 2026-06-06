# Repository Guidance

This repository is a Redocly/OpenAPI documentation workspace for VEDECOM eMobility APIs. It contains API specifications, reader documentation, Redocly configuration, and deployment helpers, not application runtime code.

## Scope

These instructions apply to every file under this directory.

## Repository Shape

- `readme.md` is the reader-facing overview of the VEDECOM eMobility API specifications. Keep it free of Redocly operational, configuration, and CLI content.
- `AGENTS.md` is the operational guidance file for repository agents and maintainers. Keep Redocly commands, configuration notes, preview/build workflow, and deployment notes here.
- `redocly.yaml` is the source Redocly configuration and theme entry point. API roots point to checked-in source specs and `output` fields mirror bundled artifacts into `dist/`.
- `redocly.dist.yaml` is the bundled-artifact Redocly configuration. API roots point to `dist/` and preserve the same API ordering as `redocly.yaml`.
- Domain API specs live in top-level product folders:
  - `ERM/openapi.yaml`
  - `HEMS/hems.yaml`
  - `OBC/openapi.yaml`
  - `OCPP_OCPI/openapi.yaml`
  - `OpenADR/openapi-bundle.yml`
  - `ev-virtualizer/ev-virtualizer.yaml`
  - `charge-point/*.yaml`
  - `PKI/**/*.json`
- Static branding assets are at the repository root: `logo-vedecom.png`, `logo-vedecom-dark.png`, and the favicon path referenced by `redocly.yaml`.

Current repository note: `redocly.yaml` registers the checked-in domain specs directly under `apis`; `redocly.dist.yaml` registers the generated `dist/` artifacts for faster and cleaner preview/build workflows. There is no generated aggregate OpenAPI file.

## Editing Rules

- Treat OpenAPI files as source documentation contracts. Preserve API behavior unless the user explicitly asks for a contract change.
- Prefer editing the smallest relevant domain spec instead of creating a new aggregate or duplicate schema.
- Keep `$ref` values relative and stable. When moving schemas or path items, validate every affected referring file.
- Preserve existing OpenAPI versions unless a migration is requested. This repo currently mixes OpenAPI `3.0.3` and `3.1.0`.
- Use YAML for existing YAML specs and JSON for existing JSON specs. Do not convert formats unless requested.
- Keep operation IDs unique within each spec.
- For Redocly warnings, fix regressions introduced by the current change first. Existing baseline issues are present and should not be treated as newly caused without evidence.
- Do not add new dependencies unless the user explicitly asks. This repo currently pins Redocly tooling in `package.json` and `package-lock.json`.
- Keep reader-facing API descriptions in `readme.md`; keep Redocly operations in `AGENTS.md`.

## Redocly Commands

Use the project npm scripts so the pinned Redocly version is used consistently. The package currently pins:

- `@redocly/cli@2.31.6`
- `@redocly/realm@0.133.1`

Do not rely on a global Redocly version when changing or validating this repo.

Validate all configured source API entries:

```bash
npm run lint
```

Validate all configured bundled API entries:

```bash
npm run lint:dist
```

Bundle every configured source API into the mirrored `dist/` artifact layout:

```bash
npm run bundle
```

Preview the source specs:

```bash
npm run preview
```

Preview the bundled artifacts, regenerating `dist/` first:

```bash
npm run preview:dist
```

Preview the existing bundled artifacts without regenerating `dist/`:

```bash
npm run preview:dist:no-bundle
```

`scripts/preview-dist.sh` creates a temporary `.redocly-preview-dist/` project, copies the branding assets and Markdown pages, symlinks API directories to `dist/`, adapts `redocly.dist.yaml` into a temporary `redocly.yaml`, and starts Realm preview on `PORT` or `4000`.

Validate a changed spec directly:

```bash
redocly lint HEMS/hems.yaml
redocly lint charge-point/charge-point-api.yaml
redocly lint ERM/openapi.yaml
redocly lint OCPP_OCPI/openapi.yaml
redocly lint OpenADR/openapi-bundle.yml
redocly lint PKI/pki/pki.api.v1.json
```

Bundle a spec when `$ref` resolution or Redoc output needs checking:

```bash
redocly bundle charge-point/charge-point-api.yaml --output /tmp/charge-point-api.bundle.yaml
```

Do not use `redocly lint redocly.yaml` as a spec validation command; Redocly reports `Unsupported specification` because that file is configuration, not an OpenAPI document.

Validate all configured API entries through Redocly:

```bash
npm run lint
```

Warnings are currently accepted; blocking errors should be fixed.

## Redocly Configuration Notes

- `redocly.yaml` and `redocly.dist.yaml` must keep the same `catalogClassic.apis.items` ordering so the sidebar organization remains stable between source and bundled previews.
- The root route is intentionally redirected to `/readme` so the reader overview is the main index page instead of `/agents`.
- `catalogClassic.apis.title` is the API catalog heading shown for the standalone API specifications.
- `rules.operation-summary` and `rules.security-defined` are currently warnings. Do not treat existing warnings as blockers unless the user asks to resolve warnings.
- Top-level Realm display options such as `requiredPropsFirst`, `pathInMiddlePanel`, `hideHostname`, `expandResponses`, `jsonSampleExpandLevel`, `payloadSampleIdx`, `showObjectSchemaExamples`, `generateCodeSamples`, and nested `openapi.theme` are not valid in the current config shape and should not be reintroduced.
- Static branding assets live at the repository root and are referenced by both configs.

## Deployment Workflow

This repository includes a containerized shipment path:

```bash
docker compose up --build
```

The container uses Redocly CLI `2.31.6`, installs production npm dependencies, runs `npm run bundle` during image build, and serves the bundled-artifact preview on port `4000`.

The compose service maps host port `4000` to container port `4000`. Change the compose port mapping if the host already uses that port.

## Known Baseline Validation Status

Current baseline after resolving blocking lint errors:

- `redocly lint HEMS/hems.yaml` succeeds with warnings only.
- `redocly lint charge-point/charge-point-api.yaml` succeeds with warnings only.
- `redocly lint OBC/openapi.yaml` succeeds with warnings only.
- `redocly lint ev-virtualizer/ev-virtualizer.yaml` succeeds with warnings only.
- `redocly lint ERM/openapi.yaml` succeeds with warnings only.
- `redocly lint OCPP_OCPI/openapi.yaml` succeeds with no warnings observed.
- `redocly lint OpenADR/openapi-bundle.yml` succeeds with 4 warnings: undefined required property `intervals` in `eventBase`, invalid event examples against `oneOf`, and missing `4XX` response on `/auth/server`.
- `redocly lint PKI/*/*.api.v1.json` succeeds for the observed PKI roots; `PKI/rcp/rcp.api.v1.json` still reports one warning.
- `redocly lint redocly.yaml` fails with `Unsupported specification` because it is config.

When changing one spec, report whether warnings are pre-existing or caused by the edit. If the output is large, summarize the first warnings and counts.

## Verification Expectations

For documentation-only edits:

1. Run `redocly lint <changed-spec>` for each changed OpenAPI file.
2. Run `redocly bundle <entry-spec> --output /tmp/<name>.bundle.yaml` when changing `$ref`, shared components, or split charge-point files.
3. Inspect rendered-impact sensitive fields manually: `info`, `servers`, `tags`, `x-tagGroups`, examples, security, schemas, and response content.
4. In the final response, include changed files and the exact validation command results, including known remaining baseline failures.

For `redocly.yaml` edits:

1. Verify referenced assets and API roots exist.
2. Run `npm run lint` for source config changes.
3. If `redocly.dist.yaml` changes, run `npm run lint:dist` after `npm run bundle` has generated `dist/`.
4. If route, catalog, or preview behavior changes, run a bounded source or dist preview check and report whether the server starts without config validation errors.

## Style

- Keep descriptions concise and implementation-grounded.
- Prefer concrete request/response examples when they clarify client behavior.
- Do not invent endpoints, status codes, auth flows, schemas, or server URLs. Mark uncertain behavior as a documentation gap instead.
- Keep vendor extensions such as `x-websocket`, `x-mqtt-topics`, and `x-tagGroups` when they document behavior OpenAPI cannot model natively.
- Preserve OpenADR-specific compliance notes. `OpenADR/openapi-bundle.yml` describes GAC-specific constraints layered on OpenADR 3 and warns that this bundled API is not fully standard OpenADR 3 compliant for generic client/server generation.
- Avoid broad formatting churn in large specs; preserve nearby style and quoting conventions.
