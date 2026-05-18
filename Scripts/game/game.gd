class_name Game extends Node2D
signal lives_update
signal coins_update
@export var level_name: String
@export var level_timer: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.game = self
	Global.mario.dead.connect(mario_died)
	if Global.same_level == false:
		Global.level_timer = level_timer
	pass # Replace with function body.

func mario_died():
	update_lives(-1)
	Global.same_level = false
	Global.target_marker_name = "Spawn"
	get_tree().call_deferred("reload_current_scene")
	pass

func update_lives(n: int):
	Global.lives += n
	lives_update.emit()

func update_coins(n: int):
	Global.coin += n
	if Global.coin == 100:
		Global.coin = 0
		update_lives(1)
	coins_update.emit()
