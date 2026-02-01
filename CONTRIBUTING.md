# Contributing to MasterFabric Serverpod

Thank you for your interest in contributing to MasterFabric Serverpod! This document provides guidelines and rules for contributing to this project.

## Code of Conduct

- Be respectful and considerate of others
- Welcome newcomers and help them learn
- Focus on constructive feedback
- Respect different viewpoints and experiences

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/masterfabric_serverpod.git`
3. Create a new branch following [branch naming conventions](#branch-guidelines): `git checkout -b feature/your-feature-name` or `bugfix/your-bug-fix`
4. Make your changes
5. Test your changes thoroughly
6. Commit your changes using [semantic commit messages](#commit-guidelines)
7. Push to your fork: `git push origin feature/your-feature-name`
8. Create a Pull Request

**Quick References:**
- [Branch Guidelines Quick Reference](.github/BRANCH_GUIDELINES.md)
- [Commit Guidelines Quick Reference](.github/COMMIT_GUIDELINES.md)

## Pull Request Rules

### Before Submitting

- [ ] Ensure your code follows the project's style guidelines
- [ ] Run `dart analyze` and fix any issues
- [ ] Run `dart format` to ensure consistent formatting
- [ ] Run `serverpod generate` if you modified models or endpoints
- [ ] Write or update tests for your changes
- [ ] Ensure all tests pass locally
- [ ] Update documentation if needed
- [ ] Check that CI checks pass

### PR Requirements

1. **Clear Description**: Provide a clear description of what the PR does and why
2. **Related Issues**: Link to any related issues using `Closes #issue` or `Related to #issue`
3. **Type Label**: Use appropriate labels (bug, feature, documentation, etc.)
4. **Small PRs**: Keep PRs focused on a single feature or fix. Large changes should be broken into smaller PRs
5. **Tests**: Include tests for new features or bug fixes
6. **Documentation**: Update relevant documentation
7. **No Breaking Changes**: Avoid breaking changes unless absolutely necessary and clearly documented

### PR Review Process

1. All PRs require at least one approval before merging
2. PRs must pass all CI checks (analyze, tests, format)
3. Address all review comments before requesting re-review
4. Maintainers may request changes or ask questions
5. Be responsive to feedback and open to suggestions

### PR Title Format

Use a clear, descriptive title:
- `feat: Add user authentication endpoint`
- `fix: Resolve session timeout issue`
- `docs: Update setup instructions`
- `refactor: Simplify integration manager`

## Issue Rules

### Before Creating an Issue

1. **Search First**: Check if a similar issue already exists
2. **Use Templates**: Use the appropriate issue template (bug, feature, question)
3. **Provide Context**: Include relevant information, logs, and steps to reproduce

### Bug Reports

- Use the bug report template
- Provide clear steps to reproduce
- Include error messages and logs
- Specify your environment (OS, Dart/Flutter versions)
- Add screenshots if applicable

### Feature Requests

- Use the feature request template
- Clearly describe the problem and proposed solution
- Provide use cases and examples
- Consider alternatives

### Questions

- Use the question template
- Check documentation first
- Provide context about what you've tried
- Be specific about what you need help with

## Commit Guidelines

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification for our commit messages. This ensures a consistent commit history and enables automated versioning and changelog generation.

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Structure

- **Type** (required): What kind of change this is
- **Scope** (optional): What part of the codebase is affected
- **Subject** (required): Short description of the change (imperative mood, lowercase, no period)
- **Body** (optional): Detailed explanation of the change
- **Footer** (optional): Breaking changes, issue references

### Commit Types

