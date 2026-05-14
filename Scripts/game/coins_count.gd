class_name Coins_count extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.game == null:
		await get_tree().process_frame
	Global.game.coins_update.connect(update)
	update()
	pass # Replace with function body.


func update():
	self.text = "x " + str(Global.coin)
	pass
