extends Spatial

export var rotationRate = 150

var player = null
var key = false

func _ready():
  add_to_group( 'teleport' )
#-----------------------------------------------------------
func _process( delta ) :
  var rot_speed = deg2rad( rotationRate )
  rotate_y( rot_speed*delta )

#-----------------------------------------------------------

#-----------------------------------------------------------
func _on_Area_body_entered(body):
 if body == player:
    key  = get_node( '../Player').has_key()
    if key:
      print('inescp')
      var timeStr = $'../HUD Layer'.getTimeStr()
      if UserData.checkCompletionStatus( ):
        UserData.increamentCurrentLevel()
        $'../Message Layer/Message'.activate( 'Player Wins!\n%s' % timeStr )
      else:
        $'../Message Layer/Message/Background/Next'.disabled = false
        $'../Message Layer/Message/Background/Next'.visible = true
        $'../Message Layer/Message/Background/Restart'.disabled = true
        $'../Message Layer/Message/Background/Restart'.visible = false
        $'../Message Layer/Message'.activate( 'Level %d \nCompleted!\n%s' % [ UserData.CURRENT_LEVEL, timeStr ] );

#-----------------------------------------------------------
func set_player( p ) :
  player = p

