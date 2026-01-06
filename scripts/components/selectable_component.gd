class_name SelectableComponent
extends Node

signal selected()
signal deselected()

var is_selected: bool = false
@onready var parent_entity: CollisionObject3D = get_parent()


func _ready() -> void:
	if parent_entity:
		parent_entity.input_ray_pickable = true

		if parent_entity.has_signal("input_event"):
			parent_entity.input_event.connect(_on_input_event)

	selected.connect(EntitySelectionManager.on_entity_selected.bind(parent_entity))
	deselected.connect(EntitySelectionManager.on_entity_deselected.bind(parent_entity))


func _on_input_event(_camera: Camera3D, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_action_released("select_entity"):
		toggle_selection()


func select():
	if not is_selected:
		is_selected = true
		_apply_highlight(true)
		selected.emit()


func deselect():
	if is_selected:
		is_selected = false
		_apply_highlight(false)
		deselected.emit()


func toggle_selection():
	if is_selected:
		deselect()
	else:
		select()


func _apply_highlight(enabled: bool):
	var mesh = parent_entity.find_child("MeshInstance3D", true, false)
	if mesh:
		if enabled:
			mesh.scale = Vector3(1.1, 1.1, 1.1)
		else:
			mesh.scale = Vector3(1.0, 1.0, 1.0)
