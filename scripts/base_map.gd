class_name BaseMap
extends Node3D


signal game_mode_changed(game_mode)


enum GameMode {NORMAL, SELECTED, BUILD, DESTROY}


@export var grid_size : Vector2i = Vector2i(37, 37)
@export var cell_size : float = 2.0

@onready var grid_manager : GridManager = get_node("GridManager")
@onready var grid_floor : Floor = get_node("Floor")

var game_mode : GameMode = GameMode.NORMAL
var selected_structure : Structure = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CONFINED)

	grid_manager.grid_size = grid_size
	grid_manager.cell_size = cell_size
	grid_manager.initialize_grid()

	grid_floor.get_node("CollisionShape3D").shape.size.x = float(grid_size.x) * cell_size
	grid_floor.get_node("CollisionShape3D").shape.size.z = float(grid_size.y) * cell_size

	grid_floor.get_node("FloorMesh").mesh.size.x = float(grid_size.x) * cell_size
	grid_floor.get_node("FloorMesh").mesh.size.y = float(grid_size.y) * cell_size

	grid_floor.get_node("HighlightMesh").mesh.size.x = float(cell_size)
	grid_floor.get_node("HighlightMesh").mesh.size.y = float(cell_size)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	match game_mode:
		GameMode.NORMAL:
			pass
		GameMode.SELECTED:
			pass
		GameMode.BUILD:
			pass
		_:
			pass


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_released("build_mode") and game_mode == GameMode.NORMAL:
		game_mode = GameMode.BUILD
		game_mode_changed.emit(game_mode)
	elif event.is_action_released("destroy_mode") and game_mode == GameMode.NORMAL:
		game_mode = GameMode.DESTROY
		game_mode_changed.emit(game_mode)
	elif event.is_action_released("ui_cancel") and not game_mode == GameMode.NORMAL:
		game_mode = GameMode.NORMAL
		game_mode_changed.emit(game_mode)



