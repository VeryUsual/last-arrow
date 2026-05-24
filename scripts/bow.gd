extends Node2D

var shooting = false

func _process(delta: float) -> void:
	if not shooting:
		look_at(get_global_mouse_position())
