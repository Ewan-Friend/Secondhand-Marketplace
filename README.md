_[⛓️ Documentation Link ⛓️](https://urban-adventure-qm9y5k8.pages.github.io/)_

# SecondhandMarketplace (2025)

[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)
[![Flask](https://img.shields.io/badge/Flask-000000?style=for-the-badge&logo=flask&logoColor=white)](https://palletsprojects.com/p/flask/)
[![AWS Cloud](https://img.shields.io/badge/AWS_eb-FF9900?style=for-the-badge&logo=amazons3&logoColor=white)](https://aws.amazon.com/)
[![Supabase](https://img.shields.io/badge/Supabase-181818?style=for-the-badge&logo=supabase&logoColor=white)](https://supabase.com/)
[![Docker](https://img.shields.io/badge/Docker-deepskyblue?style=for-the-badge&logo=docker&logoColor=white&labelColor=%231D63ED&color=%231D63ED)](https://www.docker.com/)
[![Ruff](https://img.shields.io/badge/Ruff-galaxy?style=for-the-badge&logo=ruff&logoColor=black&logoSize=auto)](https://docs.astral.sh/ruff/)
[![Pytest](https://img.shields.io/badge/Pytest-%230A9EDC?style=for-the-badge&logo=pytest&logoColor=white&logoSize=auto)](https://docs.pytest.org/en/stable/)

## Contents
- [Project description](#project-description)
- [Project goals](#project-goals)
- [Project structure](#project-structure)
- [Project setup](#project-setup)
- [Deployment](#deployment)
- [Software architecture](#software-architecture)
- [User instructions](#user-instructions)
- [Stakeholders](#stakeholders)
- [User Stories](#user-stories)
- [Project Management](#project-management)
- [Other Documentation Links](#other-documentation-links)
- [Team Members](#team-members)

## Project description
- **Project name:** Secondhand Marketplace
- **Description:** Cross-platform secondhand marketplace built with **Flutter**. Backend uses **Python Flask** and **AWS** (authentication, databases, cloud hosting). **Supabase** manages accounts and authentication.
- **Tech stack**
  - Frontend: Flutter
  - Backend: Flask, AWS, Supabase

## Project goals
- Protect the environment by reusing and renewing items.
- Help sellers quickly and conveniently sell items they no longer want (for money).
- Help buyers find the items they desire in a straightforward way.

## Project structure
```txt
2025-SecondhandMarketPlace
├── application                     # Flutter frontend
│   ├── lib
│   │   ├── models                  # Reusable data structures
│   │   ├── pages                   # Application pages
│   │   ├── services                # Frontend services
│   │   └── widgets                 # Reusable UI elements
│   ├── test                        # Frontend tests
|   ├── nginx.conf                  # Serves the frontend
│   ├── Dockerfile                  # Docker build info
│   ├── ...
├── backend                         # Python Flask backend
│   ├── app
│   │   ├── __init__.py             # Blueprint + frontend connection
│   │   └── routes                  # API endpoints
│   ├── run.py                      # Run backend server
│   ├── test                        # Backend tests
│   ├── requirements.txt            # Backend dependencies
│   ├── Dockerfile                  # Docker build info
├── docs                            # Project docs
├── .env.template                   # Template for .env (API keys)
├── docker-compose.yml              # Multi-container setup (frontend/backend)
├── mkdocs.yml                      # Online docs structure
```

## Project setup
- [Approach 1: Local Development](#approach-1-local-development)
- [Approach 2: Docker (recommended for quick start)](#approach-2-docker-recommended-for-quick-start)

### Approach 1: Local Development

#### Prerequisites
- Python 3.10+
- Flutter
- Git

#### Steps
1) **Clone repository**
```bash
git clone https://github.com/spe-uob/2025-SecondhandMarketplace.git
# or (SSH)
git clone git@github.com:spe-uob/2025-SecondhandMarketplace.git
```

2) **Create + activate virtual environment**
- Unix (Linux/MacOS):
```bash
python3 -m venv venv
source venv/bin/activate
```
- Windows:
```bash
python -m venv venv
venv/Scripts/Activate.ps1
```
3) **Install backend dependencies**
```bash
pip install -r backend/requirements.txt
```
4) **Run Flask backend**
```bash
python backend/run.py
```
5) **Install frontend dependencies**
```bash
cd application
flutter pub get
```
6) **Run Flutter frontend**
```bash
flutter run
# or specify a device:
flutter run -d [environment name - e.g: chrome]
```
> [!NOTE]
> *if you are having issues, find a more detailed guide to local setup [here](https://github.com/spe-uob/2025-SecondhandMarketplace/blob/task/193-improve-conciseness-of-readme/docs/project-setup/project-setup.md#local-development)*
### Approach 2: Docker (recommended for quick start)
This approach only requires Docker Desktop (or alternatives). All dependencies run inside containers.

1) **Clone repository**
```bash
git clone https://github.com/spe-uob/2025-SecondhandMarketplace.git
# or (SSH)
git clone git@github.com:spe-uob/2025-SecondhandMarketplace.git
```
2) **Build + launch**
```bash
docker compose up --build
```
3) **Access**
- Frontend: http://localhost:8080
- Backend: http://localhost:5000

> [!NOTE]
> *if you are having issues, find a more detailed guide to docker setup [here](https://github.com/spe-uob/2025-SecondhandMarketplace/blob/task/193-improve-conciseness-of-readme/docs/project-setup/project-setup.md#docker)*
## Software architecture
The following diagram illustrates the Secondhand Marketplace software architecture and the interaction between the Flutter frontend and the Python-Flask backend.
<p align="left">
  <img width="918" alt="architecture image" src="./docs/architecture/architecture2.png";>
</p>

## Deployment

### Infrastructure
Cloud provider: AWS
Frontend Hosting: S3
CDN: CloudFront

### Continuous Deployment
Continuous deployment via GitHub Actions
On every push to the dev branch:
- the app is built
- build artifacts are uploaded to an S3 bucket
The latest version is automatically deployed to production

> [!NOTE]
the website is available at both: 
www.sepsecondhand.co.uk
sepsecondhand.co.uk

## User instructions

### Startup
- You will initially be prompted to login to the website - with the option to sign up if you dont have an established account, where you login using your email and password.
- You are then immediately sent to the sites home page, where you may navigate multiple pages, there are also a list of items that you may browse

### To buy items

- To browse or purchase a product from the home page, click on the product you would like to look at to open the "item detail page", where there is a prompt to contact the seller.
- All critical information about quality, price and other details are displayed on the item detail page.

### To sell items

- Click the '+' icon on the header to navigate to the "post item page"
- Fill in the corresponding fields for the item you would like to sell, make sure all details are filled in absolutely correct as first impressions count
- after filling in required information, you are able to post your item immediately, or check what it would look like with the draft option
  
### To view your profile

- Click on the "profile" icon on the header to navigate to your "profile page"
- This page contains information about your account, inclueding items you have listed and your seller rating
- You are also to change your profile information on this screen

> [!NOTE]
> *if you want a visual guide to some of the pages, check out our [Visual user instructions](https://github.com/spe-uob/2025-SecondhandMarketplace/blob/dev/docs/user-instructions/user-instructions.md)*

## Stakeholders

### End Users
- **Buyers:** Search/purchase items. Care about quality, delivery speed, accurate listings; rely on ratings. Need secure payments and an easy-to-use interface.
- **Sellers:** List pre-owned goods. Want easy listing management and support finding ideal buyers (e.g., AI tools). Need efficient payment handling; may share location with interested buyers.
- **Browsers:** Explore without immediate intent. Contribute traffic, may become buyers later, and help gauge interest/trends.

### Core project & Development
- **Organisation managers:** Oversee day-to-day operations; coordinate devs and other departments to align with objectives; keep the platform running smoothly.
- **Organisation owners:** Stakeholders/investors funding and guiding the business; define objectives focused on profitability and brand growth.
- **Development team:** Build/maintain technical infrastructure; coding/testing; ensure security, scalability, and usability.
- **UX development team:** Develop an accessible, efficient interface; implement designs; iterate through testing and feedback.

### Business & Strategy
- **Marketing team:** Promote the platform; increase buyers/sellers; manage campaigns; analyze trends; build awareness and drive engagement/growth.
- **Legal team:** Ensure compliance; handle user agreements, IP rights, data protection, and dispute resolution.

## User Stories

| Role | Goal (**I want to...**) | Benefit (**So that...**) | Key Pain Points / Problems | Criteria |
| :--- | :--- | :--- | :--- | :--- |
| **Casual Buyer** | browse and search listings easily | quickly find second-hand items I like without wasting time | * Too many irrelevant results <br> * Slow/cluttered interfaces | * Browse by category <br> * Filter by price & condition <br> * Favorite/save items |
| **First-Time User** | explore the app and understand how it works easily | sell/buy without any confusion | * Doesn’t know where to start <br> * Too many first-screen options | * Clear navigation/tooltips <br> * Friendly/immersive design <br> * Simple “Buy” vs “Sell” mode |
| **Buyer** | see seller reviews and ratings | buy from a trustworthy person | * Fear of scams/poor-quality products <br> * Hard to judge reliability | * Rating & review system <br> * “Verified Seller” badge |
| **Seller** | upload and manage listings easily from my phone | sell faster and track interest | * Listing upload takes too long elsewhere <br> * Hard to manage on mobile | * Upload photos/details on mobile <br> * Edit listings <br> * See listing status at a glance |
| **Top-Rated Seller** | make my shop feel like a small premium boutique | customers trust my listings more | * Sellers look the same in other apps <br> * Hard to build identity | * Customizable banner/logo <br> * Verified badge + “Top Seller” tag <br> * Feature listings option |
| **Conscious Consumer** | give my unused items a new life | reduce waste and earn something | * Too commercial elsewhere <br> * Weak community/shared values | * Sustainable badges <br> * Monthly “eco impact” summary <br> * “Bundle sell” option |

## Project Management
- [Kanban Board](https://github.com/orgs/spe-uob/projects/310/views/1)
- [Gantt Chart](https://github.com/orgs/spe-uob/projects/310/views/2)

## Other Documentation Links
- [AI usage docs](https://github.com/spe-uob/2025-SecondhandMarketplace/blob/dev/docs/AI_usage/Ai_info.md)
- [Database structure](https://github.com/spe-uob/2025-SecondhandMarketplace/blob/dev/docs/database-structure/database-structure.md)
- [Github naming conventions](https://github.com/spe-uob/2025-SecondhandMarketplace/blob/dev/docs/naming_conventions/naming_conventions.md)
- [Detailed setup guide](https://github.com/spe-uob/2025-SecondhandMarketplace/blob/dev/docs/project-setup/project-setup.md)
- [Visual user instructions](https://github.com/spe-uob/2025-SecondhandMarketplace/blob/dev/docs/user-instructions/user-instructions.md)

## Team Members
| Members | Email |
| --- | --- |
| Filip Hrehovcik | [zu24411@bristol.ac.uk](mailto:zu24411@bristol.ac.uk) |
| Yunbo Zhang | [th24060@bristol.ac.uk](mailto:th24060@bristol.ac.uk) |
| Emir Gizer | [nh24391@bristol.ac.uk](mailto:nh24391@bristol.ac.uk) |
| Ewan Friend | [pu24994@bristol.ac.uk](mailto:pu24994@bristol.ac.uk) |
| Lingze Yuan | [wp22171@bristol.ac.uk](mailto:wp22171@bristol.ac.uk) |
