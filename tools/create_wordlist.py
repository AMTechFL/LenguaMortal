import os
from pathlib import Path
import json

os.chdir(Path(__file__).resolve().parent)

# ensure that json files are in the same folder
languages = {'ja': 'hiragana.json', 'es': 'spanish.json'}
lang = 'es' # source language, dest is always English
filename = f'wordlist_{lang}.json'

with open(languages[lang], 'r', encoding='utf-8') as file:
    data = json.load(file)

# filtering out words deemed not useful_for_flashcard
data = [item for item in data if item.get("useful_for_flashcard") != False]
wordlist = []

for index, word in enumerate(data):
    wordlist.append({'id': f"{lang}_{index:06d}", 'word': word['word'], 'en': word['english_translation']})

with open(filename, "w", encoding="utf-8") as file:
    json.dump(wordlist, file, ensure_ascii=False)

print(f'Successfully output {filename} to {os.getcwd()}.')