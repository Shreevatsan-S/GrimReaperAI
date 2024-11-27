extends KinematicBody2D

export(int) var SPEED: int = 60

# List to track blocked tiles
var blocked_tiles: Array = []

# Initial spawn position
var spawn_position: Vector2 = Vector2(250, 140)

# On ready, set the player's position to spawn position
func _ready():
	position = spawn_position

# Handle player clicks on tiles
func _on_player_click(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		# Get the position of the clicked tile based on the shape index
		var clicked_tile_pos = get_tile_position_from_shape(shape_idx)
		
		# Block the tile if it's not already blocked and the player hasn't blocked 3 tiles
		if blocked_tiles.size() < 3:
			blocked_tiles.append(clicked_tile_pos)
			print("Tile blocked at:", clicked_tile_pos)

# Function to convert shape index to tile position
func get_tile_position_from_shape(shape_idx):
	return Vector2(shape_idx % 10, shape_idx / 10)
