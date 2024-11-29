extends Control

var mode = ""

func _on_Easy_pressed():
	Global.mode = "easy"
	get_tree().change_scene("res://Level.tscn")
	
func _on_Medium_pressed():
	Global.mode = "medium"
	get_tree().change_scene("res://Level.tscn")
	
func _on_Hard_pressed():
	Global.mode = "hard"
	get_tree().change_scene("res://Level.tscn")
