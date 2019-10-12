extends KinematicBody

const MOVE_SPEED = 3

onready var raycast = $RayCast
onready var anim_player = $AnimationPlayer

var rng = RandomNumberGenerator.new()
var player = null
var dead = false
var HITS_TO_DIE = 2
var SENSE_DISTANCE = 20

func _ready():
	anim_player.play("walk")
	add_to_group("zombies")

func _physics_process(delta):
	if dead:
		return
	if player == null:
		return
		
	rng.seed = randi()
	var vec_movement = null
	if player.translation.distance_to(translation) > SENSE_DISTANCE:
		# Move zombie randomly
		var new_translation = translation
		new_translation[0] = rng.randi_range(-100,100)
		new_translation[2] = rng.randi_range(-100,100)
		vec_movement = new_translation - translation
	else:
		# Move zombie to the player
		vec_movement = player.translation - translation
		
	vec_movement = vec_movement.normalized()
	raycast.cast_to = vec_movement * 1.5
	
	move_and_collide(vec_movement * MOVE_SPEED * delta)
		
	
	
	if raycast.is_colliding():
		var coll = raycast.get_collider()
		if coll != null and coll.name == "Player":
			coll.kill()

func die():
	dead = true
	$CollisionShape.disabled = true
	anim_player.play("die")
	HITS_TO_DIE = 0

func kill():
	HITS_TO_DIE = HITS_TO_DIE - 1
	if HITS_TO_DIE == 0:
		die()

func set_player(p):
	player = p