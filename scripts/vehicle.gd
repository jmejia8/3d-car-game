extends VehicleBody

const STEER_SPEED = 1
const STEER_SPEED_TO_0 = 1.2
const STEER_LIMIT = 0.5
const SCALE_CAR_SPEED = 0.3
const LEFT = 1
const RIGHT = -1


var steer_target = 0

export var engine_force_value = 200
export var reverse_engine_force_value = 100
export var max_speed = 110

var gear_shifts = [ 2.5, 1, 0.5, 0.2 ]
var gear = 1
# Car Actions

func get_speed():
	# 1 m/h = RPM/60
	# 1km/h = 1000m/h
	var wheel = get_node("Wheel1")

	return abs(wheel.get_rpm()) * wheel.wheel_radius * SCALE_CAR_SPEED

func accelerate():
	brake = 0.0
	
	var v = get_speed()
	
	if v < 10:
		gear = 1
	elif v < 20:
		gear = 2
	elif v < 40:
		gear = 3
	elif v < 60:
		gear = 4
	elif v > max_speed:
		gear = 4
		engine_force = 0
		return
		
	engine_force = engine_force_value * gear_shifts[gear-1]
	# print(gear," <--> ", gear_shifts[gear-1], "  v = ", v, "m/h")
	#elif v > 80
	

func apply_brake():
	brake = 40.0
	
func reverse():
	var fwd_mps = transform.basis.xform_inv(linear_velocity).z
	if (fwd_mps <= 1):
		brake = 0.0
		engine_force = -reverse_engine_force_value*gear_shifts[0] if get_speed() < 15 else 0
	else:
		apply_brake()

func turn_steering(direction, delta):
	if direction == 0:
		steering = move_toward(steering, direction, STEER_SPEED_TO_0 * delta )
		return
	
	# hard to turn direction in high speed
	var r = max(0.1, 1 - min(1, get_speed() / max_speed))
	steer_target = direction*STEER_LIMIT
	steering = move_toward(steering, steer_target, STEER_SPEED * delta * r)

func go_there(directions, delta):
	# directions = [forward, backward, steer_target, brake]
	if directions[0] == 1:
		accelerate()
	if directions[1] == 1:
		reverse()
	if directions[3] == 1:
		apply_brake()

	turn_steering(directions[2], delta)








