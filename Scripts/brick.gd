class_name Brick extends StaticBody2D
@onready var bounce_timer: Timer = $Bounce
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var brick_state: int
#0 = Hit, 1 = Brick, 2 = Question Mark
@export var contains: int
#0 = Nothing, 1 = Coin, 2 = Mushroom/Flower, 3 = Star
var y_speed: float = 0.0
var og_pos: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if brick_state == 1:
		sprite_2d.play("BrickBlock")
	if brick_state == 2:
		sprite_2d.play("QuestionBlock")
	og_pos = sprite_2d.position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if bounce_timer.is_stopped():
		sprite_2d.position.y = og_pos.y
		y_speed = 0.0
	else:
		sprite_2d.position.y += y_speed * delta
		y_speed += 3600.0 * delta
	
	pass

func bounce():
	y_speed = -240.0
	bounce_timer.start()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if brick_state == 2:
		bounce()
	pass # Replace with function body.


func _on_bounce_timeout() -> void:
	brick_state = 0
	sprite_2d.play("HitBlock")
	pass # Replace with function body.
