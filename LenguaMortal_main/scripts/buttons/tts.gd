extends Area3D

var word_index: int = -1

func setup(index: int) -> void:
	word_index = index

func interact() -> void:
	if word_index != -1:
		var word_id = Global.wordlist[word_index]['id']
		var sound_path = "res://audio/tts/" + Global.lang + "/" + word_id + ".ogg"
		Global.play_sound(sound_path)
