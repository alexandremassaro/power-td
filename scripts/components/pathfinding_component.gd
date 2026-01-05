class_name PathfindingComponent
extends Node


signal path_completed
signal path_blocked


@export var speed: float = 5.0
@export var stopping_distance: float = 0.1

var grid_manager: GridManager
var path: Array[Vector3] = []
var current_path_index: int = 0
var is_moving: bool = false

@onready var character: CharacterBody3D = get_parent()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grid_manager = find_parent("BaseMap").find_child("GridManager")
	if not grid_manager:
		push_error("GridManager not found")


func move_to(targe_position: Vector2i):
	if not grid_manager:
		return

	path.clear()
	current_path_index = 0

	var from = grid_manager.world_3d_to_grid(character.global_position)
	var grid_path = grid_manager.calculate_path(from, targe_position)

	if grid_path.is_empty():
		path_blocked.emit()
		return

	var smoothed = _smooth_path(grid_path)

	for grid_pos in smoothed:
		var world_pos = grid_manager.grid_to_world_3d(Vector2i(grid_pos))
		path.push_back(world_pos)

	is_moving = true


func process_movement(_delta: float) -> Vector3:
	if path.is_empty() or current_path_index >= path.size():
		is_moving = false
		if current_path_index >= path.size() and path.size() > 0:
			path_completed.emit()
		return Vector3.ZERO

	var target = path[current_path_index]
	var direction = character.global_position.direction_to(target)
	var distance = character.global_position.distance_to(target)

	if distance > stopping_distance:
		return direction * speed
	else:
		current_path_index += 1
		if current_path_index >= path.size():
			is_moving = false
			path.clear()
			current_path_index = 0
			path_completed.emit()
		return Vector3.ZERO


func _smooth_path(grid_path: PackedVector2Array) -> Array[Vector2i]:
	if grid_path.size() <= 2:
		return convert_to_vector2i_array(grid_path)
	
	var smoothed: Array[Vector2i] = []
	smoothed.push_back(Vector2i(grid_path[0]))
	
	var current_index = 0
	
	while current_index < grid_path.size() - 1:
		var farthest_visible = current_index + 1

		for i in range(current_index + 2, grid_path.size()):
			if has_line_of_sight(Vector2i(grid_path[current_index]), Vector2i(grid_path[i])):
				farthest_visible = i
			else:
				break

		smoothed.push_back(Vector2i(grid_path[farthest_visible]))
		current_index = farthest_visible
	
	return smoothed


func has_line_of_sight(from: Vector2i, to: Vector2i) -> bool:
	var cells = get_line_cells(from, to)
	
	for cell in cells:
		if not grid_manager.is_cell_walkable(cell):
			return false
	
	return true


func get_line_cells(from: Vector2i, to: Vector2i) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	
	var x0 = from.x
	var y0 = from.y
	var x1 = to.x
	var y1 = to.y
	
	var dx = abs(x1 - x0)
	var dy = abs(y1 - y0)
	var sx = 1 if x0 < x1 else -1
	var sy = 1 if y0 < y1 else -1
	var err = dx - dy
	
	while true:
		cells.push_back(Vector2i(x0, y0))

		if x0 == x1 and y0 == y1:
			break

		var e2 = 2 * err
		if e2 > -dy:
			err -= dy
			x0 += sx
		if e2 < dx:
			err += dx
			y0 += sy
	
	return cells


func convert_to_vector2i_array(packed: PackedVector2Array) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for v in packed:
		result.push_back(Vector2i(v))
	return result
