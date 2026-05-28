extends Control

func _process(delta: float) -> void:
	$GoldLabel.text = "Gold: " + str(Globals.gold)
	
	if Globals.gold < 1:
		$BigPanel/Panel/HBoxContainer/VBoxContainer/BasicArrowButton.disabled = true
	if Globals.gold < 2:
		$BigPanel/Panel/HBoxContainer/VBoxContainer/RicochetArrowButton.disabled = true
	if Globals.gold < 3:
		$BigPanel/Panel/HBoxContainer/FireArrowButton.disabled = true

func _on_basic_arrow_button_pressed() -> void:
	Globals.arrows["basic"] += 1
	Globals.gold -= 1

func _on_ricochet_arrow_button_pressed() -> void:
	Globals.arrows["ricochet"] += 1
	Globals.gold -= 2

func _on_fire_arrow_button_3_pressed() -> void:
	Globals.arrows["fire"] += 1
	Globals.gold -= 3

func _on_exit_button_pressed() -> void:
	if Globals.next_scene == "":
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	get_tree().change_scene_to_file(Globals.next_scene)
