class_name Fireball extends CharacterBody2D
signal exploded
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

var dir
var init_speed
var SPEED = 12800
var og_pos: Vector2
var is_exploding: bool = false
var queue_explode: bool = false
func _ready() -> void:
	og_pos = global_position
	anim_sprite.play("default")
	if dir == -1:
		anim_sprite.flip_h = true

func _physics_process(delta: float) -> void:
	if is_exploding:
		return
	move_and_slide()
	velocity.x = init_speed + SPEED * dir * delta
	
	if is_on_floor():
		if queue_explode:
			explode()
			return
		velocity.y = -240
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
	
	if is_on_wall():
		explode()
	if global_position.y >= 490:
		explode()
	if global_position.x <= og_pos.x - 257 or global_position.x >= og_pos.x + 257 :
		queue_explode = true

func explode():
	if is_exploding:
		return
	is_exploding = true
	velocity = Vector2.ZERO
	exploded.emit()
	anim_sprite.play("explode")
	await anim_sprite.animation_finished
	queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.owner is Enemy:
		area.owner.flip()
		explode()
	pass # Replace with function body.
