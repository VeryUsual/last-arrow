extends Node2D

var level2_dialogue_resource: DialogueResource = load("res://dialogues/level2.dialogue")
var bat = preload("res://scenes/bat.tscn")

func _ready() -> void:
	$CanvasLayer/EscMenu.visible = false
	
	await get_tree().create_timer(0.25).timeout
	var tween = create_tween()
	tween.tween_property($Player/Camera2D, "zoom", Vector2(0.7, 0.7), 1)
	
	$AnimationPlayer.play("the_magician_spawning_animation")

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

func _on_dialogue_ended(resource):
	get_tree().paused = false
	
	$Player.arrows = 15
	
	for i in 40:
		var b = bat.instantiate()
		b.position = Vector2(randi_range(111, 414), randi_range(41, 156))
		add_child(b)

func who_are_you_dialogue():
	var dial_balloon = DialogueManager.show_dialogue_balloon(level2_dialogue_resource, "whoareyou")
	dial_balloon.process_mode = Node.PROCESS_MODE_ALWAYS
	DialogueManager.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
