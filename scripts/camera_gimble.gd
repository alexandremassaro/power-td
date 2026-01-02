extends Node3D


@onready var camera : Camera3D = get_node("Camera3D")

@export var zoom_increments : float = 5.0
@export var camera_move_area : float = 0.1
@export var camera_speed : float = 20.0

var camera_move_direction : Vector3 = Vector3.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += camera_speed *  camera_move_direction * delta


func _input(event: InputEvent) -> void:

	if event is InputEventMouseButton and event.is_action_pressed("zoom_in"):
		if camera.position.y > 0.0:
			camera.position.y -= zoom_increments
	
	if  event is InputEventMouseButton and event.is_action_pressed(("zoom_out")):
		if camera.position.y < 100.0:
			camera.position.y += zoom_increments

	if event is InputEventMouseMotion:
		var mouse_position: Vector2 = event.position
		var window_size: Vector2 = get_window().size

		if mouse_position.x <= window_size.x * camera_move_area:
			camera_move_direction.x = -1.0
		elif mouse_position.x >= window_size.x - window_size.x * camera_move_area:
			camera_move_direction.x = 1.0

		if mouse_position.y <= window_size.y * camera_move_area:
			camera_move_direction.z = -1.0
		elif mouse_position.y >= window_size.y - window_size.y * camera_move_area:
			camera_move_direction.z = 1.0

		if mouse_position.x > window_size.x * camera_move_area and mouse_position.x < window_size.x - window_size.x * camera_move_area:
			camera_move_direction.x = 0.0

		if mouse_position.y > window_size.y * camera_move_area and mouse_position.y < window_size.y - window_size.y * camera_move_area:
			camera_move_direction.z = 0.0
