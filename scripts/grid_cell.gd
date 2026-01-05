class_name GridCell
extends RefCounted


enum StructureType {
	TYPE_NULL,
	TYPE_TOWER,
	TYPE_TRAP,
	TYPE_BLOCK,
	TYPE_SUMMONER,
	TYPE_CHECKPOINT,
	TYPE_GOAL,
}


var can_walk: bool = true
var can_fly: bool = true
var can_build: bool = true
var structure: Structure = null


func can_place_structure() -> bool:
	return can_build and structure == null


func place_structure(new_structure: Structure) -> void:
	if can_place_structure():
		structure = new_structure
		can_walk = structure.can_walk_accros
		can_fly = structure.can_fly_over


func remove_structure() -> void:
	if structure:
		structure = null


func prohibit() -> void:
	if can_place_structure():
		can_build = false


func block_walk() -> void:
	if can_walk:
		can_walk = false


func block_fly() -> void:
	if can_fly:
		can_fly = false


func get_structure_type() -> StructureType:
	if structure and structure.type:
		return structure.type

	return StructureType.TYPE_NULL
