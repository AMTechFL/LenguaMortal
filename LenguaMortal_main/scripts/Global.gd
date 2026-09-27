extends Node

var wordlist = []
var lang = ''

func load_json_file(file_path: String):
	if FileAccess.file_exists(file_path):
		var json_as_text = FileAccess.get_file_as_string(file_path)
		var json_data = JSON.parse_string(json_as_text)
		return json_data
	else:
		print("File does not exist!")
		return null
		

func play_sound(file_path: String):
	var stream = load(file_path) as AudioStream
	var player = AudioStreamPlayer.new()
	player.stream = stream
	add_child(player)
	player.play()
