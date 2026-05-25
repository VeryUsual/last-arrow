extends Control

func _ready() -> void:
	$AnimationPlayer.play("startup")

func to_main_menu_scene():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
