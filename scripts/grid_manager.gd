class_name GridManager
extends Node3D

@export var grid_size : Vector2i = Vector2i(37, 37)
@export var cell_size : float = 1.0

var grid_offset : Vector2 = Vector2.ZERO
var pathfinding : AStar2D = AStar2D.new()
var grid_data : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialize_grid()


func initialize_grid():
	var id = 0
	for i in range(grid_size.x):
		for j in range(grid_size.y):
			var cell_pos = Vector2i(i, j)
			# Setting grid data
			grid_data[cell_pos] = {
				"occupied" = false,
				"wallkable" = true,
				"has_building" = false,
				}
			# Adding point to pathfinding algorithm
			pathfinding.add_point(id, Vector2(float(i), float(j)))

			id += 1
	
	print(id)
	id = 0
	for i in range(grid_size.x):
		for j in range(grid_size.y):
			# Connecting neighbour points
			# if grid has more than 1 row
			if grid_size.y > 1:
				# if point is not in first row
				if id >= grid_size.x:
					pathfinding.connect_points(id, id - grid_size.x)
				# if point is not in last row
				if id < grid_size.x * grid_size.y - grid_size.x:
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
	var adjusted = world_position - grid_offset
	var grid_position : Vector2i = Vector2i(
			roundi(adjusted.x / cell_size),
			roundi(adjusted.y / cell_size)
		)

	return grid_position


func grid_to_world(grid_position: Vector2i) -> Vector2:
	var world_position : Vector2 = Vector2(
			grid_position.x * cell_size,
			grid_position.y * cell_size
		)

	return world_position


