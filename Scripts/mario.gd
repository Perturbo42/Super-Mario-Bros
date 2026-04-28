class_name Mario extends CharacterBody2D
@onready var shape: CollisionShape2D = $Collision
@onready var small_mario: Node2D = $"Small Mario"
@onready var big_mario: Node2D = $"Big Mario"

var state_list : Array[int] = [0, 1, 2]
var curr_state: int
const ACCEL = 30
const FRICTION = 0.75
const MAX_SPEED = 250
const JUMP_VELOCITY = -300.0
const GRAVITY = 900

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	
	if Input.is_action_just_pressed("crouch") and is_on_floor():
		shape.shape.set_size(Vector2(12,12))
		shape.position.y = -6
	elif Input.is_action_just_released("crouch") and is_on_floor():
		if curr_state != 0:
			shape.shape.set_size(Vector2(12,24))
			shape.position.y = -12

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	if Input.is_action_pressed("right"):
		velocity += ACCEL * Vector2.RIGHT
	elif Input.is_action_pressed("left"):
		velocity += ACCEL * Vector2.LEFT
	else:
		velocity.x *= FRICTION
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)

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
