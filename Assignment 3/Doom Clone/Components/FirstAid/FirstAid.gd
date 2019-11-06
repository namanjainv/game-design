extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var quantity = 0
export var rotationRate = 150

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.

#-----------------------------------------------------------
func setQuantity( qty ):
  quantity = qty

#-----------------------------------------------------------
func _process( delta ) :
  var rot_speed = deg2rad( rotationRate )
  rotate_y( rot_speed*delta )