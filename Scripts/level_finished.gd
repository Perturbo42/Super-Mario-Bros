class_name Level_Finished extends Area2D
@export_file("*.tscn") var next_level_path: String
var is_changing_scene: bool = false


func _on_area_entered(area: Area2D) -> void:
	if is_changing_scene:
		return
	
	if area.owner is Mario:
		is_changing_scene = true
		var mario = area.owner
		Global.mario_form = Global.mario.curr_form
		Global.target_marker_name = "Spawn"
		Global.same_level = false
		get_tree().call_deferred("change_scene_to_file", next_level_path)
	pass # Replace with function body.
