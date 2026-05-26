extends Node2D

var bat = preload("res://scenes/bat.tscn")

func _ready() -> void:
	$Player.input_locked = true
	$Player.arrows = 32
	$CanvasLayer/EscMenu.visible = false
	await get_tree().create_timer(0.25).timeout
	var tween = create_tween()
	tween.tween_property($Player/Camera2D, "zoom", Vector2(0.7, 0.7), 1)
	await get_tree().create_timer(0.25).timeout
	$AnimationPlayer.play("start")
	await get_tree().create_timer(3.0).timeout
	var tween2 = create_tween()
	tween2.tween_property($Player/Camera2D, "zoom", Vector2(0.9, 0.9), 1)

func _on_too_far_down_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().reload_current_scene()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		$CanvasLayer/EscMenu.visible = not $CanvasLayer/EscMenu.visible

func _on_back_to_game_button_pressed() -> void:
	$CanvasLayer/EscMenu.visible = false

func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
