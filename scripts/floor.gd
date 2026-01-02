class_name Floor
extends StaticBody3D

signal move_to(destination: Vector2)


func _input_event(camera: Camera3D, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_action_released("click_to_move"):
		click_to_move(event_position)
	
	if event is InputEventMouseMotion:
		var grid_manager : GridManager = get_parent().get_node("GridManager") as GridManager
		var adjusted_position : Vector2 = Vector2.ZERO
		adjusted_position.x = global_position.x + event_position.x
		adjusted_position.y = global_position.z + event_position.z

		print("Mouse Move" + str(adjusted_position))
		adjusted_position = grid_manager.grid_to_world(grid_manager.world_to_grid(adjusted_position))
		print("Mouse Move" + str(adjusted_position))
		var move_pos = Vector3(adjusted_position.x, 0.0, adjusted_position.y)
		print("Mouse Move" + str(move_pos))
		$GridNode.position = move_pos


func click_to_move(event_position: Vector3):
	var destination : Vector2 = Vector2.ZERO

	destination.x = global_position.x + event_position.x
	destination.y = global_position.z + event_position.z

	move_to.emit(destination)
