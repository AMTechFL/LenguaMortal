extends Node

func _on_spanish_pressed() -> void:
	Global.wordlist = Global.load_json_file('res://wordlists/wordlist_es.json')
	Global.lang = 'es'
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_japanese_pressed() -> void:
	Global.wordlist = Global.load_json_file('res://wordlists/wordlist_ja.json')
	Global.lang = 'ja'
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
