class_name Level_Timer extends Label
@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.game == null:
		await get_tree().process_frame
	self.text = str(Global.level_timer)
	timer.start()
	pass # Replace with function body.

func _on_timer_timeout() -> void:
	Global.level_timer -= 1
	self.text = str(Global.level_timer)
	if Global.level_timer <= 0:
		Global.game.mario_died()
	pass # Replace with function body.
