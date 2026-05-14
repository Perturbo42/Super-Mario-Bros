class_name Brick extends StaticBody2D
@onready var bounce_timer: Timer = $Bounce
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var coin: AnimatedSprite2D = $Coin
@onready var area_2d: Area2D = $Area2D

@export var brick_state: int
#0 = Hit, 1 = Brick, 2 = Question Mark, -1 = invisible
@export var contains: int
#0 = Nothing, 1 = Coin, 2 = Mushroom/Flower, 3 = 1_UP
var y_speed: float = 0.0
var coin_speed: float = 0.0
var og_pos: Vector2
var coin_pos: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coin.visible = false
	if brick_state == -1:
		sprite_2d.play("HitBlock")
		sprite_2d.visible = false
	elif brick_state == 1:
		sprite_2d.play("BrickBlock")
	elif brick_state == 2:
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
	if contains == 1:
		coin.visible = true
		coin.play("default")
		coin_speed = -360.00
		Global.game.update_coins(1)
	
	#Brick state
	if brick_state == -1:
		sprite_2d.visible = true
	elif brick_state == 1:
		if contains == 0 or contains == 1:
			area_2d.set_deferred("monitoring", false)
			sprite_2d.visible = false
			$CollisionShape2D.set_deferred("disabled", true)
		else:
			brick_state = 2
	
	y_speed = -240.0
	bounce_timer.start()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if brick_state != 0:
		bounce()
	pass # Replace with function body.


func _on_bounce_timeout() -> void:
	#Contains
	if contains == 2:
		if Global.mario.curr_state == 0:
			var mushroom = preload("res://Scenes/items/mushroom.tscn").instantiate()
			mushroom.position = self.position
			mushroom.spawned_from_brick()
			get_tree().current_scene.call_deferred("add_child", mushroom)
		elif Global.mario.curr_state == 1 or Global.mario.curr_state == 2:
			var flower = preload("res://Scenes/items/flower.tscn").instantiate()
			flower.position = self.position
			flower.spawned_from_brick()
			get_tree().current_scene.call_deferred("add_child", flower)
	elif contains == 3:
		var mushroom = preload("res://Scenes/items/mushroom.tscn").instantiate()
		mushroom.position = self.position
		mushroom.spawned_from_brick()
		mushroom.state = 1
		get_tree().current_scene.call_deferred("add_child", mushroom)
	
	if brick_state == -1:
		brick_state = 0
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
