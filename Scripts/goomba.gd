class_name Goomba extends Enemy

func _ready() -> void:
	super._ready()
	dir = Vector2.LEFT
	speed = 80

func _process(delta: float) -> void:
	super._process(delta)
	if !loaded:
		return

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if !loaded:
		return
	if is_on_wall():
		dir.x *= -1
	
	velocity = dir * speed 
	if not is_on_floor():
		velocity.y += 490
	move_and_slide()
