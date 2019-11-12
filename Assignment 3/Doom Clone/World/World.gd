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

  get_node( 'HUD Layer' )._resetHealth( 5 )

  var ammo = levelData.get( 'AMMO', null )
  if ammo != null :
    _addAmmo( ammo.get( 'tscn', null ), ammo.get( 'instances', [] ) )

  var zombies = levelData.get( 'ZOMBIES', null )
  if zombies != null :
    get_node( 'HUD Layer' )._resetOpponents( len( zombies.get( 'instances', [] ) ) )
    _addZombies( zombies.get( 'tscn', null ), zombies.get( 'instances', [] ) )

  var obstacles = levelData.get( 'OBSTACLES', null )
  if obstacles != null :
    _addObstacles( obstacles.get( 'tscn', null ), obstacles.get( 'instances', [] ) )
	
  var healthkits = levelData.get( 'FIRSTAID', null )
  if healthkits != null :
    _addHealthKits( healthkits.get( 'tscn', null ), healthkits.get( 'instances', [] ) )

  var walls = levelData.get( 'arenaSize', null )
  if walls != null :
    _addWall( "res://Components/Wall/Wall.tscn" , walls )
  get_node( 'HUD Layer' )._resetAmmo( levelData.get( 'maxAmmo', DEFAULT_MAX_AMMO ) )
  
  var spawningPillars = levelData.get( 'SPAWNING_PILLARS', null )
  if spawningPillars != null :
    _addSpawningPillars( spawningPillars.get( 'tscn', null ), spawningPillars.get( 'instances', [] ) )

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
    
  var carpetModel = load ( "res://Components/Floors/Carpet.tscn" )

  var wallScene = load( model )
  var inst 

  inst = carpetModel.instance()
  inst.name = "Floor"
  inst.scale = Vector3(parameters[0], 1, parameters[1])
  inst.translation = Vector3(0, -0.1, 0)
  get_node( '.' ).add_child( inst )

  #- Horizontal Walls
  inst = wallScene.instance()
  inst.name = "Wall-01"
  inst.translation = Vector3( parameters[0]/2, 1.5, 0 )
  inst.scale = Vector3( 0.5, 3, parameters[1]/2 )
  get_node( '.' ).add_child( inst )

  inst = wallScene.instance()
  inst.name = "Wall-02"
  inst.translation = Vector3( -parameters[0]/2, 1.5, 0 )
  inst.scale = Vector3( 0.5, 3, parameters[1]/2 )
  get_node( '.' ).add_child( inst )
  
  #- Vertical Walls
  inst = wallScene.instance()
  inst.name = "Wall-03"
  inst.translation = Vector3( 0, 1.5, parameters[1]/2 )
  inst.scale = Vector3( parameters[0]/2, 3, 0.5 )
  get_node( '.' ).add_child( inst )

  inst = wallScene.instance()
  inst.name = "Wall-04"
  inst.translation = Vector3( 0, 1.5, -parameters[1]/2 )
  inst.scale = Vector3( parameters[0]/2, 3, 0.5 )
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
    var hp = Utils.dieRoll( instInfo[ 1 ] )
    var burst_impact_radius = Utils.dieRoll( instInfo[ 2 ] )
    var burst_impact_hp = Utils.dieRoll( instInfo[ 3 ] )

    inst = obstacleScene.instance()
    inst.name = 'Obstacle-%02d' % index
    inst.translation = Vector3( pos[0], pos[1]+1, pos[2] )
    inst.setParams( hp, burst_impact_radius, burst_impact_hp )
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

func _addHealthKits( model, instances ) :
  var inst
  var index = 0

  if model == null :
    print( 'There were %d health kits but no model?' % len( instances ) )
    return

  var healthKitscene = load( model )

  for instInfo in instances :
    index += 1

    var pos = instInfo[ 0 ]
    var amount  = Utils.dieRoll( instInfo[ 1 ] )

    inst = healthKitscene.instance()
    inst.name = 'Health-%02d' % index
    inst.translation = Vector3( pos[0], pos[1], pos[2] )
    inst.setQuantity( amount )
    print( '%s at %s, %d rounds.' % [ inst.name, str( pos ), amount ] )

    get_node( '.' ).add_child( inst )

func _addSpawningPillars( model, instances ) :
  var inst
  var index = 0

  if model == null :
    print( 'There were %d spawning pillars but no model?' % len( instances ) )
    return

  var spawningPillarscene = load( model )

  for instInfo in instances :
    index += 1

    var pos = instInfo[ 0 ]
    var time  = Utils.dieRoll( instInfo[ 1 ] )

    inst = spawningPillarscene.instance()
    inst.name = 'Pillar-%02d' % index
    inst.translation = Vector3( pos[0], pos[1], pos[2] )
    inst.setTime( time )
    inst.setGenerationDetails( instInfo[2], instInfo[3], instInfo[4] )
    print( '%s at %s, %d spawn time.' % [ inst.name, str( pos ), time ] )

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