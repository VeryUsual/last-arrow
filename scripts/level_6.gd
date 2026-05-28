extends Node2D

var bat = preload("res://scenes/bat.tscn")
var start_time: int

func _ready() -> void:
	$Player.arrows = Globals.arrows["basic"]
	$Player.ricochet_arrows = Globals.arrows["ricochet"]
	if ($Player.arrows + $Player.ricochet_arrows) <= 4:
		var tween = create_tween()
		tween.tween_property($Player/Camera2D, "zoom", Vector2(0.4, 0.4), 1)
		await get_tree().create_timer(1.0).timeout
		Globals.next_scene = "res://scenes/level6.tscn"
		get_tree().change_scene_to_file("res://scenes/shop.tscn")
	start_time = Time.get_ticks_msec()
	$CanvasLayer/EscMenu.visible = false

func _on_too_far_down_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().reload_current_scene()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		$CanvasLayer/EscMenu.visible = not $CanvasLayer/EscMenu.visible
	if find_children("Target*", "Node").size() == 0:
		Globals.completion_times[6] = (Time.get_ticks_msec() - start_time) / 1000
		Globals.current_chapter = 2
		Globals.next_scene = "res://scenes/main_menu.tscn"
		get_tree().change_scene_to_file("res://scenes/chapter_completed.tscn")

func _on_back_to_game_button_pressed() -> void:
	$CanvasLayer/EscMenu.visible = false

func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
