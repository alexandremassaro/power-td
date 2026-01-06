class_name Character
extends CharacterBody3D

const SPEED = 5.0

@onready var grid_manager : GridManager
@onready var selectable: SelectableComponent = get_node("SelectableComponent")
@onready var pathfinding: PathfindingComponent = get_node("PathfindingComponent")

var path : Array[Vector3] = []
var current_path_index : int = 0


func _ready() -> void:
	grid_manager = get_parent().get_node("GridManager") as GridManager

	if selectable:
		selectable.selected.connect(_on_selected)
		selectable.deselected.connect(_on_deselected)


func _physics_process(delta: float) -> void:
	if pathfinding.is_moving:
		velocity = pathfinding.process_movement(delta)
		velocity.y = 0
		move_and_slide()


func _on_selected():
	# print("Character selected: ", name)
	pass


func _on_deselected():
	# print("Character deselected: ", name)
	pass


