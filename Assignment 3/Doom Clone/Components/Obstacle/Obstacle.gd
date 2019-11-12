extends RigidBody

onready var anim_player = $AnimationPlayer
onready var anim_audio = $BarrelAudio

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var radius = 0
var HITS_TO_BURST = 0
var BURST_IMPACT_HP = 0
var player = null
var burst = null

# Called when the node enters the scene tree for the first time.
func _ready():
  burst = false
  add_to_group( 'barrels' )
  anim_player.play( 'idle' ) 

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func setParams( hits_to_burst, impact_radius, impact_hp ):
  radius = impact_radius
  HITS_TO_BURST = hits_to_burst
  BURST_IMPACT_HP = impact_hp

func set_player( p ):
  player = p

func hurt( howMuch = 1 ) :
  HITS_TO_BURST -= howMuch

  if burst == false and HITS_TO_BURST <= 0 :
    anim_player.play( 'burst' ) 
    anim_audio._playSound( 'explode' )
    burst = true
    print( '%s burst.' % name )
    player.burstImpact( translation, radius, BURST_IMPACT_HP )
    get_tree().call_group( 'zombies', 'burstImpact', translation, radius, BURST_IMPACT_HP )

#-----------------------------------------------------------
func burstImpact( barrel_translation, radius, howMuch = 1 ):
  var dist = translation.distance_to( barrel_translation )
  if( dist < radius ):
    hurt( howMuch )