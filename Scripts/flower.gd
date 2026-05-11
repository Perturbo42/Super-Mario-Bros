class_name Flower extends Item
@onready var area2D: Area2D = $Area2D

func _ready() -> void:
	area2D.monitoring = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += 490
	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.owner is Mario:
		var mario = area.owner
		if mario.curr_state == 0:
			mario.set_big()
		elif mario.curr_state == 1:
			mario.fire_flower()
		queue_free()
	pass # Replace with function body.

func spawned_from_brick():
	#tween up 32 spaces 
	var tween = create_tween()
	tween.tween_property(self, "position", self.global_position + Vector2.UP * 32, 0.5)
	await tween.finished
	area2D.monitoring = true
