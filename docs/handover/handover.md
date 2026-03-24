# Secondhand Marketplace Handover

## Contents
[Introduction](#introduction)

## Introduction
This document is designed to give detailed information on certain aspects of the project: If a new developer were to begin working on it. 

The majority of need-to-know, high-level information will be outlined within this document, with more fine grain details being outlined within code comments left throughout the projects codebase.

## Project Setup
- [Prerequisites](#prerequisite-downloads)
- [Environment setup](#setup-development-environment)
- [Frontend](#frontend-environment)
- [Backend](#backend-environment)
- [Documentation](#optional-mkdocs-documentation-server)

### Prerequisite Downloads
- [Python 3.xx](https://www.python.org/downloads/) (currently 3.16)
- [Flutter](https://docs.flutter.dev/install)
- [Docker](https://docs.docker.com/engine/install/)

Of course you also need to clone the repository:

- Using **HTTPS URL**:
  - `git clone https://github.com/spe-uob/2025-SecondhandMarketplace.git`

- Using **SSH**:
  - `git clone git@github.com:spe-uob/2025-SecondhandMarketplace.git`

### Setup Development Environment

In order for the project to run, these constants must be declared within a `.env` file

```env
SUPABASE_URL= "..." # Supabase project URL
SUPABASE_KEY= "..." # Supabase API service role key
```

>[!NOTE]
>
> Set `SUPABASE_URL` to be the url of your supabase project [^1]
>
> Set `SUPABASE_KEY` to be the Supabase `service_role` key [^2] 

> [!TIP]
> variable assignment template held in the [`.env.template`](https://github.com/spe-uob/2025-SecondhandMarketplace/blob/dev/.env.template) within the root of the project
>
> Comments within the template tell you what to assign each variable to!
### Frontend environment

### Backend environment

### (Optional) MKdocs documentation server

[^1]: An example SUPABASE_URL:  "https://abc123.supabase.co"
[^2]: An example `service_role` key will usually be formatted: "eyJhbGci..." (200-300 characters long)
