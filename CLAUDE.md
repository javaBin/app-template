# CLAUDE.md — Javabin App Template

GitHub template repository for creating new services on the Javabin platform.

## What This Template Provides

| File | Purpose |
|------|---------|
| `app.yaml` | Platform service configuration — compute, routing, resources, auth |
| `Dockerfile` | Multi-stage build (Java/Temurin by default, adapt for your runtime) |
| `.github/workflows/deploy.yml` | CI entrypoint — calls `javabin.yml` reusable workflow |
| `README.md` | Starter README with getting-started steps |

## How to Use

1. Click **"Use this template"** on GitHub to create a new repo under `javaBin/`
2. Edit `app.yaml` — set your service name, team, compute settings, routing, and any resources
3. Ensure your team is registered in [javaBin/registry](https://github.com/javaBin/registry) (`teams/{name}.yaml`) and add the repo to the GitHub team named in `app.yaml` `team:` (CI verifies repo → team before vending credentials)
4. Push to `main` — the platform CI builds, plans, reviews, and deploys automatically
5. Set any secret values: `brew install javaBin/tap/javabin`, `javabin aws setup` (SSO permission set `javabin-team-<team>`), then `javabin secret set <name>`

## app.yaml Fields

- `name` — service name (required, lowercase + hyphens, max 20 chars)
- `team` — owning team, lowercase letters only (max 12), must exist in the registry (required)
- `compute` — CPU, memory, port, desired count, health check path, `user` (default `"1000"`), `readonly_root_filesystem` (default `true`; only `/tmp` writable)
- `routing` — hostname one label under `javazone.no`, `java.no` or `javabin.no`, and an optional ALB `priority` (leave it out: the platform derives a unique one; explicit values must be 1-999)
- `resources` — S3 buckets, DynamoDB tables / RDS PostgreSQL, SSM secrets (created as `PLACEHOLDER`, set with `javabin secret set`), SQS queues
- `auth` — Cognito: `internal`/`external` shorthand, or full form with `client: confidential|public|none`, `callback_urls` (https or `http://localhost`), `groups` (restricts sign-in), `env` (alias injected names)
- `environment` — custom environment variables

Unknown fields fail the pipeline's `expand` step. Budgets are per team, set in the registry.

Full reference: [app.yaml reference](https://github.com/javaBin/platform/blob/main/docs/app-yaml-reference.md)

## Dockerfile

The default Dockerfile uses `eclipse-temurin:21` for a Java/Maven project. Replace it with your own if you use a different runtime (Node.js, Go, Python, etc.).

## CI

This template includes `.github/workflows/deploy.yml` which calls the platform's reusable workflow `javaBin/platform/.github/workflows/javabin.yml@main`. No secrets are needed; keep the `permissions:` block (`id-token: write`, `contents: write`, `pull-requests: write`). The job's `if: github.repository != 'javaBin/app-template'` keeps the template itself from deploying; generated repos have another name, so it runs there.

Validate `app.yaml` locally against the generator from a platform checkout:
`GITHUB_WORKSPACE=. APP_SERVICE=my-service AWS_ACCOUNT_ID=553637109631 TF_ROOT=/tmp/gen python3 -I ../platform/scripts/generate-modules.py`

## Related

- [javaBin/platform](https://github.com/javaBin/platform) — shared infrastructure and reusable modules
- [javaBin/registry](https://github.com/javaBin/registry) — team registration
- [javaBin/javabin-cli](https://github.com/javaBin/javabin-cli) — `javabin register-team`, `javabin aws setup`, `javabin secret set`
