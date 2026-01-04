class_name GridManager
extends Node3D

@export var grid_size : Vector2i = Vector2i(37, 37)
@export var cell_size : float = 1.0

var grid_offset : Vector2 = Vector2.ZERO
var pathfinding : AStar2D = AStar2D.new()
var grid_data : Dictionary = {}

var _pathfind_dirty : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grid_offset = grid_size / 2
	initialize_grid()


func initialize_grid():
	for i in range(grid_size.x):
		for j in range(grid_size.y):
			var cell_pos = Vector2i(i, j)
			# Setting grid data
			grid_data[cell_pos] = GridCell.new()
			# Adding point to pathfinding algorithm
			pathfinding.add_point(pathfinding.get_available_point_id(), Vector2(float(i), float(j)))

	var id = 0
	for i in range(grid_size.x):
		for j in range(grid_size.y):
			# Connecting neighbour points
			# if grid has more than 1 row
			if grid_size.y > 1:
				# if point is not in first row
				if not i == 0:
					pathfinding.connect_points(id, id - grid_size.x)
				# if point is not in last row
				if not i == grid_size.y - 1:
					pathfinding.connect_points(id, id + grid_size.x)
			# if grid has more than 1 column
			if grid_size.x > 1:
				# if point is not in first column
				if not j == 0:
					pathfinding.connect_points(id, id - 1)
				# if point is not in last column
				if not j == grid_size.x - 1:
					pathfinding.connect_points(id, id + 1)


			id += 1


func world_to_grid(world_position : Vector2) -> Vector2i:
	var adjusted = world_position + grid_offset
	var grid_position : Vector2i = Vector2i(
			roundi(adjusted.x / cell_size),
			roundi(adjusted.y / cell_size)
		)
	return grid_position


func world_3d_to_grid(world_position : Vector3) -> Vector2i:
	var adjusted = world_position
	adjusted.x += grid_offset.x
	adjusted.z += grid_offset.y
	var grid_position : Vector2i = Vector2i(
			roundi(adjusted.x / cell_size),
			roundi(adjusted.z / cell_size)
		)
	return grid_position


func grid_to_world(grid_position: Vector2i) -> Vector2:
	var world_position : Vector2 = Vector2(
			grid_position.x * cell_size,
			grid_position.y * cell_size
		)
	
	return world_position - grid_offset


func grid_to_world_3d(grid_position: Vector2i) -> Vector3:
	var world_position : Vector3 = Vector3(
			grid_position.x * cell_size - grid_offset.x,
			0.0,
			grid_position.y * cell_size - grid_offset.y
		)
	
	return world_position


func calculate_path(from : Vector2i, to : Vector2i) -> PackedVector2Array:
	var from_id = pathfinding.get_closest_point(Vector2(from))
	var to_id = pathfinding.get_closest_point(Vector2(to))
	return pathfinding.get_point_path(from_id, to_id)


func get_grid_cell(grid_position : Vector2i) -> Object:
	return grid_data[grid_position]


func can_place_structure(grid_position : Vector2i) -> bool:
	if not grid_data.has(grid_position):
		return false
	return grid_data[grid_position].can_place_structure()


func place_structure(structure : Structure, grid_position : Vector2i):
	if not can_place_structure(grid_position):
		return

	var world_position = grid_to_world_3d(grid_position)
	add_child(structure)
	structure.global_position = world_position

	grid_data[grid_position].place_structure(structure)

	if not structure.can_walk_accros:
		var point_id = grid_position.x * grid_size.y + grid_position.y
		pathfinding.set_point_disabled(point_id, true)


func remove_structure(grid_position: Vector2i):
	if not grid_data.has(grid_position):
		return

	var point_id = grid_position.x * grid_size.y + grid_position.y
	pathfinding.set_point_disabled(point_id, false)

	grid_data[grid_position].remove_structure()


func is_cell_walkable(grid_position: Vector2i) -> bool:
	if not grid_data.has(grid_position):
		return false

	return grid_data[grid_position].can_walk


func get_structure_at(grid_position: Vector2i) -> Structure:
	if grid_data.has(grid_position):
		return grid_data[grid_position].structure
	return null



