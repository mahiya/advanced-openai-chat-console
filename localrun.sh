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

python app.py