| Type | Description | Example |
|------|-------------|---------|
| `feat` | A new feature | `feat(auth): Add OAuth2 login` |
| `fix` | A bug fix | `fix(session): Handle expired tokens` |
| `docs` | Documentation only changes | `docs(readme): Update setup instructions` |
| `style` | Code style changes (formatting, missing semicolons, etc.) | `style: Format code with dart format` |
| `refactor` | Code refactoring without changing functionality | `refactor(api): Simplify endpoint structure` |
| `perf` | Performance improvements | `perf(db): Optimize query performance` |
| `test` | Adding or updating tests | `test(auth): Add unit tests for login` |
| `build` | Changes to build system or dependencies | `build: Update serverpod to 3.2.3` |
| `ci` | Changes to CI configuration | `ci: Add Flutter tests workflow` |
| `chore` | Other changes (maintenance, tooling) | `chore: Update dependencies` |
| `revert` | Revert a previous commit | `revert: Revert "feat: Add feature X"` |

### Scopes

Scopes help identify which part of the codebase is affected. Common scopes:

- `auth` - Authentication related
- `session` - Session management
- `api` - API endpoints
- `config` - Configuration management
- `db` - Database related
- `integration` - Third-party integrations
- `scheduler` - Scheduled tasks
- `client` - Client package
- `server` - Server package
- `flutter` - Flutter app
- `deps` - Dependencies
- `ci` - CI/CD
- `docs` - Documentation

### Subject Guidelines

- Use imperative mood: "Add feature" not "Added feature" or "Adds feature"
- Lowercase (except for proper nouns)
- No period at the end
- Maximum 72 characters
- Be specific and clear

### Body Guidelines

- Explain **what** and **why** vs. **how**
- Wrap at 72 characters
- Use present tense
- Can include multiple paragraphs
- Reference issues/PRs

### Footer Guidelines

- Reference issues: `Closes #123`, `Fixes #456`, `Related to #789`
- Breaking changes: `BREAKING CHANGE: <description>`
- Multiple footers allowed

### Breaking Changes

If your commit introduces breaking changes, add `BREAKING CHANGE:` in the footer:

```
feat(api): Change authentication endpoint structure

BREAKING CHANGE: The /auth/login endpoint now requires email instead of username.
Migration guide available in docs/migration.md.

Closes #123
```

Or use `!` after the type/scope:

```
feat(api)!: Change authentication endpoint structure
```

### Examples

#### Feature with scope
```
feat(auth): Add email verification endpoint

Add endpoint for verifying user email addresses during registration.
Includes rate limiting and validation.

Closes #123
```

#### Bug fix
```
fix(session): Resolve session expiration issue

Session manager was not properly handling TTL expiration.
Now correctly invalidates sessions after timeout.

Fixes #456
```

#### Breaking change
```
feat(api)!: Change response format for app config endpoint

BREAKING CHANGE: The app config endpoint now returns a nested structure
instead of flat key-value pairs. Update client code accordingly.

Migration:
- Old: response['feature_flag']
- New: response['features']['flags']['feature_flag']

Closes #789
```

#### Documentation
```
docs(readme): Add setup instructions for Docker

Add detailed steps for setting up PostgreSQL and Redis using Docker Compose.
Includes troubleshooting section.
```

#### Refactoring
```
refactor(integration): Simplify integration manager initialization

Extract initialization logic into separate methods for better testability.
No functional changes.
```

#### Multiple scopes
```
feat(auth, session): Add token refresh mechanism

Add automatic token refresh when session is about to expire.
Improves user experience by reducing forced logouts.
```

#### Simple fix (no body needed)
```
fix: Correct typo in error message
```

### Commit Message Best Practices

✅ **Do:**
- Write clear, descriptive commit messages
- Use present tense ("Add feature" not "Added feature")
- Keep the subject line under 72 characters
- Explain the "why" in the body when needed
- Reference related issues
- Use appropriate types and scopes

❌ **Don't:**
- Write vague messages like "Fix bug" or "Update code"
- Mix multiple unrelated changes in one commit
- Use past tense ("Fixed bug")
- Write overly long subject lines
- Forget to run `serverpod generate` before committing model changes

### Commit Workflow

1. Stage your changes: `git add .`
2. Write a semantic commit message: `git commit -m "type(scope): subject"`
3. For detailed messages, use: `git commit` (opens editor)
4. Push to your branch: `git push origin feature/your-feature-name`

