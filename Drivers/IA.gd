extends Spatial

var vehicle
var left_sensor
var frontal_sensor
var frontal_small_sensor
var right_sensor
var steer_target_last = 1
var target
var stop = false


func _ready():
	vehicle = get_node("vehicle")
	left_sensor = vehicle.get_node("FrontalSensors/Left")
	frontal_sensor = vehicle.get_node("FrontalSensors/Front")
	frontal_small_sensor = vehicle.get_node("FrontalSensors/Front")
	right_sensor = vehicle.get_node("FrontalSensors/Right")
	
	
	target = get_parent().get_node("Target")
	if not target:
		print("No target")

func look_for_target():
	if not target:
		return 0
	
	#print(target.transform.origin)
	var direction = (target.transform.origin -  vehicle.transform.origin).normalized()
	var d = direction.dot(vehicle.transform.basis.x)
	#print(d)
	return d

func _physics_process(delta):
	if stop:
		vehicle.apply_brake()
		return
	var steer_target = 0
	var flag = true
	

	if (frontal_small_sensor).is_colliding() or (left_sensor.is_colliding() and  right_sensor.is_colliding()):	
		vehicle.reverse()
		if frontal_sensor.is_colliding(): #and !get_node("Sensors/Back").is_colliding():
			vehicle.turn_steering(-steer_target_last, delta)
		return
	elif (frontal_small_sensor).is_colliding() && left_sensor.is_colliding():
		vehicle.reverse()
		vehicle.turn_steering(1, delta)
		return
	elif (frontal_small_sensor).is_colliding() && right_sensor.is_colliding():
		vehicle.reverse()
		vehicle.turn_steering(-1, delta)
		return
	elif frontal_sensor.is_colliding() :
		#brake_()
		vehicle.brake = 0.0
		vehicle.engine_force = 0
		flag = false
		vehicle.turn_steering(-steer_target_last, delta)
		
		

	

	if left_sensor.is_colliding():
		steer_target = vehicle.RIGHT
		
	
	if right_sensor.is_colliding() :
		steer_target = vehicle.LEFT
	
	if steer_target == 0:
		steer_target = look_for_target()
	else :
		steer_target_last = steer_target

	if flag :
		vehicle.accelerate()
		
	
	vehicle.turn_steering(steer_target, delta)
		

	


func _on_Area_body_entered(body):
	print("Hola papu") # Replace with function body.
	stop = body.is_in_group("IA_driver")
