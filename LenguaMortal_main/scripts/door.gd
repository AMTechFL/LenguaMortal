extends Node3D

@onready var animatable_body: AnimatableBody3D = $DoorAnimation
@onready var word_label: Label3D = $DoorAnimation/WordCard/Word
@onready var tts_button: Area3D = $DoorAnimation/TTS

@onready var choice_nodes: Array[Area3D] = [
	$DoorAnimation/Choices/Choice0,
	$DoorAnimation/Choices/Choice1,
	$DoorAnimation/Choices/Choice2,
	$DoorAnimation/Choices/Choice3
]

@export var open_angle: float = -90.0
@export var open_duration: float = 0.5

var is_open: bool = false
var is_processing: bool = false
var current_answer_index: int = -1

func _ready() -> void:
	animatable_body.top_level = false
	animatable_body.sync_to_physics = false
	
	for button in choice_nodes:
		button.choice_clicked.connect(_on_choice_selected)
		
	question()

func question() -> void:
	is_processing = false
	set_boxes_color(Color.WHITE) # Reset color back to default white/gray
	
	if Global.wordlist.is_empty():
		return
		
	# 1. Pick answer index
	current_answer_index = randi_range(0, Global.wordlist.size() - 1)
	
	# 2. Display word on door
	word_label.text = str(Global.wordlist[current_answer_index]['word'])
	
	# 3. Pass answer index to TTS
	if tts_button and tts_button.has_method("setup"):
		tts_button.setup(current_answer_index)
		
	# 4. Pick choices
	var choices = [
		current_answer_index,
		randi_range(0, Global.wordlist.size() - 1),
		randi_range(0, Global.wordlist.size() - 1),
		randi_range(0, Global.wordlist.size() - 1)
	]
	choices.shuffle()
	
	# 5. Pass choices to buttons
	for i in range(4):
		var word_idx = choices[i]
		choice_nodes[i].setup(word_idx, Global.wordlist[word_idx]['en'])

func clear_all_labels() -> void:
	for button in choice_nodes:
		if button.has_method("clear_label"):
			button.clear_label()

func set_boxes_color(color: Color) -> void:
	for button in choice_nodes:
		if button.has_method("set_color"):
			button.set_color(color)

func _on_choice_selected(selected_index: int) -> void:
	if is_open or is_processing:
		return
		
	is_processing = true
	clear_all_labels() # Clear all 4 button labels immediately
	
	if selected_index == current_answer_index:
		open_door()
	else:
		word_label.text = "" # Clear main word display on wrong answer
		Global.play_sound('res://audio/sfx/wrong.ogg')
		await get_tree().create_timer(1.5).timeout
		question() # Generate new question

func open_door() -> void:
	if is_open:
		return
		
	is_open = true
	Global.play_sound('res://audio/sfx/correct.ogg')
	await get_tree().create_timer(0.5).timeout
	Global.play_sound("res://audio/sfx/door.ogg")
	var target_rotation_y = animatable_body.rotation_degrees.y + open_angle
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(animatable_body, "rotation_degrees:y", target_rotation_y, open_duration)