## Branch Guidelines

### Branch Naming Convention

We use a consistent branch naming convention to organize work and make it easy to understand the purpose of each branch.

#### Format

```
<type>/<scope>-<description>
```

- **Type**: The type of work (required)
- **Scope**: What part of the codebase is affected (optional)
- **Description**: Brief description using kebab-case (required)

#### Branch Types

| Type | Prefix | Description | Example |
|------|--------|-------------|---------|
| Feature | `feature/` | New features or enhancements | `feature/auth-add-oauth2` |
| Bug Fix | `bugfix/` or `fix/` | Bug fixes | `bugfix/session-expiration` |
| Hotfix | `hotfix/` | Critical production fixes | `hotfix/auth-security-patch` |
| Documentation | `docs/` | Documentation updates | `docs/api-endpoints` |
| Refactoring | `refactor/` | Code refactoring | `refactor/integration-manager` |
| Performance | `perf/` | Performance improvements | `perf/db-query-optimization` |
| Testing | `test/` | Adding or updating tests | `test/auth-unit-tests` |
| Chore | `chore/` | Maintenance tasks | `chore/update-dependencies` |
| Release | `release/` | Release preparation | `release/v1.2.0` |

#### Scopes

Use scopes to indicate which part of the codebase is affected:

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

#### Examples

✅ **Good branch names:**
```bash
feature/auth-add-email-verification
bugfix/session-handle-expired-tokens
docs/api-update-endpoint-docs
refactor/integration-manager-simplify
perf/db-optimize-user-query
hotfix/auth-security-vulnerability
test/auth-add-unit-tests
chore/update-serverpod-version
```

❌ **Bad branch names:**
```bash
my-feature              # Missing type prefix
feature                 # Missing description
Feature/Auth           # Wrong case, should be lowercase
feature_auth_login     # Should use hyphens, not underscores
fix-bug                # Too vague
update                 # Missing type and too vague
```

### Branching Strategy

#### Main Branches

- **`main`**: Production-ready code. Always stable and deployable.
- **`develop`** (optional): Integration branch for ongoing development (if using Git Flow)

#### Feature Branches

- Branch from: `main` (or `develop` if using Git Flow)
- Merge to: `main` via Pull Request
- Naming: `feature/<scope>-<description>`
- Lifecycle: Delete after merge

#### Bug Fix Branches

- Branch from: `main` (or `develop` if using Git Flow)
- Merge to: `main` via Pull Request
- Naming: `bugfix/<scope>-<description>` or `fix/<scope>-<description>`
- Lifecycle: Delete after merge

#### Hotfix Branches

- Branch from: `main`
- Merge to: `main` and `develop` (if exists)
- Naming: `hotfix/<scope>-<description>`
- Use for: Critical production issues that need immediate fixes
- Lifecycle: Delete after merge

#### Release Branches

- Branch from: `main` or `develop`
- Naming: `release/v<version>` (e.g., `release/v1.2.0`)
- Use for: Preparing new releases
- Lifecycle: Delete after release

### Branch Workflow

1. **Create Branch**
   ```bash
   # Update main branch
   git checkout main
   git pull origin main
   
   # Create feature branch
   git checkout -b feature/auth-add-oauth2
   ```

2. **Work on Branch**
   - Make your changes
   - Commit frequently with semantic commit messages
   - Push regularly to backup your work

3. **Keep Branch Updated**
   ```bash
   # While on your feature branch
   git fetch origin
   git rebase origin/main
   # Or merge instead of rebase:
   git merge origin/main
   ```

4. **Push Branch**
   ```bash
   git push origin feature/auth-add-oauth2
   # First time? Use:
   git push -u origin feature/auth-add-oauth2
   ```

5. **Create Pull Request**
   - Open PR on GitHub
   - Link related issues
   - Request review

6. **After Merge**
   ```bash
   # Switch back to main
   git checkout main
   git pull origin main
   
   # Delete local branch
   git branch -d feature/auth-add-oauth2
   
   # Delete remote branch (if not auto-deleted)
   git push origin --delete feature/auth-add-oauth2
   ```

