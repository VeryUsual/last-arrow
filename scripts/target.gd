extends Node2D

@export var flipped: bool = false

func _ready() -> void:
	$Sprite2D.flip_h = flipped

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("arrow"):
		queue_free()
