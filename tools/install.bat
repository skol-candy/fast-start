## make sure the artifactory creds are set in pip and copy to the proper location before running 

XCOPY pip.ini C:\ProgramData\pip /y

pip install -r requirements.txt
pip install -U lightspeed-deploy-plugin