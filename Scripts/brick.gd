class_name Brick extends StaticBody2D
@onready var bounce_timer: Timer = $Bounce
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var coin: AnimatedSprite2D = $Coin

@export var brick_state: int
#0 = Hit, 1 = Brick, 2 = Question Mark
@export var contains: int
#0 = Nothing, 1 = Coin, 2 = Mushroom/Flower, 3 = Star
var y_speed: float = 0.0
var coin_speed: float = 0.0
var og_pos: Vector2
var coin_pos: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coin.visible = false
	if brick_state == 1:
		sprite_2d.play("BrickBlock")
	if brick_state == 2:
		sprite_2d.play("QuestionBlock")
	og_pos = sprite_2d.position
	coin_pos = coin.position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if bounce_timer.is_stopped():
		sprite_2d.position.y = og_pos.y
		y_speed = 0.0

	else:
		sprite_2d.position.y += y_speed * delta
		y_speed += 3600.0 * delta
	
	if coin.visible:
		coin.position.y += coin_speed * delta
		coin_speed += 1800.0 * delta
		if coin.position.y > coin_pos.y:
			coin_speed = 0.0
			coin.visible = false
	
	pass

func bounce():
	if brick_state == 1:
		sprite_2d.visible = false
		$CollisionShape2D.set_deferred("disabled", true)
	if contains == 1:
		coin.visible = true
		coin.play("default")
		coin_speed = -360.00
	elif contains == 2:
		if Global.mario.curr_state == 0:
			var mushroom = preload("res://Scenes/mushroom.tscn").instantiate()
			mushroom.position = self.position
			mushroom.spawned_from_brick()
			get_tree().current_scene.call_deferred("add_child", mushroom)
		elif Global.mario.curr_state == 1:
			var flower = preload("res://Scenes/flower.tscn").instantiate()
			flower.position = self.position
			flower.spawned_from_brick()
			get_tree().current_scene.call_deferred("add_child", flower)
	y_speed = -240.0
	bounce_timer.start()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if brick_state != 0:
		bounce()
	pass # Replace with function body.


func _on_bounce_timeout() -> void:
	if brick_state == 2:
		brick_state = 0
		sprite_2d.play("HitBlock")
	$"AnimatedSprite2D/Enemy Kill Box".monitoring = false
	
	pass # Replace with function body.


func _on_enemy_kill_box_area_entered(area: Area2D) -> void:
	if area.owner is Enemy:
		var enemy = area.owner
		enemy.flip()
	pass # Replace with function body.
