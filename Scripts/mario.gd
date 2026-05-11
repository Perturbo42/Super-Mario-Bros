class_name Mario extends CharacterBody2D
signal dead
@onready var small_coll: CollisionShape2D = $"Small Collision"
@onready var big_coll: CollisionShape2D = $"Big Collision"
@onready var small_area: Area2D = $"Small Mario/Small Area"
@onready var big_area: Area2D = $"Big Mario/Big Area"
@onready var small_head: Area2D = $"Small Mario/Small Head"
@onready var big_head: Area2D = $"Big Mario/Big Head"
@onready var small_mario: Node2D = $"Small Mario"
@onready var big_mario: Node2D = $"Big Mario"
const ACCEL = 1200
const MAX_SPEED = 250
const JUMP_FORCE: float = 500

var active_area: int
var state_list : Array[int] = [0, 1, 2] 
#0 = small, 1 = big, 2 = fire
var curr_state: int = 0 
var jump_time: float = 0.0 
var dir: float = 0.0

func _ready() -> void: 
	Global.mario = self
	curr_state = 0
	set_small()

func _physics_process(delta: float) -> void:
	if curr_state == -1:
		return
	# Add the gravity.
	if not is_on_floor():
		velocity.y += get_gravity().y * delta

	# Handle jump.
	if Input.is_action_just_pressed('jump') and is_on_floor():
		velocity.y = -JUMP_FORCE
	
	
	#Handle Crouch
	if Input.is_action_just_pressed("crouch") and is_on_floor():
		small_head.monitorable = true
		big_head.monitorable = false
		small_coll.set_deferred("disabled", false)
		big_coll.set_deferred("disabled", true)
		active_area = 0
	elif Input.is_action_just_released("crouch") and is_on_floor():
		if curr_state != 0:
			small_head.monitorable = false
			big_head.monitorable = true
			small_coll.set_deferred("disabled", true)
			big_coll.set_deferred("disabled", false)
			active_area = 1

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
	active_area = 0
	small_head.set_deferred("monitorable", true)
	big_head.set_deferred("monitorable", false)
	small_coll.set_deferred("disabled", false)
	big_coll.set_deferred("disabled", true)
	small_mario.visible = true
	big_mario.visible = false

func set_big():
	curr_state = 1
	active_area = 1
	small_head.set_deferred("monitorable", false)
	big_head.set_deferred("monitorable", true)
	small_coll.set_deferred("disabled", true)
	big_coll.set_deferred("disabled", false)
	small_mario.visible = false
	big_mario.visible = true

func take_damage():
	if curr_state == 0:
		die()
	elif curr_state == 1 or curr_state == 2:
		set_small()

func die():
	curr_state = -1
	dead.emit()
	
	pass

func _on_any_area_entered(area: Area2D, hit: int) -> void:
	if hit != active_area:
		return
	if area.owner is Enemy:
		var enemy = area.owner
		if enemy.is_alive:
			if velocity.y > 0:
				enemy.die()
				if Input.is_action_pressed("jump"):
					velocity.y = -JUMP_FORCE
				else:
					velocity.y = -JUMP_FORCE/2
			else:
				take_damage()
	pass # Replace with function body.
