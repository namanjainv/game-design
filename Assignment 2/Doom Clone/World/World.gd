extends Spatial

const DEFAULT_MAX_AMMO = 10

#-----------------------------------------------------------
func _ready() :
  get_tree().paused = false
  _loadArena()

func _loadArena() :
  var level = get_node('HUD Layer')._getLevel()
  print( level )
  _clearArena()
  var levelData = _getLevelData( level )

  var ammo = levelData.get( 'AMMO', null )
  if ammo != null :
    _addAmmo( ammo.get( 'tscn', null ), ammo.get( 'instances', [] ) )

  var zombies = levelData.get( 'ZOMBIES', null )
  if zombies != null :
    _addZombies( zombies.get( 'tscn', null ), zombies.get( 'instances', [] ) )

  var obstacles = levelData.get( 'OBSTACLES', null )
  if obstacles != null :
    _addObstacles( obstacles.get( 'tscn', null ), obstacles.get( 'instances', [] ) )

  var walls = levelData.get( 'WALLS', null )
  if walls != null :
    _addWall( walls.get( 'tscn', null ), walls.get( 'parameters', null ) )
  get_node( 'HUD Layer' )._resetAmmo( levelData.get( 'maxAmmo', DEFAULT_MAX_AMMO ) )
  
  get_node( 'Player' )._ready()

#-----------------------------------------------------------
func _input( __ ) :    # Not using event so don't name it.
  if Input.is_action_just_pressed( 'maximize' ) :
    OS.window_fullscreen = not OS.window_fullscreen

#-----------------------------------------------------------
func _addAmmo( model, instances ) :
  var inst
  var index = 0

  if model == null :
    print( 'There were %d ammo but no model?' % len( instances ) )
    return

  var ammoScene = load( model )

  for instInfo in instances :
    index += 1

    var pos = instInfo[ 0 ]
    var amount  = Utils.dieRoll( instInfo[ 1 ] )

    inst = ammoScene.instance()
    inst.name = 'Ammo-%02d' % index
    inst.translation = Vector3( pos[0], pos[1], pos[2] )
    inst.setQuantity( amount )
    print( '%s at %s, %d rounds.' % [ inst.name, str( pos ), amount ] )

    get_node( '.' ).add_child( inst )

func _addWall( model, parameters ):
  if model == null:
    print( 'There is no model for Walls defined' )
    return
  var wallScene = load( model )
  var inst 
  #- Horizontal Walls
  inst = wallScene.instance()
  inst.name = "Wall-01"
  inst.translation = Vector3( parameters.get( 'x', null ), parameters.get( 'height', null )*0.5, 0 )
  inst.scale = Vector3( 0.5, parameters.get( 'height', null ), parameters.get( 'z', null ))
  get_node( '.' ).add_child( inst )

  inst = wallScene.instance()
  inst.name = "Wall-02"
  inst.translation = Vector3( -parameters.get( 'x', null ), parameters.get( 'height', null )*0.5, 0 )
  inst.scale = Vector3( 0.5, parameters.get( 'height', null ), parameters.get( 'z', null ))
  get_node( '.' ).add_child( inst )
  
  #- Vertical Walls
  inst = wallScene.instance()
  inst.name = "Wall-03"
  inst.translation = Vector3( 0, parameters.get( 'height', null )*0.5, parameters.get( 'z', null ) )
  inst.scale = Vector3( parameters.get( 'x', null ), parameters.get( 'height', null ), 0.5 )
  get_node( '.' ).add_child( inst )

  inst = wallScene.instance()
  inst.name = "Wall-04"
  inst.translation = Vector3( 0, parameters.get( 'height', null )*0.5, -parameters.get( 'z', null ) )
  inst.scale = Vector3( parameters.get( 'x', null ), parameters.get( 'height', null ), 0.5 )
  get_node( '.' ).add_child( inst )
  print( "Walls added" )
    
#-----------------------------------------------------------
func _addObstacles( model, instances ) :
  var inst
  var index = 0

  if model == null :
    print( 'There were %d obstacles but no model?' % len( instances ) )
    return

  var obstacleScene = load( model )

  for instInfo in instances :
    index += 1

    var pos = instInfo[ 0 ]

    inst = obstacleScene.instance()
    inst.name = 'Obstacle-%02d' % index
    inst.translation = Vector3( pos[0], pos[1], pos[2] )
    print( '%s at %s added.' % [ inst.name, str( pos ) ] )

    get_node( '.' ).add_child( inst )

#-----------------------------------------------------------
func _addZombies( model, instances ) :
  var inst
  var index = 0

  if model == null :
    print( 'There were %d zombie but no model?' % len( instances ) )
    return

  var zombieScene = load( model )

  get_node( 'HUD Layer' )._resetOpponents( len( instances ) )

  for instInfo in instances :
    index += 1

    var pos = instInfo[ 0 ]
    var hp  = Utils.dieRoll( instInfo[ 1 ] )

    inst = zombieScene.instance()
    inst.name = 'Zombie-%02d' % index
    inst.translation = Vector3( pos[0], pos[1], pos[2] )
    inst.setHealth( hp )
    print( '%s at %s, %d hp' % [ inst.name, str( pos ), hp ] )

    get_node( '.' ).add_child( inst )

#-----------------------------------------------------------
func _getLevelData( levelNumber ) :
  var levelData = {}

  var fName = 'res://Levels/Level-%02d.json' % levelNumber

  var file = File.new()
  if file.file_exists( fName ) :
    file.open( fName, file.READ )
    var text_data = file.get_as_text()
    var result_json = JSON.parse( text_data )

    if result_json.error == OK:  # If parse OK
      levelData = result_json.result

    else :
      print( 'Error        : ', result_json.error)
      print( 'Error Line   : ', result_json.error_line)
      print( 'Error String : ', result_json.error_string)

  else :
    print( 'Level %d config file did not exist.' % levelNumber )

  return levelData

#-----------------------------------------------------------
func _clearArena():
  var defaultNodes = ['Player Audio', 'Player', 'Zombie Audio', 'HUD Layer', 'Message Layer']
  var worldNode = get_tree().get_root().get_node("World")
  for child in worldNode.get_children():
    if not child.name in defaultNodes:
      worldNode.remove_child(child)
  worldNode.get_node("Player").translation = Vector3(0, 0, 0)

func _checkFile( levelNumber ) :
  var fName = 'res://Levels/Level-%02d.json' % levelNumber

  var file = File.new()
  if file.file_exists( fName ) :
    return true
  else:
    return false

func _updateLevel():
  var currentLevel = $'HUD Layer'._getLevel() + 1
  $'HUD Layer'._setLevel(currentLevel)
  var timeStr = $'HUD Layer'.getTimeStr()
  if _checkFile(currentLevel) == false:
    $'HUD Layer'._setLevel(1)
    $'Message Layer/Message'.activate( 'Player Wins!\n%s' % timeStr )
  else:
    print("Move to next level")
    _loadArena()