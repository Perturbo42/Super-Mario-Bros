class_name Mushroom extends Item
@onready var area: Area2D = $Area2D
@export var state: int = 0
#state: mushroom = 0, life = 1
var dir: Vector2
var speed: float

func _ready() -> void:
	area.monitoring = false
	$Sprite2D.frame = state
	dir = Vector2.RIGHT
	speed = 80

func _physics_process(delta: float) -> void:
	if is_on_wall():
		dir.x *= -1
	
	velocity = dir * speed 
	if not is_on_floor():
		velocity.y += 490
	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.owner is Mario:
		var mario = area.owner
		if state == 0:
			if mario.curr_state == 0:
				mario.set_big()
		elif state == 1:
			Global.lives += 1
		queue_free()
	pass # Replace with function body.

func spawned_from_brick():
	#tween up 32 spaces 
	var tween = create_tween()
	tween.tween_property(self, "position", self.global_position + Vector2.UP * 32, 0.5)
	await tween.finished
	area.monitoring = true
