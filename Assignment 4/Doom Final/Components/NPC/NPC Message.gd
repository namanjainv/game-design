extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var messageBox = get_node( 'Background/Message Box' )
onready var healthButton = get_node( 'Background/HealthKit' )
onready var ammoButton = get_node( 'Background/AmmoKit' )

var used = false

# Called when the node enters the scene tree for the first time.
func _ready():
  pass

#-----------------------------------------------------------
func deactivate( ) :
  visible = false
  get_tree().paused = false

#-----------------------------------------------------------
func activate( ) :
  var msg = "We are done talking" if used else "What can I help you with?"
  messageBox.text = msg
  visible = true

  get_tree().paused = true
  Input.set_mouse_mode( Input.MOUSE_MODE_VISIBLE )

#-----------------------------------------------------------
func _on_Exit_pressed():
  get_tree().paused = false
  visible = false

#-----------------------------------------------------------
func _on_HealthKit_pressed():
  healthButton.visible = false
  ammoButton.visible = false
  visible = false
  used = true
  get_tree().paused = false

#-----------------------------------------------------------
func _on_AmmoKit_pressed():
  healthButton.visible = false
  ammoButton.visible = false
  visible = false
  used = true
  get_tree().paused = false
