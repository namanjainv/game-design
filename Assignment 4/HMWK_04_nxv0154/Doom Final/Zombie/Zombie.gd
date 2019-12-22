extends KinematicBody

const MOVE_SPEED = 3
const COOLDOWN_TIME = 200

onready var raycast = $RayCast
onready var anim_player = $AnimationPlayer

var exploding_zombie = false
var IMPACT = 2
var BURST_RADIUS = 9

var state_time = 0
var attack_distance = 20.0
var my_state = "CHILL"
var cooldown_time = 2.0
var shock_time = 5.0
var shock_object = null
var peace_time = 10.0
var wander_translation = null

var player = null
var dead = false
var health = 1

#-----------------------------------------------------------
func _ready() :
  anim_player.play( 'chill' )
  add_to_group( 'zombies' )

#-----------------------------------------------------------
func _physics_process( delta ) :
  if dead :
    return

  if player == null :
    return
  
  var vec_to_player  

  state_time += delta
  var distance_to_player = translation.distance_to( player.translation )
  if distance_to_player < attack_distance :
    anim_player.play( 'walk' )
    vec_to_player = player.translation - translation
    if my_state == "COOLDOWN":
      if state_time < cooldown_time :
        vec_to_player = - vec_to_player
      else:
        my_state = "ATTACK"
        state_time = 0.01
    else:
      my_state = "ATTACK"
      state_time = 0.01
    
  else:
    if my_state == "SHOCK" :
      if  state_time < shock_time :
        vec_to_player = shock_object.translation - translation
        anim_player.play( 'walk' )
      else:
        vec_to_player = translation - translation
        my_state = "CHILL"
        state_time = 0.01
        anim_player.play( 'chill' )
    elif my_state == "WANDER":
      vec_to_player = wander_translation - translation
      if state_time > peace_time :
        my_state = "CHILL"
        state_time = 0.01
        anim_player.play( 'chill' )
    elif my_state == "CHILL":
      vec_to_player = translation - translation
      if state_time > peace_time :
        wander_translation = Utils.generate_Vector3()
        my_state = "WANDER"
        state_time = 0.01
        anim_player.play( 'walk' )
    else:
      vec_to_player = translation - translation
      my_state = "CHILL"
      state_time = 0.01
      anim_player.play( 'chill' )
  
  vec_to_player[1] = 0
  vec_to_player = vec_to_player.normalized()
  raycast.cast_to = vec_to_player * 1.5

  # warning-ignore:return_value_discarded
  move_and_collide( vec_to_player * MOVE_SPEED * delta )

  if raycast.is_colliding() :
    var coll = raycast.get_collider()
    if coll != null and coll.name == 'Player' and my_state == "ATTACK":
      my_state = "COOLDOWN"
      coll.hurt( 1 )

#-----------------------------------------------------------
func hurt( howMuch = 1 ) :
  health -= howMuch

  if health <= 0 :
    
    get_tree().call_group( 'zombies', 'shockState', self )
    dead = true
    translation[1] = 0
    $CollisionShape.disabled = true
    anim_player.play( 'die' )
    print( '%s died. Last damage: %d' % [name, howMuch] )
    $'../Zombie Audio'._playSound( 'die' )
    $'../HUD Layer'._opponentDied()

    # Zombie Burst 
    print( exploding_zombie )
    if exploding_zombie:
      $'../Zombie Audio'._playSound( "burst" )

      player.burstImpact( translation, BURST_RADIUS, IMPACT )
      get_tree().call_group( 'zombies', 'burstImpact', translation, BURST_RADIUS, IMPACT )
      yield(get_tree().create_timer(1.0), "timeout")
      get_tree().call_group( 'obstacles', 'burstImpact', translation, BURST_RADIUS, IMPACT )
      get_tree().call_group( 'spawns', 'burstImpact', translation, BURST_RADIUS, IMPACT )

  else :
    print( '%s wounded by %d, now has %d.' % [ name, howMuch, health ] )
    $'../Zombie Audio'._playSound( 'grunt' )

#-----------------------------------------------------------
func setHealth( hp ) :
  health =  hp

#-----------------------------------------------------------
func set_player( p ) :
  player = p

#-----------------------------------------------------------
func burstImpact( burst_translation, radius = 1, impact = 1 ):
  var dist = translation.distance_to( burst_translation ) 
  if not dead and dist < radius:
    hurt( impact )

#-----------------------------------------------------------
func setExplosion( value ) :
  exploding_zombie = value

#-----------------------------------------------------------
func shockState( object ):
  var distance_to_player = translation.distance_to( player.translation )
  if distance_to_player > attack_distance:
    my_state = 'SHOCK'
    state_time = 0.01
    shock_object = object