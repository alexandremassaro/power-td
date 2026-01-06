extends CanvasLayer


func _ready() -> void:
	EntitySelectionManager.selection_changed.connect(_on_selection_changed)


func _on_selection_changed():
	var label : Label = get_node("%SelectedEntitiesLabel") as Label
	var qtd_selected = EntitySelectionManager.selected_entities.size()

	if qtd_selected > 1:
		label.text = str(qtd_selected) + " entities selected"
	elif qtd_selected == 1:
		label.text = EntitySelectionManager.selected_entities[0].name
	else:
		label.text = ""


func _on_button_pressed() -> void:
	get_parent().get_parent().game_mode = BaseMap.GameMode.BUILD

