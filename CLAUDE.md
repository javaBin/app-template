# CLAUDE.md — Javabin App Template

GitHub template repository for creating new services on the Javabin platform.

## What This Template Provides

| File | Purpose |
|------|---------|
| `app.yaml` | Platform service configuration — compute, routing, resources, auth |
| `Dockerfile` | Multi-stage build (Java/Temurin by default, adapt for your runtime); runs as user 1000 |
| `pom.xml`, `mvnw`, `.mvn/`, `src/` | Minimal Spring Boot 4 app (Java 21): `GET /` and `GET /actuator/health` on port 8080 |
| `.github/workflows/deploy.yml` | CI entrypoint — calls `javabin.yml` reusable workflow |
| `README.md` | Starter README with getting-started steps |

## How to Use

1. Click **"Use this template"** on GitHub to create a new repo under `javaBin/`
2. Ensure your team is registered in [javaBin/registry](https://github.com/javaBin/registry) (`teams/{name}.yaml`) and add the repo to the GitHub team named in `app.yaml` `team:` before the first push to `main` (CI verifies repo → team before vending credentials): `gh api -X PUT orgs/javaBin/teams/<team>/repos/javaBin/<repo> -f permission=push`
3. Edit `app.yaml` — set your service name, team, compute settings, routing, and any resources
4. Push to `main` — the platform CI builds, plans, reviews, and deploys automatically
5. Set any secret values: `brew install javaBin/tap/javabin`, `javabin aws setup` (SSO permission set `javabin-team-<team>`), then `javabin secret set <name>`

## app.yaml Fields

- `name` — service name (required, lowercase + hyphens, max 20 chars)
- `team` — owning team, lowercase letters only (max 12), must exist in the registry (required)
- `compute` — CPU, memory, port, desired count, health check path (template: `/actuator/health`, what Spring Boot Actuator serves), `user` (default `"1000"`), `readonly_root_filesystem` (default `true`; only `/tmp` writable)
- `routing` — hostname one label under `javazone.no`, `java.no` or `javabin.no`, and optional ALB `priority` (the template omits it so the platform derives a unique one; a shared hard-coded value collides with `PriorityInUse`)
- `resources` — S3 buckets, DynamoDB tables / RDS PostgreSQL, SSM secrets (created as `PLACEHOLDER`, set with `javabin secret set`), SQS queues
- `auth` — Cognito: `internal`/`external` shorthand, or full form with `client: confidential|public|none`, `callback_urls` (https or `http://localhost`), `groups` (restricts sign-in), `env` (alias injected names)
- `environment` — custom environment variables

Unknown fields fail the pipeline's `expand` step. Budgets are per team, set in the registry.

Full reference: [app.yaml reference](https://github.com/javaBin/platform/blob/main/docs/app-yaml-reference.md)

## Dockerfile

The default Dockerfile builds the bundled Spring Boot app with `./mvnw` on `eclipse-temurin:21` and runs the jar as user 1000 on port 8080. The platform runs containers non-root with a read-only root filesystem, so the app may only write to `/tmp`. Replace the Dockerfile if you use a different runtime (Node.js, Go, Python, etc.) and keep those rules.

Check a change locally: `./mvnw verify`, then `docker build -t t . && docker run --rm -p 8080:8080 --read-only --tmpfs /tmp t` and `curl localhost:8080/actuator/health`.

## CI

This template includes `.github/workflows/deploy.yml` which calls the platform's reusable workflow `javaBin/platform/.github/workflows/javabin.yml@main`. No secrets are needed; keep the `permissions:` block (`id-token: write`, `contents: write`, `pull-requests: write`). The job's `if: github.repository != 'javaBin/app-template'` keeps the template itself from deploying; generated repos have another name, so it runs there.

Validate `app.yaml` locally against the generator from a platform checkout:
`GITHUB_WORKSPACE=. APP_SERVICE=my-service AWS_ACCOUNT_ID=553637109631 TF_ROOT=/tmp/gen python3 -I ../platform/scripts/generate-modules.py`

## Related

- [javaBin/platform](https://github.com/javaBin/platform) — shared infrastructure and reusable modules
- [javaBin/registry](https://github.com/javaBin/registry) — team registration
- [javaBin/javabin-cli](https://github.com/javaBin/javabin-cli) — `javabin register-team`, `javabin aws setup`, `javabin secret set`
