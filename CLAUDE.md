# CLAUDE.md

## Project

This is a learning/playground project for the **open-source Dataform CLI** (`@dataform/cli`). The goal is to set up and explore a basic Dataform project structure using the CLI.

## Tooling

- **Dataform CLI**: `@dataform/cli@^3.0.0-beta` (open-source, npm package)
- Use `dataform` commands directly (assumed installed globally via `npm install -g @dataform/cli@^3.0.0-beta`)
- **Warehouse**: BigQuery
- **Cloud provider**: GCP (region: `southamerica-east1`)

## Credentials

`.df-credentials.json` format for BigQuery:

```json
{
  "projectId": "your_gcp_project",
  "location": "southamerica-east1",
  "credentials": "/path/to/service-account-key.json"
}
```

## Key Commands

```bash
dataform compile        # Validate SQLX syntax
dataform run --dry-run  # Test execution without hitting the warehouse
dataform run            # Execute transformations
dataform list           # List all actions
```

## Project Structure Conventions

- `definitions/staging/`      — raw source models (`stg_` prefix)
- `definitions/intermediate/` — intermediate transforms (`int_` prefix)
- `definitions/marts/`        — final analytics models (`fct_`, `dim_` prefix)
- `includes/`                 — shared JavaScript helpers

## Rules

- Always use `${ref("table_name")}` to reference other tables — never hardcode schema/table paths
- Run `dataform compile` before suggesting any `dataform run`
- Never commit `.df-credentials.json` — it must stay in `.gitignore`
- Keep SQLX files focused: one table/view per file
- Add `description` to every `config {}` block
