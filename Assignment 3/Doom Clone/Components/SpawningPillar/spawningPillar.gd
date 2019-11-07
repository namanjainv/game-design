extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var spawningTime = 0
var elapsed_time = 0
var model = null
var newhp = null
var radii = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process( delta ) :
  elapsed_time += delta
  if( elapsed_time > spawningTime ):
    elapsed_time = 0
    var diffX = translation[0] - (pow(-1, Utils.dieRoll(radii))*Utils.dieRoll(radii))
    var diffZ = translation[2] - (pow(-1, Utils.dieRoll(radii))*Utils.dieRoll(radii))
    $'../../World'._addZombies( model , [ [ [ diffX, 1, diffZ ], newhp ] ] )
    $'../HUD Layer'._addZombie()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func setTime( qty ):
  spawningTime = qty

func setGenerationDetails( generation_model, hp, radius ):
  model = generation_model
  newhp = hp
  radii = radius