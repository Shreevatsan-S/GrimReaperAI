extends TileMap

var count = 0;


func _physics_process(delta):
	if(Input.is_action_just_pressed("click") and count<3):
		var tile : Vector2 = world_to_map((get_global_mouse_position()))
		set_cellv(tile,2)
		count = count + 1
