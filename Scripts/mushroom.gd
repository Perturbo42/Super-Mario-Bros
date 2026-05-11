class_name Mushroom extends Item
@export var state: int = 0
var dir: Vector2
var speed: float

func _ready() -> void:
	$Sprite2D.frame = state
	dir = Vector2.RIGHT
	speed = 80

func _physics_process(delta: float) -> void:
	if is_on_wall():
		dir.x *= -1
	
	velocity = dir * speed 
	if not is_on_floor():
		velocity.y += 490
	move_and_slide()
