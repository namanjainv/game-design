extends Spatial

export var rotationRate = 150
export var quantity     = 20

var player = null

func _ready():
  add_to_group( 'key' )
#-----------------------------------------------------------
func _process( delta ) :
  var rot_speed = deg2rad( rotationRate )
  rotate_y( rot_speed*delta )

#-----------------------------------------------------------

#-----------------------------------------------------------
func _on_Area_body_entered(body):
  if body == player:
    get_node( '../HUD Layer/Key' ).visible = true
    get_node( '../Player/View/Key' ).visible = true
    get_node( '../Player').set_key_status(true)
    self.queue_free()
  
#-----------------------------------------------------------
func set_player( p ) :
  player = p

