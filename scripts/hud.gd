extends CanvasLayer


func _on_button_pressed() -> void:
	get_parent().game_mode = BaseMap.GameMode.BUILD

