extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var mode = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Easy_pressed():
	Global.mode = "easy"
	get_tree().change_scene("res://Level.tscn")
	
func _on_Medium_pressed():
	Global.mode = "medium"
	get_tree().change_scene("res://Level.tscn")
	
func _on_Hard_pressed():
	Global.mode = "hard"
	get_tree().change_scene("res://Level.tscn")
