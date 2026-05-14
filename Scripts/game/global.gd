extends Node
var mario: Mario
var game: Game
var camera: Camera2D
var same_level: bool = false
var lives: int = 3
var coin: int = 0
var mario_state: int = 0
var level_timer: int
var target_marker_name: String = "Spawn"
