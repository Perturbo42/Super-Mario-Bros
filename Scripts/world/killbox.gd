class_name Killzone extends Area2D

func _on_area_entered(area: Area2D) -> void:
	if area.owner is Mario:
		Global.mario.die()
	pass # Replace with function body.
