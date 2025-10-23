# Imports
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from app import create_app

# Returns a flask instance
app = create_app()

if __name__ == "__main__":
    # Enable live reload for developmental purposes
    app.run(debug=True, host='0.0.0.0', port=5000)

'''
~~~~~~~~~~~~~~~~~~ SOME ADVICE FOR RUNNING ~~~~~~~~~~~~~~~~~~~~~
(code is currently in a testing phase to ensure flask functions correctly)

~~~ To install dependencies: ~~~
python3 -m venv venv                 # to create a virtual environment, these folders should be kept local preferably 
source venv/bin/activate             # to start up the virtual environment
pip install -r backend/requirements.txt      # to install requirements, more can be added with pip freeze > requirements.txt 
python run.py                        # runs the backend portion


note:
appending /hello to the end of the url will show output, this is a test of the blue print functionality

run.py -> starts server
create_app() in init.py -> builds the app
routes.py -> endpoints
'''