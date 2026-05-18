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
@onready var fireball_pos: Marker2D = $"Big Mario/Fireball"

const ACCEL = 1200
const MAX_SPEED = 250
const JUMP_FORCE: float = 500
const DEATH_GRAVITY = 980.0
const FLAG_SLIDE_SPEED = 256
enum MarioForm {
	SMALL,
	BIG,
	FIRE
}
enum PlayerState {
	NORMAL,
	CROUCH,
	DEAD,
	FLAGPOLE
}
var curr_form = MarioForm.SMALL
var curr_state = PlayerState.NORMAL

var active_area: int
var jump_time: float = 0.0 
var invincible: bool = false
var num_of_fireballs: int = 0

var dir: float = 0.0

# jump input
var jump_pressed: bool = false
var jump_released: bool = false
var jump_held: bool = false

# crouch input
var crouch_pressed: bool = false
var crouch_held: bool = false
var crouch_released: bool = false

# action/run input
var run_held: bool = false
var action_pressed: bool = false

func _ready() -> void: 
	Global.mario = self
	curr_form = Global.mario_form
	change_form()
	var marker = get_tree().current_scene.find_child(Global.target_marker_name, true, false)
	global_position = marker.global_position
	curr_anim().play("default")

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_E):
		global_position.x = 6000
		global_position.y = 0

func _physics_process(delta: float) -> void:
	read_input()
	handle_state(delta)
	
	if curr_state == PlayerState.DEAD:
		move_and_slide()
		return
	if curr_state == PlayerState.FLAGPOLE:
		move_and_slide()
		return
	
	handle_horiz(delta)
	handle_gravity(delta)
	handle_jump()
	handle_actions()
	
	handle_anim()
	
	if Input.is_key_pressed(KEY_Q):
		set_big()
		fire_flower()
	
	move_and_slide()

func read_input():
	dir = Input.get_axis("left", "right")
	
	jump_pressed = Input.is_action_just_pressed("jump")
	jump_released = Input.is_action_just_released("jump")
	jump_held = Input.is_action_pressed("jump")
	
	crouch_pressed = Input.is_action_just_pressed("crouch")
	crouch_released = Input.is_action_just_released("crouch")
	crouch_held = Input.is_action_pressed("crouch")
	
	run_held = Input.is_action_pressed("action")
	action_pressed = Input.is_action_just_pressed("action")

func handle_state(delta: float):
	match curr_state:
		PlayerState.NORMAL:
			handle_normal_state()
		
		PlayerState.CROUCH:
			handle_crouch_state()
		
		PlayerState.DEAD:
			handle_dead_state(delta)
		
		PlayerState.FLAGPOLE:
			handle_flagpole_state(delta)

func handle_normal_state():
	if crouch_held and is_on_floor() and curr_form != MarioForm.SMALL:
		enter_crouch_state()

func handle_crouch_state():
	if !crouch_held:
		exit_crouch_state()

func enter_crouch_state():
	curr_state = PlayerState.CROUCH
	small_head.monitorable = true
	big_head.monitorable = false
	small_coll.set_deferred("disabled", false)
	big_coll.set_deferred("disabled", true)
	active_area = 0

func exit_crouch_state():
	curr_state = PlayerState.NORMAL
	small_head.monitorable = false
	big_head.monitorable = true
	small_coll.set_deferred("disabled", true)
	big_coll.set_deferred("disabled", false)
	active_area = 1

func handle_dead_state(delta: float):
	velocity.x = 0
	velocity.y += DEATH_GRAVITY * delta
	if position.y >= 550:
		set_physics_process(false)
		dead.emit()

func handle_flagpole_state(_delta: float):
	velocity.x = 0
	velocity.y = FLAG_SLIDE_SPEED

func handle_horiz(delta: float):
	if dir != 0.0:
		velocity.x = move_toward(velocity.x, dir * MAX_SPEED, ACCEL * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, ACCEL * delta)

func handle_gravity(delta):
	if not is_on_floor():
		velocity.y += get_gravity().y * delta

func handle_jump():
	if jump_pressed and is_on_floor():
		velocity.y = -JUMP_FORCE

