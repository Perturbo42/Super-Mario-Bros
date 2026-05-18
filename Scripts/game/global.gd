extends Node
var mario: Mario
var game: Game
var camera: Camera2D
var same_level: bool = false
var lives: int = 3
var coin: int = 0
var mario_form: MarioForm = MarioForm.SMALL
var level_timer: int
var target_marker_name: String = "Spawn"

enum MarioForm {
	SMALL,
	BIG,
	FIRE
}
