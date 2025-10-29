#!/bin/bash

if [[ -z "$ARTIFACTORY_USER" || -z "$ARTIFACTORY_TOKEN" ]]; then
   echo "Please set the variables ARTIFACTORY_USER and ARTIFACTORY_TOKEN"
   exit 1
fi

#Check poetry version for 1.4.2 and install it if not available

if ! poetry -v > /dev/null 2>&1; then
   printf "poetry not found, installing it ..."
   brew upgrade
   brew install pyenv 
   echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zprofile
   echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zprofile
   echo 'eval "$(pyenv init --path)"' >> ~/.zprofile
   echo 'eval "$(pyenv init -)"' >> ~/.zprofile
   source ~/.zprofile
   #assuming pyhthon v3.9.6 is the default version of python
   curl -sSL https://install.python-poetry.org | POETRY_VERSION=1.4.2 python3.9 -
   echo 'PATH="~/.local/bin:$PATH"' >> ~/.zprofile
   source ~/.zprofile
elif 
  POETRY_VERSION=`poetry --version`
  REQD_VER="1.4.2"
  if [[ $POETRY_VERSION = *$REQD_VER* ]]; then
    echo "Poetry version 1.4.2 is installed.."
  else
    poetry self update 1.4.2
  fi
fi 

# Run poetry config to set the artifactory authentication

poetry config http-basic.artifactory $ARTIFACTORY_USER $ARTIFACTORY_TOKEN

#Updates poetry.lock file ...
#Ensure pyproject.toml file is present
#Move the existing poetry.lock to backup
mv poetry.lock backup.poetry

#Run poetry install to create the dependencies
poetry install
result=$?

if [ $result -eq 0 ];
then 
  echo "poetry successfully created the lock file"
  rm backup.poetry
else
  echo "poetry.lock creation is unsuccessful"
fi