func handle_actions():
	if action_pressed and !crouch_held:
		if curr_form == MarioForm.FIRE:
			fireball()

func handle_anim():
	if not is_on_floor():
		play_anim("jump")
		return
	
	if velocity.x < -5:
		curr_anim().flip_h = true
	elif velocity.x > 5:
		curr_anim().flip_h = false
	
	if curr_state == PlayerState.DEAD:
		play_anim("dead")
		return
	if curr_state == PlayerState.CROUCH:
		play_anim("crouch")
		return
	if abs(velocity.x) > 5:
		play_anim("walk")
	else:
		play_anim("default")

func play_anim(anim_name: String):
	if curr_anim().animation != anim_name:
		curr_anim().play(anim_name)

func set_small():
	var anim = curr_anim().animation
	curr_form = MarioForm.SMALL
	active_area = 0
	small_head.set_deferred("monitorable", true)
	big_head.set_deferred("monitorable", false)
	small_coll.set_deferred("disabled", false)
	big_coll.set_deferred("disabled", true)
	small_mario.visible = true
	big_mario.visible = false
	curr_anim().play(anim)
	

func set_big():
	var anim = curr_anim().animation
	curr_form = MarioForm.BIG
	active_area = 1
	small_head.set_deferred("monitorable", false)
	big_head.set_deferred("monitorable", true)
	small_coll.set_deferred("disabled", true)
	big_coll.set_deferred("disabled", false)
	small_mario.visible = false
	big_mario.visible = true
	curr_anim().play(anim)

func fire_flower():
	var anim = curr_anim().animation
	curr_form = MarioForm.FIRE
	anim_big_mario.visible = false
	anim_fire_mario.visible = true
	curr_anim().play(anim)


func take_damage():
	if invincible:
		return
	else:
		if curr_form == MarioForm.SMALL:
			die()
		elif curr_form == MarioForm.BIG or curr_form == MarioForm.FIRE:
			invincible = true
			set_small()
			anim_big_mario.visible = true
			anim_fire_mario.visible = false
			await get_tree().create_timer(1.0).timeout
			invincible = false

func die():
	if curr_state == PlayerState.DEAD:
		return
	set_small()
	curr_state = PlayerState.DEAD
	small_coll.set_deferred("disabled", true)
	big_coll.set_deferred("disabled", true)
	small_head.set_deferred("monitorable", false)
	velocity.y = -360
	pass

func _on_any_area_entered(area: Area2D, hit: int) -> void:
	if hit != active_area or curr_state == PlayerState.DEAD:
		return
	if area.owner is Enemy:
		var enemy = area.owner
		if enemy.is_alive:
			if velocity.y > 0:
				enemy.die()
				if jump_held:
					velocity.y = -JUMP_FORCE
				else:
					velocity.y = -JUMP_FORCE/2
			else:
				take_damage()
	pass # Replace with function body.

func change_form():
	if curr_form == MarioForm.SMALL:
		set_small()
	elif curr_form == MarioForm.BIG:
		set_big()
	elif curr_form == MarioForm.FIRE:
		set_big()
		fire_flower()

func curr_anim() -> AnimatedSprite2D:
	if curr_form == MarioForm.SMALL:
		return anim_small_mario
	elif curr_form == MarioForm.BIG:
		return anim_big_mario
	elif curr_form == MarioForm.FIRE:
		return anim_fire_mario
	return null

func fireball():
	if num_of_fireballs <2:
		num_of_fireballs += 1
		var fireball = preload("res://Scenes/fireball.tscn").instantiate()
		fireball.global_position = fireball_pos.global_position
		if !curr_anim().flip_h:
			fireball.dir = 1
		else:
			fireball.dir = -1
			fireball.global_position.x -= 24
		print(fireball.global_position)
		fireball.init_speed = velocity.x
		fireball.exploded.connect(func(): num_of_fireballs -= 1)
		get_tree().current_scene.call_deferred("add_child", fireball)
		pass

func level_finished(pos: Vector2):
	scale.x *= -1
	global_position = pos
	Global.camera.stop = true
	await get_tree().create_timer(1).timeout
	scale.x *= -1
	curr_anim().play("walk")
	velocity.x = 200
