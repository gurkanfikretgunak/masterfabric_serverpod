# Commit Guidelines Quick Reference

Quick reference for semantic commit messages following [Conventional Commits](https://www.conventionalcommits.org/).

## Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

## Types

- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation
- `style` - Formatting, style changes
- `refactor` - Code refactoring
- `perf` - Performance improvement
- `test` - Tests
- `build` - Build system
- `ci` - CI/CD
- `chore` - Maintenance
- `revert` - Revert commit

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

## Examples

```bash
# Feature
git commit -m "feat(auth): Add OAuth2 login"

# Bug fix
git commit -m "fix(session): Handle expired tokens"

# Breaking change
git commit -m "feat(api)!: Change response format"

# With body and footer
git commit -m "feat(auth): Add email verification

Add endpoint for verifying user email addresses.
Includes rate limiting and validation.

Closes #123"
```

## Rules

- ✅ Use imperative mood ("Add" not "Added")
- ✅ Lowercase subject (except proper nouns)
- ✅ No period at end of subject
- ✅ Max 72 characters for subject
- ✅ Reference issues in footer
- ❌ Don't mix unrelated changes
- ❌ Don't write vague messages

For detailed guidelines, see [CONTRIBUTING.md](../CONTRIBUTING.md#commit-guidelines).
