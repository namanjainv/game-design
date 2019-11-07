extends KinematicBody

const MOVE_SPEED = 3
const COOLDOWNTIME = 200

onready var raycast = $RayCast
onready var anim_player = $AnimationPlayer

var player = null
var dead = false
var health = 1
var coolDown = 0

#-----------------------------------------------------------
func _ready() :
  anim_player.play( 'walk' )
  add_to_group( 'zombies' )
  $'../Player'.set_player()

#-----------------------------------------------------------
func _physics_process( delta ) :
  if dead :
    return

  if player == null :
    return
  
  var vec_to_player  
  if coolDown > COOLDOWNTIME:
    vec_to_player = player.translation - translation
  else:
    vec_to_player = - player.translation + translation

  coolDown += 1
  vec_to_player = vec_to_player.normalized()
  raycast.cast_to = vec_to_player * 1.5

  # warning-ignore:return_value_discarded
  move_and_collide( vec_to_player * MOVE_SPEED * delta )

  if raycast.is_colliding() :
    var coll = raycast.get_collider()
    if coll != null and coll.name == 'Player' and coolDown > COOLDOWNTIME:
      coolDown = 0
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
