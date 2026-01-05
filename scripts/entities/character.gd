extends CharacterBody3D

const SPEED = 5.0

@onready var grid_manager : GridManager
@onready var selectable: SelectableComponent = get_node("SelectableComponent")

var path : Array[Vector3] = []
var current_path_index : int = 0


func _ready() -> void:
	grid_manager = get_parent().get_node("GridManager") as GridManager
	(get_parent().get_node("Floor") as Floor).move_to.connect(calculate_path)

	if selectable:
		selectable.selected.connect(_on_selected)
		selectable.deselected.connect(_on_deselected)


func _physics_process(_delta: float) -> void:
	if path.is_empty() or current_path_index >= path.size():
		velocity = Vector3.ZERO
		return
	
	var target = path[current_path_index]
	var direction = global_position.direction_to(target)
	var distance = global_position.distance_to(target)
	
	if distance > 0.1:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		current_path_index += 1
		if current_path_index >= path.size():
			velocity = Vector3.ZERO
			path.clear()
			current_path_index = 0
	
	move_and_slide()


func _on_selected():
	print("Character selected: ", name)


func _on_deselected():
	print("Character deselected: ", name)


func calculate_path(to : Vector2i):
	if not selectable.is_selected:
		return
	path.clear()
	current_path_index = 0
	
	var from = grid_manager.world_to_grid(Vector2(global_position.x, global_position.z))
	var grid_path : PackedVector2Array = grid_manager.calculate_path(from, to)
	
	var smoothed = smooth_path_with_line_of_sight(grid_path)
	
	for grid_pos in smoothed:
		var world_pos = grid_manager.grid_to_world(Vector2i(grid_pos))
		path.push_back(Vector3(world_pos.x, 0.0, world_pos.y))


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
