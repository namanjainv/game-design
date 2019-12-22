extends KinematicBody

onready var raycast = $RayCast
#onready var anim_player = $AnimationPlayer
onready var npc_message_layer = $'NPC Talk/Message'

var NEARBY_RADIUS = 15.0

var MOVE_SPEED = 2
var cooldown = 200
var player = null
var dead = false
var maxHealth = 1
var currHealth = 1

# Called when the node enters the scene tree for the first time.
func _ready():
#  anim_player.play( 'Walk' )
  add_to_group( 'npcs' )

#-----------------------------------------------------------
func _physics_process(delta):
  if dead :
    return

  if player == null :
    return
  
  look_at(player.translation, Vector3.UP)

  # Activating the NPC Talk module
  cooldown += 1
  var dist = translation.distance_to( player.translation ) 
  if dist < 5.0 and not checkNearbyZombies( NEARBY_RADIUS ) and cooldown >= 200:
    npc_message_layer.activate( )
    cooldown = 0

  # Managing NPC Movement
  var vector = findMyDirection( )
  
  var vec_movement = - vector + translation
  vec_movement[1] = 0

  vec_movement = vec_movement.normalized()
  raycast.cast_to = vec_movement * 1.5

  move_and_collide( vec_movement * MOVE_SPEED * delta )
  
#-----------------------------------------------------------
func set_player( p ) :
  player = p

#-----------------------------------------------------------
func setHealth( hp ) :
  maxHealth = hp
  currHealth =  hp

#-----------------------------------------------------------
func checkNearbyZombies( radius ):
  var dist = 0.0;
  for member in get_tree().get_nodes_in_group("zombies"):
    dist = translation.distance_to( member.translation ) 
    if dist < radius:
      return true
  return false

#-----------------------------------------------------------
func hurt( howMuch = 1 ) :
  currHealth -= howMuch

  if currHealth <= 0 :
    dead = true
    self.queue_free()

#-----------------------------------------------------------
func findMyDirection( ):
  var min_dist = 100000000
  var min_direction = null
  var dist = 0.0
  for zombie in get_tree().get_nodes_in_group("zombies"):
    dist = translation.distance_to(zombie.translation) 
    if dist < min_dist:
      min_dist = dist
      min_direction = zombie.translation 
  
  if currHealth != maxHealth:
    dist = translation.distance_to(player.translation) 
    if dist < min_dist:
      min_dist = dist
      min_direction = player.translation 
  min_direction[0] += 1
  return min_direction