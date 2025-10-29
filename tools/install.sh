## make sure the artifactory creds are set in pip and copy to the proper location before running 
mkdir -p ~/.pip/

cp -f pip.conf ~/.pip/pip.conf

pip install -r requirements.txt
pip install -U lightspeed-deploy-plugin