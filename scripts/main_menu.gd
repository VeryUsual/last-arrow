extends Control

var play_btn_tween: Tween
var quit_btn_tween: Tween
var options_btn_tween: Tween

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_play_button_mouse_entered() -> void:
	if play_btn_tween and play_btn_tween.is_running():
		play_btn_tween.kill()
	play_btn_tween = create_tween()
	play_btn_tween.tween_property($VBoxContainer/PlayButton, "scale", Vector2(1.05, 1.05), 0.1).set_trans(Tween.TRANS_ELASTIC)
	$VBoxContainer/PlayButton.add_theme_constant_override("outline_size", 9)

func _on_play_button_mouse_exited() -> void:
	if play_btn_tween and play_btn_tween.is_running():
		play_btn_tween.kill()
	play_btn_tween = create_tween()
	play_btn_tween.tween_property($VBoxContainer/PlayButton, "scale", Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_ELASTIC)
	$VBoxContainer/PlayButton.add_theme_constant_override("outline_size", 0)

func _on_quit_button_mouse_entered() -> void:
	if quit_btn_tween and quit_btn_tween.is_running():
		quit_btn_tween.kill()
	quit_btn_tween = create_tween()
	quit_btn_tween.tween_property($VBoxContainer/QuitButton, "scale", Vector2(1.05, 1.05), 0.2).set_trans(Tween.TRANS_ELASTIC)
	$VBoxContainer/QuitButton.add_theme_constant_override("outline_size", 9)

func _on_quit_button_mouse_exited() -> void:
	if quit_btn_tween and quit_btn_tween.is_running():
		quit_btn_tween.kill()
	quit_btn_tween = create_tween()
	quit_btn_tween.tween_property($VBoxContainer/QuitButton, "scale", Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_ELASTIC)
	$VBoxContainer/QuitButton.add_theme_constant_override("outline_size", 0)

func _on_options_button_mouse_entered() -> void:
	if options_btn_tween and options_btn_tween.is_running():
		options_btn_tween.kill()
	options_btn_tween = create_tween()
	options_btn_tween.tween_property($VBoxContainer/OptionsButton, "scale", Vector2(1.05, 1.05), 0.1).set_trans(Tween.TRANS_ELASTIC)
	$VBoxContainer/OptionsButton.add_theme_constant_override("outline_size", 9)

func _on_options_button_mouse_exited() -> void:
	if options_btn_tween and options_btn_tween.is_running():
		options_btn_tween.kill()
	options_btn_tween = create_tween()
	options_btn_tween.tween_property($VBoxContainer/OptionsButton, "scale", Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_ELASTIC)
	$VBoxContainer/OptionsButton.add_theme_constant_override("outline_size", 0)
