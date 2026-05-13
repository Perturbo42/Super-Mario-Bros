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
@onready var anim_small_mario: AnimatedSprite2D = $"Small Mario/Anim (Small Mario)"
@onready var anim_big_mario: AnimatedSprite2D = $"Big Mario/Anim (Big Mario)"
@onready var anim_fire_mario: AnimatedSprite2D = $"Big Mario/Anim(Fire Mario)"

const ACCEL = 1200
const MAX_SPEED = 250
const JUMP_FORCE: float = 500

var active_area: int
var state_list : Array[int] = [0, 1, 2] 
#0 = small, 1 = big, 2 = fire, -1 = dead
var curr_state: int = 0 
var jump_time: float = 0.0 
var dir: float = 0.0
var invincible: bool = false

func _ready() -> void: 
	Global.mario = self
	curr_state = Global.mario_state
	change_state()
	var marker = get_tree().current_scene.find_child(Global.target_marker_name, true, false)
	global_position = marker.global_position
	curr_anim().play("default")

func _physics_process(delta: float) -> void:
	move_and_slide()
	
	#if mario is dead
	if curr_state == -1:
		anim_small_mario.play("dead")
		velocity.x = 0
		velocity.y += 980 * delta
		return
	
	#moving left and right
	dir = Input.get_axis('left', 'right')
	if dir != 0.0:
		velocity.x = move_toward(velocity.x, dir * MAX_SPEED, ACCEL * delta)
	if dir == 0.0:
		velocity.x = move_toward(velocity.x, 0, ACCEL * delta)
	#animation for moving left and right
	if is_on_floor():
		if velocity.x < -0.05:
			curr_anim().play("walk")
			curr_anim().flip_h = true
		elif velocity.x > 0.05:
			curr_anim().play("walk")
			curr_anim().flip_h = false
		else:
			curr_anim().play("default")
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += get_gravity().y * delta

	# Handle jump.
	if Input.is_action_just_pressed('jump') and is_on_floor():
		velocity.y = -JUMP_FORCE
		curr_anim().play("jump")
	
	
	#Handle Crouch
	if Input.is_action_just_pressed("crouch") and is_on_floor():
		if curr_state != 0:
			curr_anim().play("crouch")
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
	
	if Input.is_key_pressed(KEY_Q):
		set_big()
	if Input.is_key_pressed(KEY_E):
		set_small()
	
	

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

func fire_flower():
	curr_state = 2
	anim_big_mario.visible = false
	anim_fire_mario.visible = true


func take_damage():
	if invincible:
		return
	else:
		if curr_state == 0:
			die()
		elif curr_state == 1 or curr_state == 2:
			invincible = true
			set_small()
			anim_big_mario.visible = true
			anim_fire_mario.visible = false
			await get_tree().create_timer(1.0).timeout
			invincible = false

func die():
	curr_state = -1
	small_coll.set_deferred("disabled", true)
	big_coll.set_deferred("disabled", true)
	velocity.y = -360
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

func change_state():
	if curr_state == 0:
		set_small()
	elif curr_state == 1:
		set_big()
	elif curr_state == 2:
		set_big()
		fire_flower()

func curr_anim() -> AnimatedSprite2D:
	if curr_state == 0:
		return anim_small_mario
	elif curr_state == 1:
		return anim_big_mario
	elif curr_state == 2:
		return anim_fire_mario
	return null
