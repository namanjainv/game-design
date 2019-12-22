extends Spatial

onready var anim_audio = $'PlatformAudio'

var generationTime = 0

var currHealth = 1
var maxHealth = 1

var elapsed_time = 0
var spawningTime = 5

var IMPACT = 3
var BURST_RADIUS = 20

var rng = RandomNumberGenerator.new()

var player = null
var burst = false
var zombieModel = null
var explodingZombieModel = null

#-----------------------------------------------------------
func _ready():
  add_to_group( 'spawns' )
  rng.randomize()

#-----------------------------------------------------------
func _process( delta ) :
  if not burst:
    elapsed_time += delta
    var spawnTime = ( spawningTime * currHealth ) / maxHealth
    if( elapsed_time > spawnTime ):
      elapsed_time = 0
      if rng.randi_range(-50,50) > 0:
        $'../../World'._addZombies( zombieModel , [ [ [ translation[0], translation[1], translation[2] ], "2d2" ] ], false )
      else:
        $'../../World'._addZombies( explodingZombieModel , [ [ [ translation[0], translation[1], translation[2] ], "2d2" ] ], true )

#-----------------------------------------------------------
func setHealth( hp ) :
  currHealth = hp
  maxHealth = hp

#-----------------------------------------------------------
func setTime( time ) :
  generationTime =  time

#-----------------------------------------------------------
func set_player( p ) :
  player = p

#-----------------------------------------------------------
func hurt( howMuch = 1 ) :
  if not burst:
    currHealth -= howMuch
    if currHealth <= 0 :
      
      get_tree().call_group( 'zombies', 'shockState', self )
      burst = true
      print( '%s burst.' % name )
      anim_audio._playSound( "burst" )

      player.burstImpact( translation, BURST_RADIUS, IMPACT )

      $"smoke-green".visible = false
      $"smoke-green2".visible = false
      $"smoke-red".visible = true
      $"smoke-red2".visible = true

      get_tree().call_group( 'zombies', 'burstImpact', translation, BURST_RADIUS, IMPACT )
      yield(get_tree().create_timer(1.0), "timeout")
      get_tree().call_group( 'obstacles', 'burstImpact', translation, BURST_RADIUS, IMPACT )
      get_tree().call_group( 'spawns', 'burstImpact', translation, BURST_RADIUS, IMPACT )

  else :
    print( '%s wounded by %d, now has %d.' % [ name, howMuch, currHealth ] )

#-----------------------------------------------------------
func burstImpact( burst_translation, radius = 1, impact = 1 ):
  var dist = translation.distance_to( burst_translation ) 
  if not burst and dist <= radius:
    hurt( impact )

#-----------------------------------------------------------
func setZombieModel( Zmodel, Emodel ):
  zombieModel = Zmodel
  explodingZombieModel = Emodel

#-----------------------------------------------------------