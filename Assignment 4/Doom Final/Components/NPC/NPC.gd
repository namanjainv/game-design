extends KinematicBody

onready var raycast = $RayCast
onready var anim_player = $AnimationPlayer
onready var npc_message_layer = $'NPC Talk/Message'

var NEARBY_RADIUS = 15.0

var cooldown = 200
var player = null
var dead = false
var health = 1

# Called when the node enters the scene tree for the first time.
func _ready():
  anim_player.play( 'Walk' )
  add_to_group( 'npcs' )

#-----------------------------------------------------------
func _physics_process(delta):
  if dead :
    return

  if player == null :
    return
  
  cooldown += 1
  var dist = translation.distance_to( player.translation ) 
  if dist < 5.0 and not checkNearbyZombies( ) and cooldown >= 200:
    npc_message_layer.activate( )
    cooldown = 0
  
#-----------------------------------------------------------
func set_player( p ) :
  player = p

#-----------------------------------------------------------
func setHealth( hp ) :
  health =  hp

func checkNearbyZombies( ):
  var dist = 0.0;
  for member in get_tree().get_nodes_in_group("zombies"):
    dist = translation.distance_to( member.translation ) 
    if dist < NEARBY_RADIUS:
      return true
  return false
