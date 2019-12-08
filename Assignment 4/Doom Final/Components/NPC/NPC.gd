extends KinematicBody

onready var raycast = $RayCast
onready var anim_player = $AnimationPlayer
onready var npc_message_layer = $'NPC Talk/Message'

var NEARBY_RADIUS = 15.0

var MOVE_SPEED = 2
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
  
  # Activating the NPC Talk module
  cooldown += 1
  var dist = translation.distance_to( player.translation ) 
  if dist < 5.0 and not checkNearbyZombies( ) and cooldown >= 200:
    npc_message_layer.activate( )
    cooldown = 0

  # Managing NPC Movement
  var vector = findMyDirection( )
  var vec_movement = - vector + translation

  vec_movement = vec_movement.normalized()
  raycast.cast_to = vec_movement * 1.5

  move_and_collide( vec_movement * MOVE_SPEED * delta )
  
#-----------------------------------------------------------
func set_player( p ) :
  player = p

#-----------------------------------------------------------
func setHealth( hp ) :
  health =  hp

#-----------------------------------------------------------
func checkNearbyZombies( ):
  var dist = 0.0;
  for member in get_tree().get_nodes_in_group("zombies"):
    dist = translation.distance_to( member.translation ) 
    if dist < NEARBY_RADIUS:
      return true
  return false

#-----------------------------------------------------------
func hurt( howMuch = 1 ) :
  health -= howMuch

  if health <= 0 :
    dead = true
    self.queue_free()

#-----------------------------------------------------------
func findMyDirection( ):
  var possible_directions = [ ]
  possible_directions.append( translation + Vector3(20, 0, 0 ) )
  possible_directions.append( translation + Vector3(-20, 0, 0 ) ) 
  possible_directions.append( translation + Vector3(0, 0, 20 ) ) 
  possible_directions.append( translation + Vector3(0, 0, -20 ) ) 
  possible_directions.append( translation + Vector3(20, 0, 20 ) )
  possible_directions.append( translation + Vector3(-20, 0, -20 ) ) 
  possible_directions.append( translation + Vector3(-20, 0, 20 ) ) 
  possible_directions.append( translation + Vector3(20, 0, -20 ) ) 
  var min_dist = 100000000
  var min_direction = null
  var dist = 0.0
  for direction in possible_directions:
    dist = 0.0
    for zombie in get_tree().get_nodes_in_group("zombies"):
      dist += direction.distance_to(zombie.translation) 
    if dist < min_dist:
      min_dist = dist
      min_direction = direction 
  return min_direction