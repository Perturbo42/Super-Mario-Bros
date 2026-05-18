class_name Flower extends Item
@onready var area2D: Area2D = $Area2D
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D


func _ready() -> void:
	area2D.monitoring = false
	sprite_2d.play("default")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += 490
	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.owner is Mario:
		var mario = area.owner
		if mario.curr_form == Mario.MarioForm.SMALL:
			mario.apply_form(mario.MarioForm.BIG)
		elif mario.curr_form == Mario.MarioForm.BIG:
			mario.apply_form(mario.MarioForm.FIRE)
		queue_free()
	pass # Replace with function body.

func spawned_from_brick():
	#tween up 32 spaces 
	var tween = create_tween()
	tween.tween_property(self, "position", self.global_position + Vector2.UP * 32, 0.5)
	await tween.finished
	area2D.monitoring = true
