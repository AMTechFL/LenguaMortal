extends CharacterBody3D

const SPEED = 4.0
const JUMP_VELOCITY = 0.0
const SPRINT_MULTIPLIER = 1.69
const SENSITIVITY = 0.00420
var is_sprinting = false

@onready var head = $head
@onready var camera = $head/Camera3D
@onready var raycast = $head/Camera3D/RayCast3D # Reference to your new RayCast3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(60))

	# Press 'interact' (or left mouse button / 'E') to trigger objects
	if event.is_action_pressed("interact"):
		if raycast.is_colliding():
			var object = raycast.get_collider()
			print("RayCast hit: ", object.name)
		
			# 1. Check the object hit directly
			if object and object.has_method("interact"):
				object.interact()
		# 2. Check if parent object has interact (in case hit child mesh/body)
			elif object and object.get_parent() and object.get_parent().has_method("interact"):
				object.get_parent().interact()
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("exit"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().change_scene_to_file('res://scenes/main_menu.tscn')

	is_sprinting = Input.is_action_pressed("sprint")
	
	var speed = SPEED * (SPRINT_MULTIPLIER if is_sprinting else 1.0)

	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		$WalkingSound.pitch_scale = SPRINT_MULTIPLIER if is_sprinting else 1.0
	else:
		$WalkingSound.play()
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
