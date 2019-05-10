#!/bin/bash

set -e

if [[ -z "$2" ]]; then
  echo "Usage: $0 [NAMESPACE] [REPOSITORY] [USERNAME] [PASSWD]"
  exit 1
fi

NAMESPACE=$1
REPOSITORY=$2

USERNAME=$3
PASSWD=$4
AUTH_TOKEN=$(curl -sH "Content-Type: application/json" -XPOST https://quay.io/cnr/api/v1/users/login -d '
{
    "user": {
        "username": "'"$USERNAME"'",
        "password": "'"$PASSWD"'"
    }
}' | jq -r '.token')

URL="https://quay.io/cnr/api/v1/packages/${NAMESPACE}/${REPOSITORY}"
echo "Pulling latest bundle from $URL"

SHA256=$(curl -s -XGET -H "Authorization: $AUTH_TOKEN" $URL | jq -r '.[-1].content.digest')
echo "SHA256 of latest bundle: $SHA256"

OUTPUT="${REPOSITORY}_bundle.tar.gz"
curl -s -XGET -H "Authorization: $AUTH_TOKEN" $URL/blobs/sha256/$SHA256 -o $OUTPUT
echo "Created ${OUTPUT}"
