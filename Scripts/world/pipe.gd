class_name Pipe extends Area2D
@export_enum("crouch", "up", "right", "left") var req_act: String
@export_file("*.tscn") var level_path: String
@export var target_marker: String 
@export var same: bool
var is_changing_scene: bool = false

func _process(delta: float) -> void:
	if is_changing_scene:
		return
	for areas in get_overlapping_areas():
		if areas.owner is Mario:
			if Input.is_action_pressed(req_act) and areas.owner.is_on_floor():
				is_changing_scene = true
				Global.mario_state = Global.mario.curr_state
				Global.target_marker_name = target_marker
				Global.same_level = same
				get_tree().call_deferred("change_scene_to_file", level_path)
				break
