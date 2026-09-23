# Version of Python used: 3.11 (does not work on 3.14)

import os
from pathlib import Path
import json
import soundfile as sf
from kokoro import KPipeline

os.chdir(Path(__file__).resolve().parent)

languages = {'es': ('e', 'ef_dora'), 'ja': ('j', 'jf_alpha')}
lang = 'es'

with open(f'wordlist_{lang}.json', 'r', encoding='utf-8') as file:
    words = json.load(file)

pipeline = KPipeline(lang_code=languages[lang][0])

for i, word in enumerate(words):
    generator = pipeline(word['word'], voice=languages[lang][1], split_pattern=None)
    _, _, audio = next(generator)
    sf.write(f'tts/{lang}/{word["id"]}.wav', audio, 24000, format='WAV')
    if (i+1) % 100 == 0 or i == len(words)-1:
        print(f'current progress: [{i+1}/{len(words)}]')
print('Finished generating TTS files.')