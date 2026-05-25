extends Node2D

@export var quantity: int = 1

func _ready() -> void:
	$QuantityLabel.text = str(quantity)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.arrows += quantity
		queue_free()
