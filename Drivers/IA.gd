extends Spatial

var vehicle
var left_sensor
var frontal_sensor
var frontal_small_sensor
var left_small_sensor
var right_small_sensor
var right_sensor
var steer_target_last = 1
var target
var target_idx
var targets
var stop = false


func _ready():
	steer_target_last = 1 if rand_range(0,1) > 0.5 else -1
	vehicle = get_children()[0]

	left_sensor = vehicle.get_node("FrontalSensors/Left")
	frontal_sensor = vehicle.get_node("FrontalSensors/Front")
	right_sensor = vehicle.get_node("FrontalSensors/Right")


	left_small_sensor = vehicle.get_node("FrontalSensors/FrontSmallLeft")
	frontal_small_sensor = vehicle.get_node("FrontalSensors/FrontSmall")
	right_small_sensor = vehicle.get_node("FrontalSensors/FrontSmallRight")
	
	
	
	#target = get_parent().get_node("Targets/Target1")
	var targets_container = get_parent().get_node("Targets")
	if not targets_container:
		print("No targets")
		stop = true
		return

	targets = targets_container.get_children()
	
	for i in range(len(targets)-1, 0, -1):
		targets.append(targets[i])
	target_idx = 0
	target = targets[target_idx]
	#target = get_parent().get_node("Me/vehicle")
	


func look_for_target():
	if not target:
		return 0
	
	var direction = (target.transform.origin -  vehicle.transform.origin).normalized()
	var d = direction.dot(vehicle.transform.basis.x)
	#print(d)
	return d

func naive_control():

		
	var steer_target = 0
	var forward = 1
	var backward = 0
	var turn_left = 0
	var turn_right = 0
	var brake = 0
	

	if (frontal_small_sensor).is_colliding() or (left_sensor.is_colliding() and  right_sensor.is_colliding()):	
		backward = 1
		forward  = 0
		if frontal_sensor.is_colliding(): #and !get_node("Sensors/Back").is_colliding():
			turn_left =  1 if steer_target_last < 0 else 0
			turn_right = 1 if steer_target_last > 0 else 0
	elif (frontal_small_sensor).is_colliding() :# && left_sensor.is_colliding():
		backward = 1
	elif frontal_sensor.is_colliding() :
		forward = 1
		vehicle.slow_down(15)

	if backward > 0:
		forward = 0
	

	if left_sensor.is_colliding():
		turn_right = 1
	
	if right_sensor.is_colliding() :
		turn_left = 1

	steer_target = turn_left - turn_right

	if steer_target == 0 and forward > 0:
		var t = look_for_target()
		steer_target = t
	else :
		steer_target_last = steer_target if steer_target != 0 else steer_target_last

	if abs(steer_target) > 0.8:
		forward = 0
		vehicle.slow_down(10)

	return [forward, backward, steer_target, brake]

func set_targets(targts):
	targets = targts
	target_idx = 0
	target = targets[0]
	stop = false
	print(target.transform.origin)

func _physics_process(delta):
	if not target or stop:
		vehicle.apply_brake()
		return

	
	var directions = naive_control()
	vehicle.go_there(directions, delta)
	

func next_target(checkpoint):
	#print(checkpoint.name , " <>  ",  targets[target_idx].name)
	if checkpoint.name == targets[target_idx].name:
		target_idx += 1
		if target_idx >= len(targets):
			target_idx = 0

		target = targets[target_idx]

func _on_Area_area_entered(area):
	
	if area.is_in_group("target") &&  area.get_parent().name == targets[target_idx].name:
		print("Target = ", area.get_parent().name)
		target_idx += 1
		if target_idx >= len(targets):
			print("win--")
			stop = true
		else:
			target = targets[target_idx]
		

