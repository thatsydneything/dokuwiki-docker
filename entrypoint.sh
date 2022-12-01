#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

echo '#############################'
echo '#     That Sydney Thing     #'
echo '#     Dokuwiki Container    #'
echo '#############################'
echo 'For any issues or assistance, check us out on GitHub:'
echo 'http://github.com/thatsydneything/dokuwiki-docker/'

echo 'Checking for Dokuwiki persisted data...'

SETUP_REQUIRED=false

if [ -z "$(ls -A /usr/share/dokuwiki/data/)" ]
then
  echo 'No existing Dokuwiki data folder detected... copying new data...'
  cp -R /tmp/data/. /usr/share/dokuwiki/data/
  chown -R www-data:www-data /usr/share/dokuwiki/data/
else
  echo 'Existing Dokuwiki data folder detected...'
fi

if [ -z "$(ls -A /usr/share/dokuwiki/lib/)" ]
then
  echo 'No existing Dokuwiki library folder detected... copying new data...'
  cp -R /tmp/lib/. /usr/share/dokuwiki/lib/
  chown -R www-data:www-data /usr/share/dokuwiki/lib/
else
  echo 'Existing Dokuwiki library folder detected...'
fi

if [ -z "$(ls -A /usr/share/dokuwiki/conf/)" ]
then
  echo 'No existing Dokuwiki configuration folder detected... copying new data...'
  cp -R /tmp/conf/. /usr/share/dokuwiki/conf/
  chown -R www-data:www-data /usr/share/dokuwiki/conf/
  SETUP_REQUIRED=true
else
  echo 'Existing Dokuwiki configuration folder detected...'
fi

echo 'Finished loading Dokuwiki persistence data...'

echo 'Starting Apache service...'

service apache2 start
a2ensite dokuwiki
service apache2 reload

echo 'Apache service started...'
if [ ${SETUP_REQUIRED} == true ]
then
  echo 'Configuring Dokuwiki installation from environment variables...'
  echo 'Validating environment variables...'

  if [ -z ${PASSWORD} ]
  then
    echo 'ERROR: PASSWORD not defined in environment variables. Terminating...'
    rm -rf /usr/share/dokuwiki/conf/*
    exit 1
  else
    echo 'Successfully validated environment variables...'
    echo 'Attempting to run install script...'
    sleep 1
    CURL_RESPONSE="$(curl  --verbose --location --data-urlencode l="${LANG}" --data-urlencode d[acl]="${ACL}" --data-urlencode d[policy]="${ACL_POLICY}" --data-urlencode d[allowreg]="${ALLOW_REG}" --data-urlencode d[license]="${LICENSE}" --data-urlencode d[pop]="${POP}" --data-urlencode d[title]="${TITLE}" --data-urlencode d[superuser]="${USERNAME}" --data-urlencode d[fullname]="${FULL_NAME}" --data-urlencode d[email]="${EMAIL}" --data-urlencode d[password]="${PASSWORD}" --data-urlencode d[confirm]="${PASSWORD}" --data-urlencode submit= http://127.0.0.1:8080/install.php 2>&1)"
    if [[ "${CURL_RESPONSE}" == *"The configuration was finished successfully"* ]]
    then  
      echo 'Dokuwiki installation completed successfully...'
    else
      echo 'Dokuwiki installation failed. Terminating...'
      exit 1
    fi
  fi
fi
echo 'Dokuwiki up!'
tail -f /var/log/apache2/access.log