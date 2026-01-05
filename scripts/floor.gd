class_name Floor
extends StaticBody3D

signal move_to(destination: Vector2i)


@onready var grid_manager: GridManager
@onready var game_mode: BaseMap.GameMode = get_parent().game_mode


func _ready() -> void:
	grid_manager = get_parent().get_node("GridManager") as GridManager


func _input_event(_camera: Camera3D, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.is_action_released("click_to_move"):
			click_to_move(event_position)

		if event.is_action_released("place_structure"):
			place_structure(event_position)


	if event is InputEventMouseMotion:
		var grid_manager : GridManager = get_parent().get_node("GridManager") as GridManager
		var adjusted_position : Vector2 = Vector2.ZERO
		adjusted_position.x = event_position.x
		adjusted_position.y = event_position.z

		var grid_pos = grid_manager.world_to_grid(adjusted_position)
		var world_pos = grid_manager.grid_to_world(grid_pos)

		get_node("HighlightMesh").position = Vector3(world_pos.x, 0.03, world_pos.y)


func click_to_move(event_position: Vector3):
	var destination : Vector2i = Vector2i.ZERO

	destination = grid_manager.world_to_grid(Vector2(event_position.x, event_position.z))

	move_to.emit(destination)


func place_structure(event_position: Vector3):
	var structure_position : Vector2i = grid_manager.world_3d_to_grid(event_position)
	var structure : Structure = Scenes.STRUCTURE_SCENE.instantiate() as Structure

	grid_manager.place_structure(structure, structure_position)


