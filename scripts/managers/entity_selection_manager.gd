extends Node

signal selection_changed
var selected_entities: Array[CollisionObject3D] = []


func _init() -> void:
	pass


func on_entity_selected(entity: CollisionObject3D):
	if not selected_entities.has(entity):
		selected_entities.push_back(entity)
		selection_changed.emit()


func on_entity_deselected(entity: CollisionObject3D):
	if selected_entities.has(entity):
		selected_entities.remove_at(selected_entities.find(entity))
		selection_changed.emit()


func deselect_all():
	# Iterate the array backward to prevent failure
	for i in range(selected_entities.size() - 1, -1, -1):
		selected_entities[i].selectable.deselect()
	print_selected()



func print_selected():
	print("------------------")
	for entity in selected_entities:
		print(entity.name)
	print("------------------")



