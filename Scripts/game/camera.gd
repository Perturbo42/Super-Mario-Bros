class_name Camera extends Camera2D
var last_pos: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.camera = self
	global_position.y = 240
	last_pos = global_position.x
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.x = Global.mario.global_position.x 
	if Global.mario.global_position.x < last_pos :
		global_position.x = last_pos
	last_pos = global_position.x
	pass


func _on_right_side_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.loaded = true
	pass # Replace with function body.
