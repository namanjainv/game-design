extends Spatial

export var rotationRate = 150

var player = null

func _ready():
  add_to_group( 'damage_powerups' )
#-----------------------------------------------------------
func _process( delta ) :
  var rot_speed = deg2rad( rotationRate )
  rotate_y( rot_speed*delta )

#-----------------------------------------------------------
func _on_Area_body_entered(body):
  if body == player:
    body.setDmgPowerUp()
    print ("dmg powerup")
    self.queue_free()
  
#-----------------------------------------------------------
func set_player( p ) :
  player = p

