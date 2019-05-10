#!/bin/bash

BUNDLE_DIR=$1
EXAMPLE_REPOSITORY=$1
EXAMPLE_RELEASE=$2
EXAMPLE_NAMESPACE=$3
PASSWD=$4

AUTH_TOKEN=$(curl -sH "Content-Type: application/json" -XPOST https://quay.io/cnr/api/v1/users/login -d '
{
    "user": {
        "username": "'"$EXAMPLE_NAMESPACE"'",
        "password": "'"$PASSWD"'"
    }
}' | jq -r '.token')

operator-courier push $BUNDLE_DIR $EXAMPLE_NAMESPACE $EXAMPLE_REPOSITORY $EXAMPLE_RELEASE "$AUTH_TOKEN"
