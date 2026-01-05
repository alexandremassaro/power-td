class_name Structure
extends StaticBody3D

@export var can_walk_accros : bool = false
@export var can_fly_over : bool = true


@onready var selectable: SelectableComponent = get_node("SelectableComponent")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if selectable:
		selectable.selected.connect(_on_selected)
		selectable.deselected.connect(_on_deselected)


func _on_selected():
	print("Structure selected: ", name)


func _on_deselected():
	print("Structure deselected: ", name)
