class_name Coin extends Area2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	anim.play("default")


func _on_area_entered(area: Area2D) -> void:
	if area.owner is Mario:
		Global.coin += 1
		queue_free()
	pass # Replace with function body.
