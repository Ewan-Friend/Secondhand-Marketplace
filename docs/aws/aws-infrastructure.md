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

```
User
 │
 ▼
CloudFront Distribution (sepsecondhand.co.uk)
 ├── /api/*       ──────────────────► Elastic Beanstalk (Flask API)
 ├── /static/*    ──────────────────► S3 Bucket (static assets)
 └── /* (default) ──────────────────► S3 Bucket (Flutter Web)
```
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
| `secondhand-backend-env-1.eba-jx9gv23c.eu-north-1.elasticbeanstalk.com` | Elastic Beanstalk | Flask API backend |
| `secondhand-marketplace-frontend.s3.eu-north-1.amazonaws.com-mlpc1pxnspm` | S3 | Flutter web frontend |

### Behaviors

| Precedence | Path pattern | Origin | Viewer protocol | Cache policy |
|---|---|---|---|---|
| 0 | `/api/*` | Elastic Beanstalk | Redirect HTTP to HTTPS | CachingDisabled |
| 1 | `/static/*` | S3 | Redirect HTTP to HTTPS | CachingOptimized |
| 2 | `*` (default) | S3 | Redirect HTTP to HTTPS | CachingOptimized |

> [!WARNING]
>
> `API_BASE_URL` must be set to `/api`. Setting it to a direct Elastic Beanstalk URL will bypass CloudFront and cause HTTP/HTTPS errors. See the [CI/CD documentation](../workflows/ci-cd.md) for more details.

---

## Deployment Flow

### Frontend
1. Flutter web app is built with `flutter build web --release`
2. Build output is synced to the S3 bucket (`secondhand-marketplace-frontend`)
3. CloudFront cache is invalidated (`/*`)
4. Deployment is verified by checking `https://www.sepsecondhand.co.uk/index.html` returns HTTP 200

### Backend
1. Backend code is zipped (excluding tests, pycache, and git files)
2. Zip is uploaded to the backend S3 bucket with the commit SHA as the filename
3. A new Elastic Beanstalk application version is created with the commit SHA as the version label
4. The EB environment is updated to the new version
5. Pipeline waits for the environment health to become `Green` before completing