import os
from pathlib import Path
import json
import random
from time import sleep
from pygame import mixer

os.chdir(Path(__file__).resolve().parent)

mixer.init()
correct_sfx = mixer.Sound('audio/sfx/correct.ogg')
incorrect_sfx = mixer.Sound('audio/sfx/wrong.ogg')
counting_beep = mixer.Sound('audio/sfx/beep.ogg')
error_sfx = mixer.Sound('audio/sfx/error.ogg')

def is_integer(value):
    try:
        int(value)
        return True
    except ValueError:
        return False

print('Warning: This is still in the very early stages of development, and may contain bugs.')
print('\nWelcome to Lengua Mortal! (pre-development pre-alpha)\n')
languages = ['es', 'ja']
print('Select your language (type 1 for Spanish, type 2 for Japanese)')
langnum = input('Type an option: ')
while not is_integer(langnum) or int(langnum)-1 not in range(2):
    error_sfx.play()
    langnum = input('Not a valid option. Try again: ')
lang = languages[int(langnum)-1]

with open(f'wordlists/wordlist_{lang}.json', 'r', encoding='utf-8') as file:
    words = json.load(file)

def get_randint():
    return random.randint(0, len(words)-1)

def question():
    correct = get_randint()
    tts_sound = mixer.Sound(f'audio/tts/{lang}/{words[correct]["id"]}.ogg')
    wrong1, wrong2, wrong3 = get_randint(), get_randint(), get_randint()
    while len({correct, wrong1, wrong2, wrong3}) != 4:
        wrong1, wrong2, wrong3 = get_randint(), get_randint(), get_randint()
    choices = random.sample([correct, wrong1, wrong2, wrong3], 4)
    print()
    prompt = f"""What is {words[correct]['word']} in English?
(Type '0' if you need a Text-To-Speech (TTS) readout)
1 ) {words[choices[0]]['en']}
2 ) {words[choices[1]]['en']}
3 ) {words[choices[2]]['en']}
4 ) {words[choices[3]]['en']}
"""
    print(prompt)
    answer = input("Put your answer here: ")
    while not is_integer(answer) or int(answer) not in range(1, 5):
        if is_integer(answer) and int(answer) == 0:
            tts_sound.play()
            print("Played a sound.\n")
            sleep(.5)
            answer = input("Your answer: ")
        else:
            error_sfx.play()
            print("Not a valid answer.")
            answer = input("Your answer: ")
    if choices[int(answer)-1] == correct:
        print("Correct!")
        correct_sfx.play()
        sleep(1.5)
        return True
    else:
        print("Incorrect.")
        incorrect_sfx.play()
        sleep(1.5)
        for i in range(3, 0, -1):
            print(str(i) + '...', end=' ', flush=True)
            counting_beep.play()
            sleep(1)
        return False

print('How many questions would you like to do?')
count = input('Put an integer value: ')
while not is_integer(count):
    error_sfx.play()
    count = input('Not an integer value. Try again: ')
for i in range(int(count)):
    question()

print('\nThank you for playing!')