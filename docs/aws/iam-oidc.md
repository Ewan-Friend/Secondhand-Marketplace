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

## Trust Policy

The trust policy restricts which GitHub Actions workflows can assume this role. 
Only workflows running from the `spe-uob/2025-SecondhandMarketplace` repository 
are allowed.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::225989372262:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:spe-uob/2025-SecondhandMarketplace:*"
        }
      }
    }
  ]
}
```

---

## OIDC Identity Provider

**Provider URL:** `https://token.actions.githubusercontent.com`  
**Audience:** `sts.amazonaws.com`

This provider was registered in IAM to establish trust between GitHub Actions 
and AWS. It allows GitHub to issue tokens that AWS can verify.

---

## Usage in Workflows

The role is assumed in workflows using the `aws-actions/configure-aws-credentials` 
action. The role ARN is stored as a GitHub Actions variable (`AWS_ROLE_ARN`) 
rather than a secret, as it is not sensitive.

```yaml
- name: Configure AWS credentials (OIDC)
  uses: aws-actions/configure-aws-credentials@v4
  with:
    role-to-assume: ${{ vars.AWS_ROLE_ARN }}
    aws-region: ${{ vars.AWS_REGION }}
```

The workflow must also have the following permissions to request the OIDC token:

```yaml
permissions:
  id-token: write
  contents: read
```

This configuration is used in both `deploy-web.yml` and `backend-cd.yml`. 
See the [CI/CD documentation](../workflows/ci-cd.md) for more details.