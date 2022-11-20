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

echo 'Validating environment variables...'

VAR_ERROR=false

if [ -z ${USERNAME} ]
then
    echo 'ERROR: USERNAME not defined in environment variables.'
    VAR_ERROR=true
fi

if [ -z ${PASSWORD} ]
then
    echo 'ERROR: PASSWORD not defined in environment variables.'
    VAR_ERROR=true
fi

if [ -z ${FULL_NAME} ]
then
    echo 'ERROR: FULL_NAME not defined in environment variables.'
    VAR_ERROR=true
fi

if [ -z ${EMAIL} ]
then
    echo 'ERROR: EMAIL not defined in environment variables.'
    VAR_ERROR=true
fi

if [ ${VAR_ERROR} == true ]
then
    echo 'Please provide required environment variables specified above and start pod again. Terminating...'
    exit 1
else
    echo 'Successfully validated environment variables...'
fi

# echo 'Waiting for Apache to be ready...'

# IP_ADDRESS=$(hostname -I)

# APACHE_ATTEMPTS=0
# APACHE_RESPONSE=0

# while [ $APACHE_RESPONSE -ne 200 ]
# do
#     if [ $APACHE_ATTEMPTS -ge 10 ]
#     then
#         echo $APACHE_ATTEMPTS
#         echo 'Apache service is not correctly configured. Terminating...'
#         exit 1
#     fi
#     sleep 5
#     APACHE_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://${IP_ADDRESS}:8080/doku.php)
# done

echo 'Checking for Dokuwiki persisted data...'

if [ -f "/usr/share/dokuwiki/conf/dokuwiki.php" ]
then
    echo 'Existing Dokuwiki data detected... starting with existing data...'
else
    echo 'No existing Dokuwiki data detected... copying new data...'
    cp -R /tmp/conf/. /usr/share/dokuwiki/conf/
    cp -R /tmp/data/. /usr/share/dokuwiki/data/
    cp -R /tmp/lib/. /usr/share/dokuwiki/lib/
    chown -R www-data:www-data /usr/share/dokuwiki
    echo 'Finished copying Dokuwiki files...'
fi

echo 'Starting Apache service...'

service apache2 start
a2ensite dokuwiki
service apache2 reload

echo 'Apache service started...'

echo 'Dokuwiki up!'
tail -f /var/log/apache2/access.log