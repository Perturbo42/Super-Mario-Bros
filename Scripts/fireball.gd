class_name Fireball extends CharacterBody2D
signal explode
var dir

func _ready() -> void:
	

func _physics_process(delta: float) -> void:
	move_and_slide()
