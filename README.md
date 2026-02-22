# dataform_playground

A learning/playground project for the open-source **Dataform CLI** (`@dataform/cli`), targeting **BigQuery** on GCP.

---

## Prerequisites

- WSL2 (Ubuntu 20.04+)
- Node.js 18+ installed in WSL
- A GCP project with BigQuery enabled
- A GCP service account key (JSON) with BigQuery permissions

---

## 1. Install Node.js on WSL

If you don't have Node.js yet, install it via `nvm` (recommended):

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc          # or ~/.zshrc if using zsh
nvm install 20
nvm use 20
node --version            # should print v20.x.x
```

---

## 2. Install the Dataform CLI

Install the open-source CLI globally:

```bash
npm install -g @dataform/cli@^3.0.0-beta
dataform --version        # verify the installation
```

> **Note:** the `@dataform/cli` package is the open-source CLI maintained by the Dataform team. It is separate from the `dataform` wrapper bundled inside Google Cloud.

---

## 3. Initialize a new Dataform project

Navigate to (or create) your project directory, then run:

```bash
mkdir my_dataform_project && cd my_dataform_project
dataform init --warehouse bigquery --default-location southamerica-east1
```

`dataform init` generates the following skeleton:

```
my_dataform_project/
├── dataform.json          # project config (warehouse, schema, location)
├── .gitignore
├── definitions/           # SQLX model files go here
└── includes/              # shared JS helpers
```

### `dataform.json` example

```json
{
  "warehouse": "bigquery",
  "defaultSchema": "dataform",
  "assertionSchema": "dataform_assertions",
  "defaultLocation": "southamerica-east1"
}
```

---

## 4. Configure credentials

Create `.df-credentials.json` in the project root (**never commit this file**):

```json
{
  "projectId": "your_gcp_project_id",
  "location": "southamerica-east1",
  "credentials": "/absolute/path/to/service-account-key.json"
}
```

Verify `.gitignore` already excludes it:

```bash
grep '.df-credentials.json' .gitignore   # should print the entry
```

---

## 5. Core CLI commands

| Command | Purpose |
|---|---|
| `dataform init` | Scaffold a new Dataform project |
| `dataform compile` | Validate SQLX syntax and resolve refs — **always run before `dataform run`** |
| `dataform list` | List all actions (tables, views, assertions) in the project |
| `dataform run --dry-run` | Simulate execution without touching the warehouse |
| `dataform run` | Execute all actions in dependency order |
| `dataform run --actions stg_orders` | Run a single action by name |
| `dataform run --tags marketing` | Run all actions that share a tag |
| `dataform run --include-deps` | Run an action and all its upstream dependencies |

---

## 6. Project structure conventions

```
definitions/
├── staging/        # stg_*  — thin wrappers over raw source tables
├── intermediate/   # int_*  — joins, enrichment, business logic
└── marts/          # fct_*, dim_*  — final analytics-ready models
includes/           # shared JS helpers (e.g. date macros)
```

---

## 7. Writing your first model

Create `definitions/staging/stg_orders.sqlx`:

```sql
config {
  type: "view",
  schema: "staging",
  description: "Raw orders from the source system."
}

SELECT
  order_id,
  customer_id,
  created_at,
  status
FROM `your_gcp_project.raw.orders`
```

Then reference it from another model using `${ref("stg_orders")}` — never hardcode the schema path.

---

## 8. Typical workflow

```bash
# 1. Edit or add a SQLX file
# 2. Validate syntax
dataform compile

# 3. Preview what SQL would run
dataform run --dry-run

# 4. Execute
dataform run
```

---

## Resources

- [Dataform CLI GitHub](https://github.com/dataform-co/dataform)
- [Dataform SQLX reference](https://cloud.google.com/dataform/docs/reference/dataform-core-reference)
- [BigQuery IAM roles](https://cloud.google.com/bigquery/docs/access-control)
