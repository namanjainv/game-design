#-----------------------------------------------------------
extends Control

#-----------------------------------------------------------
onready var messageBox = get_node( 'Background/Message Box' )

#-----------------------------------------------------------
func _input( event ) :
  if event.is_action_pressed( 'pause' ) :
    if not get_tree().paused :
      activate( 'Paused ...' )

    else :
      get_tree().paused = false
      visible = false
      Input.set_mouse_mode( Input.MOUSE_MODE_CAPTURED )

#-----------------------------------------------------------
func activate( msg ) :
  #print( 'activate( "', msg, '" )' )

  messageBox.text = msg
  visible = true

  get_tree().paused = true
  Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE )

#-----------------------------------------------------------
func _on_Exit_pressed() :
  get_tree().quit()

#-----------------------------------------------------------
func _on_Restart_pressed() :
  #print( 'restart pressed, paused is ', get_tree().paused )

  get_tree().paused = false

  #print( 'paused is now ', get_tree().paused )

  # warning-ignore:return_value_discarded
  get_tree().reload_current_scene()

#-----------------------------------------------------------
