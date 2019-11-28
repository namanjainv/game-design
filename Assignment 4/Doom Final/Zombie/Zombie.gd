extends KinematicBody

const MOVE_SPEED = 3

onready var raycast = $RayCast
onready var anim_player = $AnimationPlayer

var player = null
var dead = false
var health = 1

#-----------------------------------------------------------
func _ready() :
  anim_player.play( 'walk' )
  add_to_group( 'zombies' )

#-----------------------------------------------------------
func _physics_process( delta ) :
  if dead :
    return

  if player == null :
    return

  var vec_to_player = player.translation - translation

  vec_to_player = vec_to_player.normalized()
  raycast.cast_to = vec_to_player * 1.5

  # warning-ignore:return_value_discarded
  move_and_collide( vec_to_player * MOVE_SPEED * delta )

  if raycast.is_colliding() :
    var coll = raycast.get_collider()
    if coll != null and coll.name == 'Player' :
      coll.kill()

#-----------------------------------------------------------
func hurt( howMuch = 1 ) :
  health -= howMuch

  if health <= 0 :
    dead = true
    $CollisionShape.disabled = true
    anim_player.play( 'die' )
    print( '%s died.' % name )
    $'../Zombie Audio'._playSound( 'die' )
    $'../HUD Layer'._opponentDied()

  else :
    anim_player.play( 'wounded' )
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
