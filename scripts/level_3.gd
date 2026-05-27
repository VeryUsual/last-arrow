extends Node2D

var bat = preload("res://scenes/bat.tscn")
var pastlockedgate = false
var goodorder = false
var start_time: int

func _ready() -> void:
	start_time = Time.get_ticks_msec()
	
	$CanvasLayer/EscMenu.visible = false
	$TheLockedGateLabel2.visible = false
	
	await get_node("Target3").tree_exited

	if get_node_or_null("Target") != null:
		await get_node("Target").tree_exited
	else:
		if get_tree():
			get_tree().reload_current_scene()
	
	if get_node_or_null("Target2") != null:
		await get_node("Target2").tree_exited
	else:
		if get_tree():
			get_tree().reload_current_scene()
	
	goodorder = true

func _on_too_far_down_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().reload_current_scene()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		$CanvasLayer/EscMenu.visible = not $CanvasLayer/EscMenu.visible
	if get_node_or_null("TheLockedGateLabel") != null:
		if $Player.global_position.x > $TheLockedGateLabel.global_position.x and pastlockedgate == false:
			pastlockedgate = true
			var tween = create_tween()
			tween.tween_property($TheLockedGateLabel, "modulate:a", 0, 1.5)
			tween.tween_callback($TheLockedGateLabel.queue_free)
			await get_tree().create_timer(1.5).timeout
			$TheLockedGateLabel2.modulate = Color(1.0, 1.0, 1.0, 0.0)
			$TheLockedGateLabel2.visible = true
			var tween2 = create_tween()
			tween2.tween_property($TheLockedGateLabel2, "modulate:a", 2.0, 2.0)
	if find_children("Target*", "Node").size() == 0:
		if goodorder:
			Globals.completion_times[3] = (Time.get_ticks_msec() - start_time) / 1000
			get_tree().change_scene_to_file("res://scenes/level4.tscn")
		else:
			if get_tree():
				get_tree().reload_current_scene()

func _on_back_to_game_button_pressed() -> void:
	$CanvasLayer/EscMenu.visible = false

func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
