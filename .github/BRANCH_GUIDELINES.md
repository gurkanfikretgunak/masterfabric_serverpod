# Branch Guidelines Quick Reference

Quick reference for branch naming conventions and branching strategy.

## Format

```
<type>/<scope>-<description>
```

## Branch Types

| Type | Prefix | Example |
|------|--------|---------|
| Feature | `feature/` | `feature/auth-add-oauth2` |
| Bug Fix | `bugfix/` or `fix/` | `bugfix/session-expiration` |
| Hotfix | `hotfix/` | `hotfix/auth-security-patch` |
| Documentation | `docs/` | `docs/api-endpoints` |
| Refactoring | `refactor/` | `refactor/integration-manager` |
| Performance | `perf/` | `perf/db-query-optimization` |
| Testing | `test/` | `test/auth-unit-tests` |
| Chore | `chore/` | `chore/update-dependencies` |
| Release | `release/` | `release/v1.2.0` |

## Common Scopes

- `auth` - Authentication
- `session` - Session management
- `api` - API endpoints
- `config` - Configuration
- `db` - Database
- `integration` - Integrations
- `scheduler` - Scheduling
- `client` - Client package
- `server` - Server package
- `flutter` - Flutter app
- `ci` - CI/CD
- `docs` - Documentation

## Examples

```bash
# Feature
git checkout -b feature/auth-add-email-verification
git checkout -b feature/api-user-endpoints

# Bug fix
git checkout -b bugfix/session-handle-expired-tokens
git checkout -b fix/db-connection-pool

# Documentation
git checkout -b docs/api-update-endpoint-docs

# Refactoring
git checkout -b refactor/integration-manager-simplify

# Performance
git checkout -b perf/db-optimize-user-query

# Hotfix
git checkout -b hotfix/auth-security-vulnerability

# Testing
git checkout -b test/auth-add-unit-tests

# Chore
git checkout -b chore/update-serverpod-version

# Release
git checkout -b release/v1.2.0
```

## Quick Workflow

```bash
# 1. Update main
git checkout main
git pull origin main

# 2. Create branch
git checkout -b feature/auth-add-oauth2

# 3. Make changes and commit
git add .
git commit -m "feat(auth): Add OAuth2 login"

# 4. Push branch
git push -u origin feature/auth-add-oauth2

# 5. After merge, clean up
git checkout main
git pull origin main
git branch -d feature/auth-add-oauth2
```

## Rules

- ✅ Use kebab-case (lowercase with hyphens)
- ✅ Include type prefix
- ✅ Be descriptive but concise
- ✅ Keep branches focused on single purpose
- ✅ Delete branches after merge
- ❌ Don't use uppercase
- ❌ Don't use underscores
- ❌ Don't use vague names
- ❌ Don't work directly on main

For detailed guidelines, see [CONTRIBUTING.md](../CONTRIBUTING.md#branch-guidelines).
