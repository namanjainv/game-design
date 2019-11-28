extends Spatial

export var rotationRate = 150
export var quantity     = 20

#-----------------------------------------------------------
func _process( delta ) :
  var rot_speed = deg2rad( rotationRate )
  rotate_y( rot_speed*delta )

#-----------------------------------------------------------
func setQuantity( qty ) :
  quantity = qty

#-----------------------------------------------------------

func _on_Area_body_entered(body):
  if( $'../HUD Layer'._increamentHealth( quantity ) == true ):
    self.queue_free()
  
