extends Node2D

var welcome_player_dialogue_resource: DialogueResource = load("res://dialogues/welcomeplayer.dialogue")
var welcomeplayerbat_alreadydead = false
var all_targets_dead = false

func _ready() -> void:
	$CanvasLayer/EscMenu.visible = false
	
	await get_tree().process_frame
	var dial_balloon = DialogueManager.show_dialogue_balloon(welcome_player_dialogue_resource, "start")
	dial_balloon.process_mode = Node.PROCESS_MODE_ALWAYS
	DialogueManager.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _on_too_far_down_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().reload_current_scene()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		$CanvasLayer/EscMenu.visible = not $CanvasLayer/EscMenu.visible
	
	if not welcomeplayerbat_alreadydead:
		if $WelcomePlayerBat != null:
			if $WelcomePlayerBat.dead:
				welcomeplayerbat_alreadydead = true
				await get_tree().process_frame
				await get_tree().process_frame
				var dial_balloon = DialogueManager.show_dialogue_balloon(welcome_player_dialogue_resource, "trytoclimbthistower")
				dial_balloon.process_mode = Node.PROCESS_MODE_ALWAYS
				DialogueManager.process_mode = Node.PROCESS_MODE_ALWAYS
				get_tree().paused = true
				DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
				$Player.arrows = 0
		else:
			welcomeplayerbat_alreadydead = true
			await get_tree().process_frame
			await get_tree().process_frame
			var dial_balloon = DialogueManager.show_dialogue_balloon(welcome_player_dialogue_resource, "trytoclimbthistower")
			dial_balloon.process_mode = Node.PROCESS_MODE_ALWAYS
			DialogueManager.process_mode = Node.PROCESS_MODE_ALWAYS
			get_tree().paused = true
			DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
			$Player.arrows = 0

	if not all_targets_dead:
		if find_children("Target*", "Node").size() == 0:
			all_targets_dead = true
			$StaticBody2D/CollisionShape2D.disabled = true
			$StaticBody2D2/CollisionShape2D.disabled = false
			var dial_balloon = DialogueManager.show_dialogue_balloon(welcome_player_dialogue_resource, "dooropened")
			dial_balloon.process_mode = Node.PROCESS_MODE_ALWAYS
			DialogueManager.process_mode = Node.PROCESS_MODE_ALWAYS
			get_tree().paused = true
			DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _on_back_to_game_button_pressed() -> void:
	$CanvasLayer/EscMenu.visible = false

func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_dialogue_ended(resource):
	get_tree().paused = false

func _on_sceneout_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$CanvasLayer/ColorRect.modulate = Color(1, 1, 1, 0)
		$CanvasLayer/ColorRect.visible = true
		var tween = create_tween()
		tween.tween_property($CanvasLayer/ColorRect, "modulate", Color(0, 0, 0, 1), 1.0)
		await tween.finished
		get_tree().change_scene_to_file("res://scenes/level2.tscn")
