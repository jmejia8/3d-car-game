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
	vehicle = get_node("vehicle")

	left_sensor = vehicle.get_node("FrontalSensors/Left")
	frontal_sensor = vehicle.get_node("FrontalSensors/Front")
	right_sensor = vehicle.get_node("FrontalSensors/Right")


	left_small_sensor = vehicle.get_node("FrontalSensors/FrontSmallLeft")
	frontal_small_sensor = vehicle.get_node("FrontalSensors/FrontSmall")
	right_small_sensor = vehicle.get_node("FrontalSensors/FrontSmallRight")
	
	
	
	#target = get_parent().get_node("Targets/Target1")
	targets = get_parent().get_node("Targets").get_children()
	target_idx = 0
	target = targets[target_idx]
	#target = get_parent().get_node("Me/vehicle")
	
	if not target:
		print("No target")
	else:
		for t in targets:
			print(t.name)

func look_for_target():
	if not target:
		return 0
	
	#print(target.transform.origin)
	var direction = (target.transform.origin -  vehicle.transform.origin).normalized()
	var d = direction.dot(vehicle.transform.basis.x)
	#print(d)
	return d

func naive_control():
	if stop:
		vehicle.apply_brake()
		return
		
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
		forward = 0

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

	return [forward, backward, steer_target, brake]


func _physics_process(delta):
	# [forward, backward, turn_left, turn_right, brake]
	#var input = [
	#	left_sensor.is_colliding(),
	#	frontal_sensor.is_colliding(),
	#	right_sensor.is_colliding(),
	#	# small
	#	left_small_sensor.is_colliding(),
	#	frontal_small_sensor.is_colliding(),
	#	right_small_sensor.is_colliding(),
	#]
	
	#print(input[0])
	


	
	var directions = naive_control()
	vehicle.go_there(directions, delta)
	



func _on_Area_area_entered(area):
	print("aaa = ", area.get_parent().name)
	if area.is_in_group("target") &&  area.get_parent().name == "Target" + str(target_idx+1):
		target_idx += 1
		target = targets[target_idx]
	print(target_idx)
	
	
