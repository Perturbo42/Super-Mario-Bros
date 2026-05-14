class_name Level_name extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.game == null:
		await get_tree().process_frame
	self.text = Global.game.level_name
	pass # Replace with function body.
