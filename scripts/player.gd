extends CharacterBody2D

var Arrow: PackedScene = preload("res://scenes/arrow.tscn")
const SPEED = 230.0
const JUMP_VELOCITY = -370.0
var mouse_position_at_shoot_start
var can_release_bow = false
var can_shoot = true
var arrows = 4
var coyote_frames = 6
var coyote = false
var last_floor = false

func _ready() -> void:
	$Bow/Line2D.visible = false
	$CoyoteTimer.wait_time = coyote_frames / 60.0

func _process(delta: float) -> void:
	$HUD/ArrowsLeftLabel.text = str(arrows) + " arrows left"

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jumping
	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote):
		velocity.y = JUMP_VELOCITY
		coyote = false
		$CoyoteTimer.stop()

	# Movement
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	if !is_on_floor() and last_floor:
		coyote = true
		$CoyoteTimer.start()
	last_floor = is_on_floor()
	
	if arrows > 0:
		# Shooting
		if Input.is_action_just_pressed("shoot") and can_shoot:
			$Bow/Line2D.visible = true
			$Bow.shooting = true
			mouse_position_at_shoot_start = get_global_mouse_position()
			if mouse_position_at_shoot_start.x < position.x:
				$Bow/Line2D.rotation = -20
			else:
				$Bow/Line2D.rotation = 20
			can_release_bow = false
			can_shoot = false
			await get_tree().create_timer(0.6).timeout
			can_release_bow = true
			await get_tree().create_timer(0.2).timeout
			can_shoot = true
		
		if Input.is_action_pressed("shoot"):
			if mouse_position_at_shoot_start.x < position.x:
				if $Bow/Line2D.rotation < -17:
					$Bow/Line2D.rotation += 0.02
			else:
				if $Bow/Line2D.rotation > 17:
					$Bow/Line2D.rotation -= 0.02
		
		if Input.is_action_just_released("shoot"):
			$Bow/Line2D.visible = false
			if can_release_bow:
				shoot()
			$Bow.shooting = false

func shoot():
	if arrows > 0:
		arrows -= 1
		var a = Arrow.instantiate()
		get_tree().current_scene.add_child(a)
		a.global_position = $Bow.global_position
		a.global_rotation = $Bow/Line2D.global_rotation

func _on_coyote_timer_timeout() -> void:
	coyote = false
