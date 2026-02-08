# Project setup

- [Approach 1 - Local Development](#local-development)
- [Approach 2 - Docker (reccomended for quick start)](#docker)

## Approach 1:
## Local Development

### Prerequisites
- Python 3.10+
- Flutter
- Git

### Guide to setup locally
1. **Clone repository**
```
git clone https://github.com/spe-uob/2025-SecondhandMarketplace.git
```
alternatively through ssh and a secure key setup:
``` 
git clone git@github.com:spe-uob/2025-SecondhandMarketplace.git
```

2. **Initialise virtual environment**

On a Unix based OS (Linux, MacOS, ...):
```
python3 -m venv venv                         # Create a virtual environment
source venv/bin/activate                     # Start up the virtual environment
```
On Windows:
```
python -m venv venv                          # Create a virtual environment
venv/Scripts/Activate.ps1                    # Start up the virtual environment
```

First line is necessary to create the virtual environment, can be reused through the second line afterwards

3. **Set up Flask backend**
```
pip install -r backend/requirements.txt      # Install dependencies
```
Only necessary to run once per virtual environment, or after any project updates

*make sure your pip is properly up to date using ```bash python -m pip install --upgrade pip```*

4. **Running the Flask backend**
```
python backend/run.py                        # Run the backend server
```
Only works if in the project root, ```python run.py``` will work if you are already in the backend folder

5. **Set up Flutter frontend**
```
cd application                               # Navigate to the frontend directory
```
Only works if in the project root, ```cd backend/application``` will work if currently in the backend folder
```
flutter pub get                              # Install required packages
```
Only necessary to run once, or after any project updates / ```flutter clean``` commands

*make sure to run ```flutter doctor``` to make sure you arent missing any toolchains*

6. **Running the Flutter frontend**

make sure you are in the application folder when runnning this command
```
flutter run                                  # Run flutter frontend server
```
you will be prompted to press a key to run on a certain emulator/environment - alternitavely use:
```
flutter run -d [environment name - e.g: chrome]
```

## Approach 2:
## Docker

This approach only requires docker desktop (or alternatives) and handles all required dependencies automatically within the container


1. **Clone repository**

```
git clone https://github.com/spe-uob/2025-SecondhandMarketplace.git
```
alternatively through ssh and a secure key setup:
``` 
git clone git@github.com:spe-uob/2025-SecondhandMarketplace.git
```

2. **Build and launch the project**
   
```
docker compose up --build     # Builds the projects in a docker container, then launches it
```
Container can then be ran within docker desktop (or alternative)

*if docker programs are failing to build try running*
```bash
docker compose down
docker system prune -f
docker compose up --build
```


3. **Access applications**

Frontend: http://localhost:8080

Backend: http://localhost:5000

