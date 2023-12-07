#!/bin/bash

# Config
ZABBIX_URL="http://tu_zabbix_server/zabbix/api_jsonrpc.php"
ZABBIX_USER="admin"
ZABBIX_PASSWORD="admin"
PROBLEM_ID=$1

#token de autenticación
get_auth_token() {
    echo $(curl -s -X POST -H 'Content-Type: application/json' -d "
    {
        \"jsonrpc\": \"2.0\",
        \"method\": \"user.login\",
        \"params\": {
            \"user\": \"$ZABBIX_USER\",
            \"password\": \"$ZABBIX_PASSWORD\"
        },
        \"id\": 1
    }" $ZABBIX_URL | jq -r .result)
}

#ack
acknowledge_problem() {
    local TOKEN=$1
    echo $(curl -s -X POST -H 'Content-Type: application/json' -d "
    {
        \"jsonrpc\": \"2.0\",
        \"method\": \"event.acknowledge\",
        \"params\": {
            \"eventids\": [\"$PROBLEM_ID\"],
            \"message\": \"Problema ack desde script\",
            \"action\": 1
        },
        \"auth\": \"$TOKEN\",
        \"id\": 1
    }" $ZABBIX_URL | jq -r .result)
}

# Obtener el token de autenticación
AUTH_TOKEN=$(get_auth_token)

# Realizar el acknowledge del problema
acknowledge_problem $AUTH_TOKEN

##No funciona
