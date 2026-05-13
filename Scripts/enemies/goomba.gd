class_name Goomba extends Enemy
@onready var sprite: Sprite2D = $Sprite2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var hitbox: Area2D = $Hitbox

func _ready() -> void:
	super._ready()
	dir = Vector2.LEFT
	speed = 80

func _process(delta: float) -> void:
	super._process(delta)
	if !loaded or !is_alive:
		return
	
	anim_player.play("walk")

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	move_and_slide()
	if !loaded:
		return
		
	if !is_alive:
		if sprite.flip_v == true:
			velocity.y += 980 * delta
		else:
			velocity.x = 0
		return
	
	if is_on_wall():
		dir.x *= -1
	
	velocity.x = dir.x * speed 
	if not is_on_floor():
		velocity.y += 980 * delta
	

func die():
	super.die()
	is_alive = false
	hitbox.set_deferred("monitorable", false)
	hitbox.set_deferred("monitoring", false)
	$CollisionShape2D.set_deferred("disabled", true)
	anim_player.stop()
	anim_player.play("dead")
	await anim_player.animation_finished
	queue_free()

func flip():
	super.flip()
	is_alive = false
	velocity.x = dir.x * 40
	velocity.y = -260
	sprite.flip_v = true
	
	hitbox.set_deferred("monitorable", false)
	hitbox.set_deferred("monitoring", false)
	$CollisionShape2D.set_deferred("disabled", true)
	
	anim_player.stop()
	anim_player.play("flipped")
	await anim_player.animation_finished
	queue_free()
