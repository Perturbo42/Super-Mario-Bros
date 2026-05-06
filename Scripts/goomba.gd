class_name Goomba extends Enemy
@onready var anim_player: AnimationPlayer = $AnimationPlayer

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
	if !loaded or !is_alive:
		return
	if is_on_wall():
		dir.x *= -1
	
	velocity = dir * speed 
	if not is_on_floor():
		velocity.y += 490
	move_and_slide()

func die():
	super.die()
	is_alive = false
	$Hitbox/CollisionShape2D.set_deferred("disabled", true)
	$CollisionShape2D.set_deferred("disabled", true)
	anim_player.stop()
	anim_player.play("dead")
	await anim_player.animation_finished
	queue_free()
