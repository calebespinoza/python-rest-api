#!/bin/bash
python3 -m venv ./venv
bash source $WORKSPACE/venv/bin/activate
pip install pipenv
pipenv install -d --system --ignore-pipfile
deactivate