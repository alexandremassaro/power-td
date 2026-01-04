class_name Structure
extends StaticBody3D

@export var can_walk_accros : bool = false
@export var can_fly_over : bool = true
@export var mesh : Mesh
@export var hitbox : Shape3D

@onready var structure_hitbox : CollisionShape3D
@onready var structure_mesh : MeshInstance3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	structure_hitbox = CollisionShape3D.new()
	structure_mesh = MeshInstance3D.new()

	if hitbox:
		structure_hitbox.shape = hitbox
	if mesh:
		structure_mesh.mesh = mesh
	
	add_child(structure_hitbox)
	add_child(structure_mesh)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
