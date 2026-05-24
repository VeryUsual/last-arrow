extends CharacterBody2D


var Arrow: PackedScene = preload("res://scenes/arrow.tscn")
const SPEED = 230.0
const JUMP_VELOCITY = -370.0
var mouse_position_at_shoot_start

func _ready() -> void:
	$Bow/Line2D.visible = false

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movement
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	# Shooting
	if Input.is_action_just_pressed("shoot"):
		$Bow/Line2D.visible = true
		$Bow.shooting = true
		mouse_position_at_shoot_start = get_global_mouse_position()
		if mouse_position_at_shoot_start.x < position.x:
			$Bow/Line2D.rotation = -20
		else:
			$Bow/Line2D.rotation = 20
	
	if Input.is_action_pressed("shoot"):
		if mouse_position_at_shoot_start.x < position.x:
			if $Bow/Line2D.rotation < -17:
				$Bow/Line2D.rotation += 0.02
		else:
			if $Bow/Line2D.rotation > 17:
				$Bow/Line2D.rotation -= 0.02
	
	if Input.is_action_just_released("shoot"):
		$Bow/Line2D.visible = false
		shoot()
		$Bow.shooting = false

func shoot():
	var a = Arrow.instantiate()
	get_tree().current_scene.add_child(a)
	a.global_position = $Bow.global_position
	a.global_rotation = $Bow/Line2D.global_rotation
