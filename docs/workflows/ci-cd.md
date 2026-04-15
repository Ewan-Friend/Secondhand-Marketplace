# CI/CD Workflows

This document describes the GitHub Actions workflows used to automate testing, 
deployment, and quality checks for the Secondhand Marketplace project.

---

## Overview

| Workflow | File | Trigger |
|---|---|---|
| PR Formatting Check | `pr-formatting-ci.yml` | Pull request to `dev` |
| Flutter CI | `flutter-ci.yml` | Push/PR to `dev` or `main` |
| Flask CI | `flask-ci.yml` | Push/PR to `dev` or `main` |
| Deploy Web | `deploy-web.yml` | Push to `dev` |
| Backend CD | `backend-cd.yml` | Push to `dev` |
| Publish Docs | `mkdocs-cd.yml` | Push to `dev` or `main` |

---

## Continuous Integration

### PR Formatting Check (`pr-formatting-ci.yml`)

Runs on every pull request opened, edited, or synchronized against `dev`. 
Enforces three rules before a PR can be merged:

**Title format** — PR titles must follow the pattern `[ABC]: Description`, 
for example `[FEAT]: Add search functionality`. The check uses a regex 
`^\[[A-Z]+\]: .+` and fails if the title does not match.

**Closing tag** — The PR body must include a closing reference to an issue, 
such as `Closes #123`, `Fixes #123`, or `Resolves #123`. This ensures every 
PR is linked to a tracked issue.

**Type of change** — The PR body must have at least one type of change 
checkbox ticked (e.g. `[x] Feature`). This is checked by scanning the 
lines following the "Type of Change" header for a checked box.

---

### Flutter CI (`flutter-ci.yml`)

Runs on pushes and pull requests to `dev` or `main` when files inside 
`application/` are changed. Uses Flutter 3.35.7 stable with SDK caching 
enabled to speed up runs.

Steps:
1. Checkout code
2. Set up Flutter with caching
3. Install dependencies (`flutter pub get`)
4. Analyze project (`flutter analyze`)
5. Run tests (`flutter test`)

---

### Flask CI (`flask-ci.yml`)
