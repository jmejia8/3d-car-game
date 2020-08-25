extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func spawnVehicles(pos, path):
	var spawn_container = get_node(pos)
	
	if len(spawn_container.get_children()) > 20:
		print("No more cars for ", path)
		return
	
	var vehicle_type = ["Van", "Truck", "Suv"]
	var targets = get_node(path)
	for p in spawn_container.get_children():
		var i = randi() % len(vehicle_type)

		var carDriver = Spatial.new()
		var vehicle = load("res://Vehicles/" + vehicle_type[i] + "/" + vehicle_type[i] + ".tscn").instance()
		vehicle.transform.origin = p.transform.origin
		vehicle.add_child(load("res://Sensors/FrontalSensors.tscn").instance())
		vehicle.add_to_group("autonomous-car")
		carDriver.add_child(vehicle)
		carDriver.set_script(preload("res://Drivers/IA.gd"))
		spawn_container.add_child(carDriver)
		carDriver.set_targets(targets.get_children())
		break

# Called when the node enters the scene tree for the first time.
func _ready():
	spawnVehicles("SpawnPath1", "Path1")
	spawnVehicles("SpawnPath2", "Path2")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	spawnVehicles("SpawnPath1", "Path1")
	spawnVehicles("SpawnPath2", "Path2")
