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
