# Repository Guidance

This repository is a Redocly/OpenAPI documentation workspace for VEDECOM eMobility APIs. It contains API specifications and Redocly presentation configuration, not application runtime code.

## Scope

These instructions apply to every file under this directory.

## Repository Shape

- `redocly.yaml` is the Redocly configuration and theme entry point.
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

Current repository note: `redocly.yaml` registers the checked-in domain specs directly under `apis`. There is no generated aggregate OpenAPI file.

## Editing Rules

- Treat OpenAPI files as source documentation contracts. Preserve API behavior unless the user explicitly asks for a contract change.
- Prefer editing the smallest relevant domain spec instead of creating a new aggregate or duplicate schema.
- Keep `$ref` values relative and stable. When moving schemas or path items, validate every affected referring file.
- Preserve existing OpenAPI versions unless a migration is requested. This repo currently mixes OpenAPI `3.0.3` and `3.1.0`.
- Use YAML for existing YAML specs and JSON for existing JSON specs. Do not convert formats unless requested.
- Keep operation IDs unique within each spec.
- For Redocly warnings, fix regressions introduced by the current change first. Existing baseline issues are present and should not be treated as newly caused without evidence.
- Do not add package managers, lockfiles, or new dependencies unless the user explicitly asks. The repo currently relies on a globally available Redocly CLI.

## Redocly Commands

The available local CLI observed during initialization is:

```bash
redocly --version
```

It reported `2.0.8`.

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
redocly lint
```

Warnings are currently accepted; blocking errors should be fixed.

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
2. Run a representative `redocly lint <actual-spec>` command.
3. If the configured `apis.*.root` changes, run `redocly lint <api-name>` and report the result.

## Style

- Keep descriptions concise and implementation-grounded.
- Prefer concrete request/response examples when they clarify client behavior.
- Do not invent endpoints, status codes, auth flows, schemas, or server URLs. Mark uncertain behavior as a documentation gap instead.
- Keep vendor extensions such as `x-websocket`, `x-mqtt-topics`, and `x-tagGroups` when they document behavior OpenAPI cannot model natively.
- Preserve OpenADR-specific compliance notes. `OpenADR/openapi-bundle.yml` describes GAC-specific constraints layered on OpenADR 3 and warns that this bundled API is not fully standard OpenADR 3 compliant for generic client/server generation.
- Avoid broad formatting churn in large specs; preserve nearby style and quoting conventions.
