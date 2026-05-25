extends CharacterBody2D

class_name BatEnemy

const speed = 30
var is_chase: bool = true

var health = 80
var max_health = 80

var dead: bool = false
var taking_damage: bool = false
var damage_to_deal = 10
var is_dealing_damage: bool = false

var dir: Vector2
const gravity = 900
var knockback_force = -20
var is_roaming: bool = true

var player: CharacterBody2D
var player_in_area: bool = false

func _ready() -> void:
	player = get_tree().current_scene.get_node("Player")

func _process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta
		velocity.x = 0
	
	is_chase = false
	for body in $SightArea.get_overlapping_bodies():
		if body.is_in_group("player"):
			is_chase = true
	
	move(delta)
	handle_animation()
	move_and_slide()

func move(delta):
	if !dead:
		if !is_chase:
			velocity += dir * speed * delta
		elif is_chase and !taking_damage:
			var dir_to_player = position.direction_to(player.position) * speed
			velocity.x = dir_to_player.x
			dir.x = abs(velocity.x) / velocity.x
		elif taking_damage:
			var knockback_dir = position.direction_to(player.position) * knockback_force
			velocity.x = knockback_dir.x
		is_roaming = true
	elif dead:
		velocity.x = 0

func handle_animation():
	var anim_sprite = $AnimatedSprite2D
	if !dead and !taking_damage and !is_dealing_damage:
		anim_sprite.play("fly")
		if dir.x == -1:
			anim_sprite.flip_h = true
		elif dir.x == 1:
			anim_sprite.flip_h = false
	elif !dead and taking_damage and !is_dealing_damage:
		anim_sprite.play("hurt")
		await get_tree().create_timer(1.0).timeout
		taking_damage = false
	elif dead and is_roaming:
		is_roaming = false
		anim_sprite.play("death")
		$GPUParticles2D.emitting = true
		await get_tree().create_timer(1.2).timeout
		handle_death()
	elif !dead and is_dealing_damage:
		anim_sprite.play("attack")

func handle_death():
	$GPUParticles2D.emitting = false
	queue_free()

func _on_direction_timer_timeout() -> void:
	$DirectionTimer.wait_time = choose([1.5, 2.0, 2.5])
	if !is_chase:
		dir = choose([Vector2.RIGHT, Vector2.LEFT])
		velocity.x = 0

func choose(array):
	array.shuffle()
	return array.front()

func _on_hitbox_area_entered(area: Area2D) -> void:
	var damage = 60
	if area.is_in_group("arrow"):
		take_damage(damage)

func take_damage(damage):
	health -= damage
	taking_damage = true
	if health <= 0:
		health = 0
		dead = true
	print(str(self), health)

func _on_damage_timer_timeout() -> void:
	var overlapping_bodies = $DealDamageArea.get_overlapping_bodies()
	
	for body in overlapping_bodies:
		if body.is_in_group("player"):
			is_dealing_damage = true
			body.take_damage(10)
			await get_tree().create_timer(0.4).timeout
			is_dealing_damage = false
