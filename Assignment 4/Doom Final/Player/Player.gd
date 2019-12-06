extends KinematicBody

const MOVE_SPEED =   4
const MOUSE_SENS =   0.5
const MAX_ANGLE  =  88
const MIN_ANGLE  = -45

# FOV for when we zoom using "telescopic sight".
const FOV_NORMAL = 70
const FOV_ZOOM   = 6

var zoomed = false

onready var anim_player = $AnimationPlayer
onready var raycast = $RayCast

#-----------------------------------------------------------
func _ready():
  Input.set_mouse_mode( Input.MOUSE_MODE_CAPTURED )

  yield( get_tree(), 'idle_frame' )

  get_tree().call_group( 'zombies', 'set_player', self )
  get_tree().call_group( 'obstacles', 'set_player', self )
  get_tree().call_group( 'ammos', 'set_player', self )
  get_tree().call_group( 'health_kits', 'set_player', self )

#-----------------------------------------------------------
func _input( event ) :
  if Input.is_action_just_pressed( 'zoom' ) :
    zoomed = not zoomed

  if zoomed :
    get_node( 'Camera' ).fov = FOV_ZOOM
    get_node( 'View/Crosshair' ).visible = false
    get_node( 'View/Scopesight' ).visible = true

  else :
    get_node( 'Camera' ).fov = FOV_NORMAL
    get_node( 'View/Crosshair' ).visible = true
    get_node( 'View/Scopesight' ).visible = false

  if event is InputEventMouseMotion :
    rotation_degrees.y -= MOUSE_SENS * event.relative.x

    rotation_degrees.x -= MOUSE_SENS * event.relative.y
    rotation_degrees.x = min( MAX_ANGLE, max( MIN_ANGLE, rotation_degrees.x ) )

#-----------------------------------------------------------
func _process( __ ) :    # Not using delta so don't name it.
  if Input.is_action_pressed( 'restart' ) :
    kill()

#-----------------------------------------------------------
func _physics_process( delta ) :
  var move_vec = Vector3()

  if Input.is_action_pressed( 'move_forwards' ) :
    move_vec.z -= 1

  if Input.is_action_pressed( 'move_backwards' ) :
    move_vec.z += 1

  if Input.is_action_pressed( 'move_left' ) :
    move_vec.x -= 1

  if Input.is_action_pressed( 'move_right' ) :
    move_vec.x += 1

  move_vec = move_vec.normalized()
  move_vec = move_vec.rotated( Vector3( 0, 1, 0 ), rotation.y )

  # warning-ignore:return_value_discarded
  move_and_collide( move_vec * MOVE_SPEED * delta )

  if Input.is_action_just_pressed( 'shoot' ) and !anim_player.is_playing() :
    if $'../HUD Layer'._ammoUsed() :
      anim_player.play( 'shoot' )
      $'../Player Audio'._playSound( 'shoot' )

      var coll = raycast.get_collider()
      if raycast.is_colliding() and coll.has_method( 'hurt' ) :
          coll.hurt()

    else :
      $'../Player Audio'._playSound( 'empty' )
	
  if Input.is_action_just_pressed( 'hit' ) and !anim_player.is_playing() :
    
    anim_player.play( 'hit' )
    $'../Player Audio'._playSound( 'shoot' )

    var coll = raycast.get_collider()
    if raycast.is_colliding() and coll.has_method( 'burstImpact' ) :
        get_tree().call_group( 'zombies', 'burstImpact', translation, 5, 2 )

#-----------------------------------------------------------
func kill() :
  var timeStr = $'../HUD Layer'.getTimeStr()

  print( 'Player died at %s.' % timeStr )

  $'../Message Layer/Message'.activate( 'Player Died\n%s' % timeStr )

func hurt( qty ) :
  $'../HUD Layer'._increamentHealth( -qty )

#-----------------------------------------------------------
func burstImpact( burst_translation, radius = 1, impact = 1 ):
  var dist = translation.distance_to( burst_translation ) 
  if dist < radius:
    hurt( impact )

#-----------------------------------------------------------