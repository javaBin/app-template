# My Service

A Javabin platform service.

## Getting Started

1. **Create from template**: Click "Use this template" on GitHub (repo under `javaBin/`)
2. **Register your team**: If not already registered, open a PR to [javaBin/registry](https://github.com/javaBin/registry) adding `teams/<team>.yaml` (or run `javabin register-team`). Merging creates the GitHub team and the team's AWS CI roles; members sign in to AWS with the SSO permission set `javabin-team-<team>`. Team names are lowercase letters only, max 12 chars.
3. **Add this repo to your GitHub team** — the one named in `app.yaml` `team:`; CI refuses to deploy otherwise:
   `gh api -X PUT orgs/javaBin/teams/<team>/repos/javaBin/<repo> -f permission=push`
4. **Customize `app.yaml`**: Set your service name, team, compute, routing, and any resources/auth
5. **Push to main**: The platform CI pipeline builds, plans, reviews, and deploys automatically. Pull requests get a Terraform plan and review comment.

No repository secrets are needed. `.github/workflows/deploy.yml` must keep its `permissions:` block (`id-token: write`, `contents: write`, `pull-requests: write`). Its `if:` only stops the template repo itself from deploying; it is true in your repo.

## Secrets

`resources.secrets` entries are created with the value `PLACEHOLDER` on the first deploy. Set real values with the [javabin CLI](https://github.com/javaBin/javabin-cli) from this repo:

```bash
brew install javaBin/tap/javabin
javabin aws setup              # SSO sign-in with javabin-team-<team>
javabin secret list            # which secrets still hold PLACEHOLDER
javabin secret set api-key     # prompts without echo; --stdin to pipe
```

The service restarts automatically within a minute to pick up the new value.

## Platform Features

- Automatic Docker build and ECR push
- Terraform infrastructure from `app.yaml` (S3, DynamoDB, RDS PostgreSQL, SQS, SSM secrets, Cognito clients)
- LLM-powered plan review with risk gating
- ECS Fargate deployment with health checks and circuit-breaker rollback
- CloudWatch alarms; budgets per team (set in the registry)

## References

- [app.yaml reference](https://github.com/javaBin/platform/blob/main/docs/app-yaml-reference.md)
- [Reusable workflows](https://github.com/javaBin/platform/blob/main/docs/reusable-workflows.md)
- [Platform documentation](https://github.com/javaBin/platform)
- [Registry](https://github.com/javaBin/registry)
