extends Area2D

var speed = 600
var starting = true

func _ready() -> void:
	await get_tree().create_timer(0.7).timeout
	starting = false
	
	await get_tree().create_timer(43.0).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.queue_free()
		queue_free()
	if not body.is_in_group("player") and starting == false:
		queue_free()
