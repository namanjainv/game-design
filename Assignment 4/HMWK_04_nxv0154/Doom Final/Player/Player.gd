extends KinematicBody

const MOVE_SPEED =   4
const MOUSE_SENS =   0.5
const MAX_ANGLE  =  88
const MIN_ANGLE  = -45

# FOV for when we zoom using "telescopic sight".
const FOV_NORMAL = 70
const FOV_ZOOM   = 6
var spawn_portal = false
var zoomed = false
var dmg_powerup = false
var power_timer = 10
var key_status = false

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
  get_tree().call_group( 'spawns', 'set_player', self )
  get_tree().call_group( 'npcs', 'set_player', self )
  get_tree().call_group( 'damage_powerups', 'set_player', self )
  get_tree().call_group( 'health_powerups', 'set_player', self )
  get_tree().call_group( 'key', 'set_player', self )
  get_tree().call_group( 'teleport', 'set_player', self )
  
  get_node('View/Crosshair/Control/Sprite2').visible = false
  

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
  
  if power_timer > 0 and dmg_powerup == true:
    power_timer -= delta
#    print ("power on ")
    
    if power_timer <= 0:
      print ("power up times up ")
      get_node( 'View/doubledamage').visible = false
      get_node('View/Crosshair/Control/Sprite2').visible = false
      get_node('View/Crosshair/Control/Sprite').visible = true
      dmg_powerup = false
      power_timer = 10
        
  var move_vec = Vector3()

  if Input.is_action_pressed( 'move_forwards' ) :
    move_vec.z -= 1
    get_node( 'View/hit' ).visible = false

  if Input.is_action_pressed( 'move_backwards' ) :
    move_vec.z += 1
    get_node( 'View/hit' ).visible = false
    
  if Input.is_action_pressed( 'move_left' ) :
    move_vec.x -= 1
    get_node( 'View/hit' ).visible = false
    
  if Input.is_action_pressed( 'move_right' ) :
    move_vec.x += 1
    get_node( 'View/hit' ).visible = false
    
  move_vec = move_vec.normalized()
  move_vec = move_vec.rotated( Vector3( 0, 1, 0 ), rotation.y )

  # warning-ignore:return_value_discarded
  move_and_collide( move_vec * MOVE_SPEED * delta )

  if Input.is_action_just_pressed( 'shoot' ) and !anim_player.is_playing() :
#    print('dd',dmg_powerup)
    
    if $'../HUD Layer'._ammoUsed() :
      if dmg_powerup == false:
        anim_player.play( 'shoot' )
      else:
        get_node('View/Crosshair/Control/Sprite').visible = false
        get_node('View/Crosshair/Control/Sprite2').visible = true
        anim_player.play( 'double_dmg' )
      
      get_tree().call_group( 'zombies', 'shockState', self )
      $'../Player Audio'._playSound( 'shoot' )
      
      var coll = raycast.get_collider()
      if raycast.is_colliding():
        if coll.has_method( 'hurt' ) :
          #print(dmg_powerup)
          if dmg_powerup == false:
            coll.hurt(1)
          else:
            coll.hurt(2)

    else :
      $'../Player Audio'._playSound( 'empty' )
  
  if Input.is_action_just_pressed( 'hit' ) and !anim_player.is_playing() :
    
    anim_player.play( 'hit' )
    $'../Player Audio'._playSound( 'hit' )

    var coll = raycast.get_collider()
    if raycast.is_colliding() and coll.has_method( 'burstImpact' ) :
        get_tree().call_group( 'zombies', 'burstImpact', translation, 5, 2 )
        get_tree().call_group( 'spawns', 'burstImpact', translation, 5, 2 )
        get_tree().call_group( 'obstacles', 'burstImpact', translation, 5, 2 )
        get_tree().call_group( 'npcs', 'burstImpact', translation, 5, 2 )
#-----------------------------------------------------------
func kill() :
  var timeStr = $'../HUD Layer'.getTimeStr()

  print( 'Player died at %s.' % timeStr )

  $'../Message Layer/Message'.activate( 'Player Died\n%s' % timeStr )

func hurt( qty ) :
  $'../HUD Layer'._increamentHealth( -qty )
  get_node( 'View/hit' ).visible = true

#-----------------------------------------------------------
func burstImpact( burst_translation, radius = 1, impact = 1 ):
  var dist = translation.distance_to( burst_translation ) 
  if dist < radius:
    hurt( impact )

#-----------------------------------------------------------
func set_spawn_status():
  return spawn_portal
#-----------------------------------------------------------
func set_player():
  get_tree().call_group( 'zombies', 'set_player', self )

#----------------------------------------------------------
func setDmgPowerUp():
  get_node( 'View/doubledamage' ).visible = true
  dmg_powerup = true
#-------------------------------------------------------------
func has_key():
  print(key_status)
  return key_status

func set_key_status(key = false):
  print(key)
  key_status = key
  
