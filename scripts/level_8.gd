extends Node2D

var level8_dialogue_resource: DialogueResource = load("res://dialogues/level8.dialogue")
var bat = preload("res://scenes/bat.tscn")
var start_time: int
var last_dialogue = ""

func _ready() -> void:
	$Player.arrows = 44
	$Player.ricochet_arrows = 44
	start_time = Time.get_ticks_msec()
	$CanvasLayer/EscMenu.visible = false
	
	await get_tree().create_timer(0.2).timeout
	
	last_dialogue = "start"
	var dial_balloon = DialogueManager.show_dialogue_balloon(level8_dialogue_resource, "start")
	dial_balloon.process_mode = Node.PROCESS_MODE_ALWAYS
	DialogueManager.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	
	await get_node("Bat").tree_exited
	
	var tween = create_tween()
	tween.tween_property($PointLight2D, "energy", 0.5, 2.0)
	await tween.finished
	tween = create_tween()
	tween.tween_property($PointLight2D, "energy", 2.0, 0.3)
	await tween.finished
	tween = create_tween()
	tween.tween_property($PointLight2D, "energy", 0.5, 0.4)
	await tween.finished
	tween = create_tween()
	tween.tween_property($PointLight2D, "energy", 2.0, 0.7)
	await tween.finished
	
	await get_tree().create_timer(1.0).timeout
	
	for i in 30:
		var b = bat.instantiate()
		b.position = Vector2(randi_range(800, 1056), randi_range(139, 235))
		add_child(b)
	
	await get_tree().create_timer(1.0).timeout
	
	$Golem.disabled = false
	$Golem.visible = true
	$Golem2.disabled = false
	$Golem2.visible = true
	$Golem3.disabled = false
	$Golem3.visible = true

func _on_dialogue_ended(resource):
	get_tree().paused = false

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
