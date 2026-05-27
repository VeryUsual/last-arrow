extends Node2D

var level5_dialogue_resource: DialogueResource = load("res://dialogues/level5.dialogue")
var bat = preload("res://scenes/bat.tscn")
var start_time: int
var last_dialogue = ""

func _ready() -> void:
	start_time = Time.get_ticks_msec()
	$Player.arrows = 0
	$Player.ricochet_arrows = 7
	$CanvasLayer/EscMenu.visible = false
	
	await get_tree().create_timer(0.5).timeout
	
	last_dialogue = "start"
	var dial_balloon = DialogueManager.show_dialogue_balloon(level5_dialogue_resource, "start")
	dial_balloon.process_mode = Node.PROCESS_MODE_ALWAYS
	DialogueManager.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	
	await get_node("Target").tree_exited
	
	last_dialogue = "targetelimated"
	var dial_balloon2 = DialogueManager.show_dialogue_balloon(level5_dialogue_resource, "targetelimated")
	dial_balloon2.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true

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

func bye():
	Globals.completion_times[5] = (Time.get_ticks_msec() - start_time) / 1000

func _on_dialogue_ended(resource):
	get_tree().paused = false
	
	var bats = []
	
	if last_dialogue == "targetelimated":
		last_dialogue = ""
		
		for i in 3:
			var b = bat.instantiate()
			b.position = Vector2(randi_range(208, 272), randi_range(142, 246))
			add_child(b)
			bats.append(b)
			
		await get_tree().create_timer(3.0).timeout
		
		for bat in bats:
			bat.queue_free()
		
		await get_tree().create_timer(0.8).timeout
		
		last_dialogue = "onemore"
		var dial_balloon = DialogueManager.show_dialogue_balloon(level5_dialogue_resource, "onemore")
		dial_balloon.process_mode = Node.PROCESS_MODE_ALWAYS
		get_tree().paused = true
	elif last_dialogue == "onemore":
		get_tree().change_scene_to_file("res://scenes/shop.tscn")
