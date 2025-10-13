# SecondhandMarketplace(2025)

## Contents
- [Project description](#project-description)
- [Project goals](#project-goals)
- [Stakeholders](#stakeholders)
- [User Stories](#user-stories)
- [Project Management](#project-management)
- [Team Members](#team-members)
- [Naming Conventions](#naming-conventions)

## Project description
This project aims to transform second-hand marketplaces by harnessing the power of AI to deliver an unparalleled user experience. As part of this initiative, you will develop a dedicated robust app for Android and iOS, enabling users to effortlessly add items they no longer use to the platform.

## Project goals
- Protect the environment since items can be reused and renewed.
- Provide the seller a quick and convenient way to get rid of items they no longer want, for money.
- Provide the buyer a straightforward way to find the articles they desire.

## Stakeholders
### End Users:
- Buyers
- Sellers
- Browsers

### Core project & Development:
- Organisation managers
- Organisation owners
- Development team
- UX development team

### Business & Strategy
- Marketing team
- Legal team


## User Stories

### As a **Casual Buyer**
**I want to** browse and search listings easily  
**So that** I can quickly find second-hand items I like without wasting time.

**Pain Points / Problems:**
- Too many irrelevant results when searching  
- Slow or cluttered interfaces in other apps  

**Criteria:**
- Can browse by category (e.g., electronics, fashion, books)  
- Can filter by price range and condition (new/used)  
- Can favorite or save items for later  

---

### As a **First-Time User**
**I want to** explore the app and understand how it works easily  
**So that** I can sell/buy without any confusion.

**Pain Points / Problems:**
- Doesn’t know where to start  
- Too many options on the first screen make it hard to focus  

**Criteria:**
- Clear navigation and tooltips  
- Friendly and immersive design  
- Simple “Buy” vs “Sell” mode selection  

---

### As a **Buyer**
**I want to** see seller reviews and ratings  
**So that** I can make sure I’m buying from a trustworthy person.

**Pain Points / Problems:**
- Fear of scams or poor-quality products  
- Hard to know if a seller is reliable  

**Criteria:**
- Seller rating and review system  
- “Verified Seller” badge for trusted users  

---

### As a **Seller**
**I want to** upload and manage my listings easily from my phone  
**So that** I can sell my used items faster and track interest.

**Pain Points / Problems:**
- Uploading listings takes too long on other platforms  
- Hard to manage listings on mobile  

**Criteria:**
- Can upload photos and details directly from mobile  
- Can edit listings easily  
- Can see the status of my listings at a glance  

---

### As a **Top-Rated Seller**
**I want to** make my shop feel like a small premium boutique  
**So that** customers trust my listings more.

**Pain Points / Problems:**
- Other apps make every seller look the same  
- Hard to build a brand identity  

**Criteria:**
- Customizable profile banner and logo  
- Verified badge + “Top Seller” tag  
- Option to feature listings for extra visibility  

---

### As a **Conscious Consumer**
**I want to** give my unused items a new life  
**So that** I reduce waste and earn something in return.

**Pain Points / Problems:**
- Other marketplaces feel too commercial  
- Lack of community or shared values  

**Criteria:**
- Profile badges for sustainable sellers  
- Monthly “eco impact” summary  
- “Bundle sell” option for related items  



## Project Management
- [Kanban Board](https://github.com/orgs/spe-uob/projects/310/views/1)
- [Gantt Chart](https://github.com/orgs/spe-uob/projects/310/views/2)

## Team Members
| Members          | Email                                                 |
| ---------------- | ----------------------------------------------------- |
| Filip Hrehovcik  | [zu24411@bristol.ac.uk](mailto:zu24411@bristol.ac.uk) |
| Yunbo Zhang      | [th24060@bristol.ac.uk](mailto:th24060@bristol.ac.uk) |
| Emir Gizer       | [nh24391@bristol.ac.uk](mailto:nh24391@bristol.ac.uk) |
| Ewan Friend      | [pu24994@bristol.ac.uk](mailto:pu24994@bristol.ac.uk) |
| Lingze Yuan      | [wp22171@bristol.ac.uk](mailto:wp22171@bristol.ac.uk) |


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


