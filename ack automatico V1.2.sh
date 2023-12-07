#!/bin/bash

# Definir las variables
url="https://zabbix.example.com/api_jsonrpc.php"
user="admin"
password="admin"

# Bucle infinito
while true; do

    # Obtener la lista de eventos
    response=$(curl -s "$url" -u "$user:$password" -X GET -d "method=host.get&filter={'status':'TRIGGERED'}")
    eventos=$(echo "$response" | jq '.result')

    # Iterar sobre los eventos
    for evento in $eventos; do

        # Recoger el nombre del trigger
        triggerid=$(echo "$evento" | jq '.triggerid')

        # reconomiento automatico
        comentario="Reconocimiento automático"

        # Reconocer el evento
        curl -s "$url" -u "$user:$password" -X POST -d "method=trigger.acknowledge&triggerid=$triggerid&comment=$comentario"
    done

    # Esperar un segundo
    sleep 1
done

