extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var quantity = 0
var player = null
export var rotationRate = 150

# Called when the node enters the scene tree for the first time.
func _ready():
  add_to_group( 'firstaid' )

#-----------------------------------------------------------
func setQuantity( qty ):
  quantity = qty

#-----------------------------------------------------------
func _process( delta ) :
  var rot_speed = deg2rad( rotationRate )
  rotate_y( rot_speed*delta )

#-----------------------------------------------------------
func _on_Area_body_entered(body):
  if( body == player ):
    if( $'../HUD Layer'._increamentHealth( quantity ) ):
      self.queue_free()
      
#-----------------------------------------------------------
func set_player( p ) :
  player = p
