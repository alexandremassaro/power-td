class_name GridManager
extends Node3D

@export var grid_size: Vector2i = Vector2i(37, 37)
@export var cell_size: float = 1.0

var grid_offset: Vector2 = Vector2.ZERO

var grid_data : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialize_grid()


func initialize_grid():
	for i in range(grid_size.x):
		for j in range(grid_size.y):
			var cell_pos = Vector2i(i, j)
			grid_data[cell_pos] = {
				"occupied" = false,
				"wallkable" = true,
				"has_building" = false,
				}


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
