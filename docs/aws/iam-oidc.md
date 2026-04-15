# IAM & OIDC Configuration

This document describes the IAM role and OIDC setup used to allow GitHub 
Actions workflows to authenticate with AWS without storing long-lived 
access keys.

---

## Overview

Instead of using static AWS access keys stored as GitHub secrets, the CI/CD 
pipelines use OpenID Connect (OIDC) to request short-lived credentials at 
runtime. GitHub Actions requests a token from AWS, assumes an IAM role, and 
receives temporary credentials valid only for the duration of the workflow run.

---

## IAM Role

**Role name:** `github-actions-developer`  
**Role ARN:** `arn:aws:iam::225989372262:role/github-actions-developer`  
**Created:** February 16, 2026  
**Maximum session duration:** 1 hour

### Attached Policies

| Policy | Type | Description |
|---|---|---|
| `AdministratorAccess-AWSElasticBean...` | AWS managed | Full access to Elastic Beanstalk |
| `AmazonS3FullAccess` | AWS managed | Full access to S3 |
| `AWSElasticBeanstalkCustomPlatfor...` | AWS managed | Custom platform support for EB |
| `CloudFrontFullAccess` | AWS managed | Full access to CloudFront |

---

