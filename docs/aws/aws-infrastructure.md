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
