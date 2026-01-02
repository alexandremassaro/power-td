extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var grid_manager : GridManager
var move_target = null


func move_to(destination : Vector2):
	var grid_pos = grid_manager.world_to_grid(destination)
	var snapped_world = grid_manager.grid_to_world(grid_pos)
	move_target = Vector3(snapped_world.x, 0.0, snapped_world.y)


func _ready() -> void:
	grid_manager = get_parent().get_node("GridManager") as GridManager
	(get_parent().get_node("Floor") as Floor).move_to.connect(move_to)


func _physics_process(delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	# var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if move_target:
		var direction = global_position.direction_to(move_target)
		var distance = global_position.distance_to(move_target)

		if direction and distance >= 1.0:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			move_target = null
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

		move_and_slide()


