extends VehicleWheel


# Declare member variables here. Examples:
export var flip_mesh = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if flip_mesh:
		get_node("Mesh").rotate_y(PI)
		
