#!/bin/bash

# Check if detect-secrets is present

if !detect-secrets -v > /dev/null 2>&1; then
   echo "detect-secrets not found, installing .."
   python3 -m pip install --upgrade "git+https://github.com/ibm/detect-secrets.git@master#egg=detect-secrets"
   pip install pre-commit
   pre-commit install
   echo "detect-secrets installed .."
fi

# Create .secrets.baseline
detect-secrets scan --update .secrets.baseline

echo ".secrets.baseline is updated"
