extends KinematicBody2D

export(int) var SPEED: int = 60

onready var tile_map = $"../LevelNavigation/TileMap"

var blocked_tiles: Array = []

var ground_layer = 1

var spawn_position: Vector2 = Vector2(250, 140)

func _ready():
	position = spawn_position
	
