extends Spatial

onready var anim_audio = $BarrelAudio

var health = 1
var IMPACT = 2
var BURST_RADIUS = 9
var player = null
var burst = false

func _ready():
  add_to_group( 'obstacles' )

#-----------------------------------------------------------
func setHealth( hp ) :
  health =  hp

#-----------------------------------------------------------
func set_player( p ) :
  player = p

#-----------------------------------------------------------
func hurt( howMuch = 1 ) :
  if not burst:
    health -= howMuch
    if health <= 0 :
      burst = true
      print( '%s burst.' % name )
      anim_audio._playSound( "burst" )

      player.burstImpact( translation, BURST_RADIUS, IMPACT )
      get_tree().call_group( 'zombies', 'burstImpact', translation, BURST_RADIUS, IMPACT )
      yield(get_tree().create_timer(1.0), "timeout")
      get_tree().call_group( 'obstacles', 'burstImpact', translation, BURST_RADIUS, IMPACT )
    # Impact the surrounding by IMPACT in a following radius
    # Burst nearby barrels

  else :
    print( '%s wounded by %d, now has %d.' % [ name, howMuch, health ] )

#-----------------------------------------------------------
func burstImpact( burst_translation, radius = 1, impact = 1 ):
  var dist = translation.distance_to( burst_translation ) 
  if not burst and dist <= radius:
    hurt( impact )

#-----------------------------------------------------------