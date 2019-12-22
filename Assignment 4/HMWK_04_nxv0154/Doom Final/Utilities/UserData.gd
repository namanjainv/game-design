extends Node

var fileName = "res://Utilities/userData.json"

var CURRENT_LEVEL = 1
var END_LEVEL = 3


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#-----------------------------------------------------------
func save_game( ):
    var save_game = File.new()
    save_game.open( fileName, File.WRITE)
    var user_data = {
      "currentLevel": CURRENT_LEVEL,
      "endLevel": END_LEVEL
    }
    save_game.store_line(to_json(user_data))
    save_game.close()

#-----------------------------------------------------------
func _getUserData( ):
  var userData = { }
  var file = File.new()
  if file.file_exists( fileName ):
    file.open( fileName, file.READ )
    var text_data = file.get_as_text()
    var result_json = JSON.parse( text_data )

    if result_json.error == OK:
      userData = result_json.result
      CURRENT_LEVEL = userData.get( 'currentLevel', null )
      END_LEVEL = userData.get( 'endLevel', null )
      
    else :
      print( 'Error        : ', result_json.error)
      print( 'Error Line   : ', result_json.error_line)
      print( 'Error String : ', result_json.error_string)

  else :
    print( 'userData file does not exist' )

  return userData

#-----------------------------------------------------------
func increamentCurrentLevel( ):
  CURRENT_LEVEL += 1
  if CURRENT_LEVEL > END_LEVEL:
    CURRENT_LEVEL = 1
  save_game( )

#-----------------------------------------------------------
func checkCompletionStatus( ):
  return CURRENT_LEVEL == END_LEVEL


