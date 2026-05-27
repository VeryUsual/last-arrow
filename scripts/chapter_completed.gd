extends Control

func _ready() -> void:
	var total_time = 0
	for v in Globals.completion_times.values():
		if v is int or v is float:
			total_time += v
	Globals.xp_earned += round( total_time / 22 )
	$Panel/Label.text = "Chapter cleared in " + str(total_time) + " seconds\n" + str(Globals.xp_earned) + " XP Earned"
	$AnimationPlayer.play("anim")

func _on_next_chapter_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
