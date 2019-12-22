extends StaticBody

onready var anim_audio = $BarrelAudio

var health = 3

var IMPACT = 3
var BURST_RADIUS = 10

var expl = false
var fire_particles

var player = null

#-----------------------------------------------------------
func _ready():
  fire_particles = $Fire
  fire_particles.emitting = false
  add_to_group( 'obstacles' )

#-----------------------------------------------------------
func hurt( howMuch = 1) :
  health -= howMuch
 
  if health <= 0 and expl == false :
    expl = true
    fire_particles.emitting = true
    print( '%s burst.' % name )

    anim_audio._playSound( "burst" )
    player.burstImpact( translation, BURST_RADIUS, IMPACT )
    get_tree().call_group( 'zombies', 'burstImpact', translation, BURST_RADIUS, IMPACT )
    get_tree().call_group( 'zombies', 'shockState', self )
    yield(get_tree().create_timer(1.0), "timeout")
    get_tree().call_group( 'obstacles', 'burstImpact', translation, BURST_RADIUS, IMPACT )
    get_tree().call_group( 'spawns', 'burstImpact', translation, BURST_RADIUS, IMPACT )

  else :
    print( '%s wounded by %d, now has %d.' % [ name, howMuch, health ] )

#-----------------------------------------------------------
func burstImpact( burst_translation, radius = 1, impact = 1 ):
  var dist = translation.distance_to( burst_translation ) 
  if not expl and dist <= radius:
    hurt( impact )

#-----------------------------------------------------------
func setHealth( hp ) :
  health =  hp

#-----------------------------------------------------------
func set_player( p ) :
  player = p
