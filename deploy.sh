#!/bin/bash -e
region='japaneast'
resourceGroup=$1 # デプロイ先のリソースグループ名を引数で取得する
sku='B1'
runtime='PYTHON:3.9'

export OPENAI_NAME=$(cat openai_settings.json | jq '.OPENAI_NAME' | sed "s/\"//g")
export OPENAI_KEY=$(cat openai_settings.json | jq '.OPENAI_KEY' | sed "s/\"//g")
export OPENAI_MODEL=$(cat openai_settings.json | jq '.OPENAI_MODEL' | sed "s/\"//g")
export OPENAI_API_VERSION=$(cat openai_settings.json | jq '.OPENAI_API_VERSION' | sed "s/\"//g")
export OPENAI_SYSTEM_MESSAGE=$(cat openai_settings.json | jq '.OPENAI_SYSTEM_MESSAGE' | sed "s/\"//g")
export OPENAI_PROMPT_FORMAT=$(cat openai_settings.json | jq '.OPENAI_PROMPT_FORMAT' | sed "s/\"//g")
export OPENAI_TEXT_SPLIT_SIZE=$(cat openai_settings.json | jq '.OPENAI_TEXT_SPLIT_SIZE' | sed "s/\"//g")
export OPENAI_MAX_TOKEN=$(cat openai_settings.json | jq '.OPENAI_MAX_TOKEN' | sed "s/\"//g")
export OPENAI_TEMPERATURE=$(cat openai_settings.json | jq '.OPENAI_TEMPERATURE' | sed "s/\"//g")
export OPENAI_CHAT_HISTORY_TAKE=$(cat openai_settings.json | jq '.OPENAI_CHAT_HISTORY_TAKE' | sed "s/\"//g")

az group create \
    --location $region \
    --resource-group $resourceGroup

name=($(az webapp up \
        --location $region \
        --resource-group $resourceGroup \
        --sku $sku \
        --runtime $runtime \
        --query 'name' \
        --output tsv))

az webapp config appsettings set \
    --resource-group $resourceGroup \
    --name $name \
    --settings "OPENAI_NAME=$OPENAI_NAME" \
               "OPENAI_KEY=$OPENAI_KEY" \
               "OPENAI_MODEL=$OPENAI_MODEL" \
               "OPENAI_API_VERSION=$OPENAI_API_VERSION" \
               "OPENAI_SYSTEM_MESSAGE=$OPENAI_SYSTEM_MESSAGE" \
               "OPENAI_PROMPT_FORMAT=$OPENAI_PROMPT_FORMAT" \
               "OPENAI_TEXT_SPLIT_SIZE=$OPENAI_TEXT_SPLIT_SIZE" \
               "OPENAI_MAX_TOKEN=$OPENAI_MAX_TOKEN" \
               "OPENAI_TEMPERATURE=$OPENAI_TEMPERATURE" \
               "OPENAI_CHAT_HISTORY_TAKE=$OPENAI_CHAT_HISTORY_TAKE"