extends CharacterBody3D

const SPEED = 5.0

@onready var grid_manager : GridManager
@onready var selectable: SelectableComponent = get_node("SelectableComponent")
@onready var pathfinding: PathfindingComponent = get_node("PathfindingComponent")

var path : Array[Vector3] = []
var current_path_index : int = 0


func _ready() -> void:
	grid_manager = get_parent().get_node("GridManager") as GridManager
	(get_parent().get_node("Floor") as Floor).move_to.connect(_on_move_command)

	if selectable:
		selectable.selected.connect(_on_selected)
		selectable.deselected.connect(_on_deselected)


func _physics_process(delta: float) -> void:
	if pathfinding.is_moving:
		velocity = pathfinding.process_movement(delta)
		velocity.y = 0
		move_and_slide()


func _on_move_command(target: Vector2i):
	pathfinding.move_to(target)


func _on_selected():
	print("Character selected: ", name)


func _on_deselected():
	print("Character deselected: ", name)


func smooth_path_with_line_of_sight(grid_path: PackedVector2Array) -> Array[Vector2i]:
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
