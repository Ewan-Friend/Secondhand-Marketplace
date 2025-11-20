## Naming conventions

### Branch Naming
When naming branches, use only **lower case**, **hyphens (-)**, and **slashes (/)**  
`<type>/<issue-number#>-<short-description>`  

**Examples**  
`feature/10-initial-pages`  
it is a new feature and closes [ISSUE]: create pages for website in Flutter #10
  
`fix/45-mapping-between-pages`  
it is a fix to a bug and closes [ISSUE]: fix linking between pages

---
### Pull Request Naming
when naming pull requests (PR), start with the **type of change** followed by short description  
`[Type] decription`

**Examples**  
`[Feature] created 5 pages in flutter` 

`[Fix] Crash when user is not authenticated`

---
### Commit Messages
when commiting, make sure to address the **type** and **scope** (UI, API, README, authorisation, database)  
`<type>(scope) description`

**Examples**  
`feature(profile): implement user avatar upload`

`fix(authorisation): prevent crash on expired tokens` 
