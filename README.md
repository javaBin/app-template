# My Service

A Javabin platform service.

## Getting Started

1. **Create from template**: Click "Use this template" on GitHub
2. **Register your team**: If not already registered, open a PR to [javaBin/registry](https://github.com/javaBin/registry) adding `teams/your-team.yaml` (or run `javabin register-team`). Merging creates the GitHub team and the team's AWS CI roles.
3. **Add this repo to your GitHub team** — the one named in `app.yaml` `team:`:
   `gh api -X PUT orgs/javaBin/teams/<team>/repos/javaBin/<repo> -f permission=push`
4. **Customize `app.yaml`**: Set your service name, team, compute, and routing
5. **Push to main**: The platform CI pipeline builds, plans, reviews, and deploys automatically

No repository secrets are needed. `.github/workflows/deploy.yml` must keep its `permissions:` block (`id-token`, `contents: write`, `pull-requests`).

## Platform Features

- Automatic Docker build and ECR push
- Terraform infrastructure from `app.yaml` (S3, DynamoDB, RDS PostgreSQL, SQS, SSM secrets, Cognito clients)
- LLM-powered plan review with risk gating
- ECS Fargate deployment with health checks
- CloudWatch alarms and cost monitoring

## References

- [app.yaml reference](https://github.com/javaBin/platform/blob/main/docs/app-yaml-reference.md)
- [Platform documentation](https://github.com/javaBin/platform)
- [Registry](https://github.com/javaBin/registry)
