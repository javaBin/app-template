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
3. Ensure your team is registered in [javaBin/registry](https://github.com/javaBin/registry) (`teams/{name}.yaml`) and add the repo to your GitHub team
4. Push to `main` — the platform CI builds, plans, reviews, and deploys automatically

## app.yaml Fields

- `name` — service name (required, lowercase + hyphens, max 20 chars)
- `team` — owning team, must exist in the registry (required)
- `compute` — CPU, memory, port, desired count, health check path
- `routing` — hostname under `javazone.no` and ALB priority
- `resources` — S3 buckets, DynamoDB tables, Secrets Manager secrets, SQS queues
- `auth` — Cognito integration: `internal`, `external`, `both`, or `none`
- `environment` — custom environment variables
- `budget_alert_nok` — monthly budget alert threshold in NOK

Full reference: [app.yaml reference](https://github.com/javaBin/platform/blob/main/docs/app-yaml-reference.md)

## Dockerfile

The default Dockerfile uses `eclipse-temurin:21` for a Java/Maven project. Replace it with your own if you use a different runtime (Node.js, Go, Python, etc.).

## CI

This template includes `.github/workflows/deploy.yml` which calls the platform's reusable workflow `javaBin/platform/.github/workflows/javabin.yml@main`. No additional workflow config needed.

## Related

- [javaBin/platform](https://github.com/javaBin/platform) — shared infrastructure and reusable modules
- [javaBin/registry](https://github.com/javaBin/registry) — team registration
- [javaBin/javabin-cli](https://github.com/javaBin/javabin-cli) — `javabin register` automates team registration
