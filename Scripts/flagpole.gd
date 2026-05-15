class_name Flagpole extends Node2D
@onready var flag: Sprite2D = $Flag
@onready var marker: Marker2D = $Marker2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.owner is Mario:
		var mario = area.owner
		if !mario.is_on_flag:
			mario.velocity = Vector2.ZERO
			mario.is_on_flag = true
			mario.curr_anim().play("poll_grab")
			var tween = create_tween()
			tween.tween_property(flag, "position", Vector2(-9,-24), 1).set_trans(Tween.TRANS_LINEAR)
			await tween.finished
			mario.level_finished(marker.global_position)
	pass # Replace with function body.
