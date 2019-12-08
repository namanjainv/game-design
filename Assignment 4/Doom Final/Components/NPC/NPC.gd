extends KinematicBody

onready var raycast = $RayCast
onready var anim_player = $AnimationPlayer
onready var npc_message_layer = $'NPC Talk/Message'

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
  
  var dist = translation.distance_to( player.translation ) 
  if dist < 10.0 and Input.is_action_pressed( 'NPCTalk' ) :
    npc_message_layer.activate( )
  
#-----------------------------------------------------------
func set_player( p ) :
  player = p

#-----------------------------------------------------------
func setHealth( hp ) :
  health =  hp

