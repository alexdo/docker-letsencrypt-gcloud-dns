#!/bin/bash
set -e
#set -x

PRIMARY_DOMAIN=""
LEGO_CMD="lego --email=$EMAIL --dns=gcloud --path=/certstore --accept-tos"

echo "===== ACTIVATING GOOGLE CLOUD SDK SERVICE ACCOUNT FROM gcloud-service-account.json ====="
export GOOGLE_APPLICATION_CREDENTIALS=/gcloud-service-account.json
gcloud auth activate-service-account --key-file /gcloud-service-account.json
if [ $? -gt 0 ]
then
    echo "Unable to activate service account listed in gcloud-service-account.json"
    exit 2
fi
echo -e "==============\n\n"


_domain_arr=$(echo $DOMAINS | tr "," "\n")

for _domain in $_domain_arr
do
    LEGO_CMD="$LEGO_CMD --domains=$_domain"
    if [ "$PRIMARY_DOMAIN" == "" ]
    then
        PRIMARY_DOMAIN="$_domain"
    fi
done

if [ -f "/certstore/certificates/$PRIMARY_DOMAIN.json" ] 
then
    echo "===== OPERATION: RENEW ====="
    LEGO_CMD="$LEGO_CMD renew --days=$RENEW_DAYS"
else
    echo "===== OPERATION: INITIAL REQUEST ====="
    LEGO_CMD="$LEGO_CMD run"
fi

echo "===== RUNNING LEGO ====="
echo "$LEGO_CMD"
$LEGO_CMD
