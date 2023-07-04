import os
import openai
from concurrent.futures.thread import ThreadPoolExecutor

OPENAI_NAME = os.environ.get("OPENAI_NAME")
OPENAI_KEY = os.environ.get("OPENAI_KEY")
OPENAI_MODEL = os.environ.get("OPENAI_MODEL")
OPENAI_API_VERSION = os.environ.get("OPENAI_API_VERSION")
OPENAI_SYSTEM_MESSAGE = os.environ.get("OPENAI_SYSTEM_MESSAGE")
OPENAI_PROMPT_FORMAT = os.environ.get("OPENAI_PROMPT_FORMAT")
OPENAI_TEXT_SPLIT_SIZE = int(os.environ.get("OPENAI_TEXT_SPLIT_SIZE", 10000))
OPENAI_MAX_TOKEN = int(os.environ.get("OPENAI_MAX_TOKEN", 3000))
OPENAI_TEMPERATURE = int(os.environ.get("OPENAI_TEMPERATURE", 0))
OPENAI_CHAT_HISTORY_TAKE = int(os.environ.get("OPENAI_CHAT_HISTORY_TAKE", 10))

openai.api_type = "azure"
openai.api_base = f"https://{OPENAI_NAME}.openai.azure.com/" 
openai.api_version = OPENAI_API_VERSION
openai.api_key = OPENAI_KEY

def get_completion(user_message, history=[]):
    messages = []
    messages.append({"role": "system", "content": OPENAI_SYSTEM_MESSAGE})
    messages.extend(history[len(history)-OPENAI_CHAT_HISTORY_TAKE:])
    messages.append({"role": "user", "content": user_message})
    resp = openai.ChatCompletion.create(
        engine=OPENAI_MODEL,
        messages=messages,
        max_tokens=OPENAI_MAX_TOKEN
    )
    return resp["choices"][0]["message"]["content"]

def get_completions(prompts):
    with ThreadPoolExecutor() as executor:
        threads = [executor.submit(get_completion, prompt) for prompt in prompts]
        completions = [thread.result() for thread in threads]
        return completions

def get_completion_from_long_text(user_message, text):
    completion = ''
    while True:
        texts = [text[i:i + OPENAI_TEXT_SPLIT_SIZE] for i in range(0, len(text), OPENAI_TEXT_SPLIT_SIZE)]
        prompts = list(map(lambda t: OPENAI_PROMPT_FORMAT.format(user_message=user_message, text=t), texts))
        completions = get_completions(prompts)
        if len(completions) == 1:
            completion = completions[0]
            break
        text = "\n".join(completions)
    return completion
