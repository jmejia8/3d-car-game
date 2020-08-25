extends Spatial

var vehicle

func _ready():
	vehicle = get_node("vehicle")


func _physics_process(delta):

	if Input.is_action_pressed("ui_down"):
		vehicle.play_horn()
	else:
		vehicle.horn.playing = false
		

	if Input.is_action_pressed("ui_up"):
		vehicle.accelerate()
	else:
		vehicle.engine_force = 0
	
	if Input.is_action_pressed("ui_down"):
		vehicle.reverse()

		
	if Input.is_action_pressed("brake"):
		vehicle.apply_brake()
	
	var dir = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
	vehicle.turn_steering(dir, delta)
