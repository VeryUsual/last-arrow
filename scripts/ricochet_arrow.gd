extends Area2D

var speed = 600
var bounces = 0

func _ready() -> void:
	await get_tree().create_timer(43.0).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.queue_free()
		queue_free()
	if not body.is_in_group("player"):
		if bounces >= 7:
			queue_free()
		
		speed = -1 * speed
		if rotation < 0:
			rotation -= 45
		elif rotation > 0:
			rotation += 45
		bounces += 1
