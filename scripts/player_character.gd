extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var grid_manager : GridManager
@onready var a_star : AStar2D = AStar2D.new()
var move_target = null
var path : Array[Vector3] = []


func _ready() -> void:
	grid_manager = get_parent().get_node("GridManager") as GridManager
	(get_parent().get_node("Floor") as Floor).move_to.connect(calculate_path)


func _physics_process(delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	# var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if move_target:
		var direction = global_position.direction_to(move_target)
		var distance = global_position.distance_to(move_target)

		if direction and distance >= 0.1:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			move_target = path.pop_front()

			if not move_target:
				velocity.x = move_toward(velocity.x, 0, SPEED)
				velocity.z = move_toward(velocity.z, 0, SPEED)

		move_and_slide()
	else:
		move_target = path.pop_front()


func move_to(destination : Vector2i):
	var snapped_world = grid_manager.grid_to_world(destination)
	path.push_back(Vector3(snapped_world.x, 0.0, snapped_world.y))


func calculate_path(to : Vector2i):
	path.clear()
	var from = grid_manager.world_to_grid(Vector2(global_position.x, global_position.z))
	var grid_path : PackedVector2Array = grid_manager.calculate_path(from, to)
	for grid_position in grid_path:
		move_to(Vector2i(grid_position))

