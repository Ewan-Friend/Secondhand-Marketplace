# AWS Infrastructure

This document describes the AWS infrastructure used to host the Secondhand
Marketplace application.

---

## Overview

The application is split into two separately hosted components:

- **Frontend** — Flutter web app, hosted on Amazon S3 and served via CloudFront
- **Backend** — Flask API, hosted on AWS Elastic Beanstalk

CloudFront sits in front of both, routing requests to the correct origin based
on the request path.

---

## Architecture
User
│
▼
CloudFront Distribution (sepsecondhand.co.uk)
├── /api/*      ──────────────────► Elastic Beanstalk (Flask API)
├── /static/*   ──────────────────► S3 Bucket (static assets)
└── /* (default)──────────────────► S3 Bucket (Flutter Web)

---

## S3 — Frontend Hosting

The Flutter web app is built and uploaded to an S3 bucket. The bucket is
not publicly accessible — all traffic is routed through CloudFront.

**Bucket name:** `secondhand-marketplace-frontend`  
**Region:** `eu-north-1`

Files uploaded to this bucket include the Flutter web build output:
`index.html`, `flutter.js`, `flutter_bootstrap.js`, `assets/`, `canvaskit/`, and `icons/`.

Files are synced on every deployment using:
```bash
aws s3 sync build/web s3://secondhand-marketplace-frontend --delete
```

The `--delete` flag ensures stale files from previous builds are removed.

---

## Elastic Beanstalk — Backend Hosting

The Flask backend is deployed to AWS Elastic Beanstalk as a zip package.

**Application name:** `secondhand-backend`  
**Environment name:** `Secondhand-backend-env-1`  
**Region:** `eu-north-1`  
**Platform:** Python 3.11

Each deployment creates a new application version labelled with the Git
commit SHA. The deployment package is first uploaded to a dedicated S3 bucket,
then Elastic Beanstalk pulls it from there.

---

## CloudFront — CDN and Routing

CloudFront serves as the single entry point for all traffic. It connects the
frontend and backend under a single domain and handles HTTPS termination.

**Distribution name:** `secondhand-marketplace`  
**Distribution ID:** `EI5GOW9Z7EGEN`  
**CloudFront domain:** `d3q8niu6xns970.cloudfront.net`  
**Custom domain:** `sepsecondhand.co.uk`  
**SSL certificate:** `sepsecondhand.co.uk` (TLSv1.3_2025)  
**Default root object:** `index.html`

### Origins

| Origin name | Origin type | Description |
|---|---|---|
| `secondhand-backend-en` | Elastic Beanstalk | Flask API backend |
| `secondhand-marketplace` | S3 | Flutter web frontend |

### Behaviors

| Precedence | Path pattern | Origin | Viewer protocol | Cache policy |
|---|---|---|---|---|
| 0 | `/api/*` | Elastic Beanstalk | Redirect HTTP to HTTPS | CachingDisabled |
| 1 | `/static/*` | S3 | Redirect HTTP to HTTPS | CachingOptimized |
| 2 | `*` (default) | S3 | Redirect HTTP to HTTPS | CachingOptimized |

> ⚠️ The Flutter app must use `/api` as the `API_BASE_URL` at build time —
> not the direct Elastic Beanstalk URL. Using the EB URL directly bypasses
> CloudFront and causes HTTP/HTTPS errors. See the
> [CI/CD documentation](../workflows/ci-cd.md) for more details.

---

