extends Node2D

var moving = false
var attacking = false
var health = 100
@export var disabled = false
@export var speed = 0.65

func _process(delta: float) -> void:
	if get_tree().current_scene.get_node("Player").global_position.x > global_position.x:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true

	if not disabled:
		if not attacking:
			if abs(global_position.x - get_tree().current_scene.get_node("Player").global_position.x) > 10:
				if global_position.distance_to(get_tree().current_scene.get_node("Player").global_position) < 1000 and not moving:
					$AnimatedSprite2D.play("move")
					moving = true
					var tween = create_tween()
					tween.tween_property(
						self,
						"global_position",
						Vector2(get_tree().current_scene.get_node("Player").global_position.x, global_position.y),
						speed
					)
					await get_tree().create_timer(speed).timeout
					moving = false
			else:
				attacking = true
				$AnimatedSprite2D.play("attack")
				var old_pos = global_position
				var tween = create_tween()
				tween.tween_property(
					self,
					"global_position",
					Vector2(global_position.x, get_tree().current_scene.get_node("Player").global_position.y),
					0.3
				)
				await get_tree().create_timer(0.3).timeout
				if get_tree().current_scene.get_node("Player") in $Area2D.get_overlapping_bodies():
					get_tree().current_scene.get_node("Player").take_damage(96)
				else:
					get_tree().current_scene.get_node("Player").take_damage(2)
				var tween2 = create_tween()
				tween2.tween_property(
					self,
					"global_position",
					old_pos,
					0.5
				)
				await get_tree().create_timer(0.5).timeout
				attacking = false
	
	if health <= 0:
		queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("arrow"):
		health -= 10
		
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate:a", 0.2, 0.6)
		await get_tree().create_timer(3.0).timeout
		tween = get_tree().create_tween()
		tween.tween_property(self, "modulate:a", 1.0, 0.8)
