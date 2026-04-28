class_name Mario extends CharacterBody2D
@onready var shape: CollisionShape2D = $Collision
@onready var small_mario: Node2D = $"Small Mario"
@onready var big_mario: Node2D = $"Big Mario"
const ACCEL = 1200
const MAX_SPEED = 250
const JUMP_FORCE: int = 500

var state_list : Array[int] = [0, 1, 2] 
var curr_state: int = 0 
var jump_time: float = 0.0 
var dir:float = 0.0

func _ready() -> void: 
	Global.mario = self

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += get_gravity().y * delta

	# Handle jump.
	if Input.is_action_just_pressed('jump'):
		velocity.y = -JUMP_FORCE
	
	#Handle Crouch
	if Input.is_action_just_pressed("crouch") and is_on_floor():
		shape.shape.set_size(Vector2(12,12))
		shape.position.y = -6
	elif Input.is_action_just_released("crouch") and is_on_floor():
		if curr_state != 0:
			shape.shape.set_size(Vector2(12,24))
			shape.position.y = -12

	dir = Input.get_axis('left', 'right')
	if dir != 0.0:
		velocity.x = move_toward(velocity.x, dir * MAX_SPEED, ACCEL * delta)
	if dir == 0.0:
		velocity.x = move_toward(velocity.x, 0, ACCEL * delta)

	if Input.is_key_pressed(KEY_Q):
		set_big()
	if Input.is_key_pressed(KEY_E):
		set_small()

	move_and_slide()

func set_small():
	curr_state = 0
	shape.shape.set_size(Vector2(12,12))
	shape.position.y = -6
	small_mario.visible = true
	big_mario.visible = false

func set_big():
	curr_state = 1
	shape.shape.set_size(Vector2(12,24))
	shape.position.y = -12
	small_mario.visible = false
	big_mario.visible = true