### Branch Best Practices

✅ **Do:**
- Use descriptive branch names that explain the purpose
- Keep branches focused on a single feature or fix
- Keep branches up to date with `main`
- Delete branches after they're merged
- Use kebab-case for branch names
- Include scope when relevant
- Keep branch names concise but descriptive

❌ **Don't:**
- Use vague or generic names
- Mix multiple unrelated features in one branch
- Use special characters except hyphens
- Use uppercase letters
- Work directly on `main` branch
- Let branches become stale
- Create branches with typos or unclear names

### Branch Length Guidelines

- **Minimum**: Be descriptive enough to understand the purpose
- **Maximum**: Keep under 50 characters when possible
- **Balance**: Clear enough for others to understand, short enough to type

### Branch Scope Guidelines

- Use scope when the change affects a specific area
- Omit scope for general changes
- Match scope to commit message scopes when possible

### Examples by Scenario

**Adding a new feature:**
```bash
git checkout -b feature/auth-add-email-verification
```

**Fixing a bug:**
```bash
git checkout -b bugfix/session-expiration-handling
```

**Updating documentation:**
```bash
git checkout -b docs/api-add-endpoint-examples
```

**Refactoring code:**
```bash
git checkout -b refactor/integration-manager-simplify
```

**Critical production fix:**
```bash
git checkout -b hotfix/auth-security-patch
```

**Preparing a release:**
```bash
git checkout -b release/v1.2.0
```

## Development Workflow

1. **Create Branch**: Create a feature branch from `main` following [branch naming conventions](#branch-guidelines)
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make Changes**: Make your changes following the code style

3. **Generate Code**: If you modified models/endpoints
   ```bash
   cd masterfabric_serverpod_server
   serverpod generate
   ```

4. **Run Tests**: Ensure all tests pass
   ```bash
   cd masterfabric_serverpod_server
   dart test
   ```

5. **Check Code Quality**:
   ```bash
   dart analyze
   dart format .
   ```

6. **Commit**: Write a clear commit message
   ```bash
   git add .
   git commit -m "feat: Add your feature"
   ```

7. **Push**: Push to your fork
   ```bash
   git push origin feature/your-feature-name
   ```

8. **Create PR**: Open a pull request on GitHub

## Code Style

- Follow Dart style guidelines: https://dart.dev/guides/language/effective-dart/style
- Use `dart format` to format code
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions focused and small
- Write self-documenting code when possible

## Testing Guidelines

- Write tests for new features
- Write tests for bug fixes
- Aim for good test coverage
- Test edge cases and error conditions
- Ensure tests are independent and repeatable

## Documentation

- Update README.md if you add new features or change setup
- Add code comments for complex logic
- Update API documentation if you modify endpoints
- Keep examples up to date

## Questions?

If you have questions about contributing:

- Check existing issues and PRs
- Review the Serverpod documentation: https://docs.serverpod.dev
- Open a question issue using the question template

---

## License

By contributing to this project, you agree that your contributions will be licensed under the **GNU Affero General Public License v3.0 (AGPL-3.0)**.

[![License: AGPL v3](https://img.shields.io/badge/License-AGPL%20v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)

### Important Notes

- All contributions must be compatible with the AGPL-3.0 license
- By submitting code, you certify that you have the right to submit it under this license
- Contributions become part of the MasterFabric codebase and are subject to all license terms
- If you fork this repository, you must contact MASTERFABRIC within 10 days (see [LICENSE](LICENSE))

### Copyright

**Copyright (C) 2024 MASTERFABRIC Bilişim Teknolojileri A.Ş. (MASTERFABRIC Information Technologies Inc.)**

- **Owner:** Gürkan Fikret Günak (@gurkanfikretgunak)
- **Website:** https://masterfabric.co
- **License Contact:** license@masterfabric.co

For full license terms, see the [LICENSE](LICENSE) file.

---

Thank you for contributing! 🎉
