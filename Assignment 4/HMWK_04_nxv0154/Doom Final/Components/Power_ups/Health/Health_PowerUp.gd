extends Spatial

export var rotationRate = 150
export var quantity     = 1.5

var player = null

func _ready():
  add_to_group( 'health_powerups' )
#-----------------------------------------------------------
func _process( delta ) :
  var rot_speed = deg2rad( rotationRate )
  rotate_y( rot_speed*delta )

#-----------------------------------------------------------
func setQuantity( qty ) :
  quantity = qty

#-----------------------------------------------------------
func _on_Area_body_entered(body):
  if body == player:
    $'../HUD Layer'._resetHealth( quantity )
    print ("hp powerup")
    self.queue_free()
  
#-----------------------------------------------------------
func set_player( p ) :
  player = p

