extends Character


func _ready() -> void:
	(get_parent().get_node("Floor") as Floor).move_to.connect(_on_move_command)


func _on_move_command(target: Vector2i):
	if selectable.is_selected:
		pathfinding.move_to(target)



