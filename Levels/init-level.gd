extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func spawnVehicles(pos, path):
	var spawn_container = get_node(pos)
	var targets = get_node(path)
	for p in spawn_container.get_children():
		var carDriver = Spatial.new()
		var vehicle = load("res://Vehicles/Truck/Truck.tscn").instance()
		vehicle.transform.origin = p.transform.origin
		vehicle.add_child(load("res://Sensors/FrontalSensors.tscn").instance())
		vehicle.add_to_group("autonomous-car")
		carDriver.add_child(vehicle)
		carDriver.set_script(preload("res://Drivers/IA.gd"))
		spawn_container.add_child(carDriver)
		carDriver.set_targets(targets.get_children())

# Called when the node enters the scene tree for the first time.
func _ready():
	spawnVehicles("SpawnPath1", "Path1")
	spawnVehicles("SpawnPath2", "Path2")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
