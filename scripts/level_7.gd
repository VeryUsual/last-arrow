extends Node2D

var bat = preload("res://scenes/bat.tscn")
var start_time: int

func _ready() -> void:
	$Player.arrows = 5
	$Player.ricochet_arrows = 9
	start_time = Time.get_ticks_msec()
	$CanvasLayer/EscMenu.visible = false

func _on_too_far_down_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().reload_current_scene()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		$CanvasLayer/EscMenu.visible = not $CanvasLayer/EscMenu.visible
	if find_children("Target*", "Node").size() == 0:
		Globals.completion_times[7] = (Time.get_ticks_msec() - start_time) / 1000
		get_tree().change_scene_to_file("res://scenes/level8.tscn")

func _on_back_to_game_button_pressed() -> void:
	$CanvasLayer/EscMenu.visible = false

func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
