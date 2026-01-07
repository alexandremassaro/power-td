extends Marker3D


@export var mobs_per_second: float = 10.0
var mob_type: Mob
var mob_quantity: int = 10
var total_mobs_spawned: int = 0


func get_mob_type() -> Mob:
	return get_parent().mob_type


func get_mob_quantity() -> int:
	return get_parent().mob_quantity


func _on_new_round():
	mob_quantity = get_mob_quantity()
	mob_type = get_mob_type()
	var timer: Timer = Timer.new()

	timer.timeout.connect(_on_timer_timeout)
	timer.start(1.0 / mobs_per_second)


func _on_timer_timeout():
	if total_mobs_spawned < mob_quantity:
		spawn_mob(mob_type)
		total_mobs_spawned += 1
