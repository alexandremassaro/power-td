class_name Floor
extends StaticBody3D

signal move_to(destination: Vector2)


func _input_event(camera: Camera3D, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_action_released("click_to_move"):
		click_to_move(event_position)
	
	if event is InputEventMouseMotion:
		var grid_manager : GridManager = get_parent().get_node("GridManager") as GridManager
		var adjusted_position : Vector2 = Vector2.ZERO
		adjusted_position.x = event_position.x
		adjusted_position.y = event_position.z

		var grid_pos = grid_manager.world_to_grid(adjusted_position)
		var world_pos = grid_manager.grid_to_world(grid_pos)

		get_node("HighlightMesh").position = Vector3(world_pos.x, 0.001, world_pos.y)

func click_to_move(event_position: Vector3):
	var destination : Vector2 = Vector2.ZERO

	destination.x = global_position.x + event_position.x
	destination.y = global_position.z + event_position.z

	move_to.emit(destination)
