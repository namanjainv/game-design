extends CanvasLayer

var elapsedTime = 0
var lastTime    = 0
var currentLevel = 1

#-----------------------------------------------------------
func _ready() :
  elapsedTime = 0

#-----------------------------------------------------------
func _process( delta ) :
  _updateHUDTime( delta )

#-----------------------------------------------------------
func _updateHUDTime( delta ) :
  elapsedTime += delta

  if elapsedTime - lastTime > 1 :
    lastTime = elapsedTime

    get_node( 'LevelTime' ).text = getTimeStr()

func getTimeStr() :
  var minutes = int( elapsedTime / 60 )
  var seconds = int( elapsedTime - minutes*60 )

  return '%02d:%02d' % [ minutes, seconds ]

#-----------------------------------------------------------
var maxAmmo = 0
var numAmmo = 0

func _resetAmmo( qty ) :
  maxAmmo = qty
  numAmmo = qty
  _setAmmoMessage()

func _setAmmoMessage() :
  get_node( 'Ammo' ).text = '%d / %d' % [ numAmmo, maxAmmo ]

func _ammoUsed() :
  var success = numAmmo != 0

  if success :
    numAmmo -= 1

  _setAmmoMessage()
  return success

func _increamentAmmo ( qty ):
  if( numAmmo < maxAmmo ):
    var temp = numAmmo + qty
    numAmmo = temp if temp < maxAmmo else maxAmmo
    _setAmmoMessage()
    return true
  else:
    return false

#-----------------------------------------------------------
var maxOpponents = 0
var numOpponents = 0

func _resetOpponents( qty ) :
  maxOpponents = qty
  numOpponents = qty
  _setOpponentMessage()

func _setOpponentMessage() :
  get_node( 'Opponents' ).text = '%d / %d' % [ numOpponents, maxOpponents ]

func _opponentDied() :
  numOpponents -= 1
  _setOpponentMessage()

  if numOpponents == 0 :
    var timeStr = $'../HUD Layer'.getTimeStr()
  
    print( 'Last opponent died at %s.' % timeStr )
    $'../../World'._updateLevel()

func _addZombie() :
  maxOpponents += 1
  numOpponents += 1
  _setOpponentMessage()


#-----------------------------------------------------------

func _getLevel() :
  return currentLevel

func _setLevel(val):
  currentLevel = val

#-----------------------------------------------------------

var maxHealth = 0
var currentHealth = 0

func _resetHealth( qty ) :
  maxHealth = qty
  currentHealth = qty
  _setPlayerHealthMessage()

func _setPlayerHealthMessage(): 
  get_node( 'Health' ).text = '%d / %d' % [ currentHealth, maxHealth ]

func _playerHit( howMuch = 1 ):
  currentHealth -= howMuch
  _setPlayerHealthMessage()

func _increamentHealth ( qty ):
  if( currentHealth < maxHealth ):
    var temp = currentHealth + qty
    currentHealth = temp if temp < maxHealth else maxHealth
    _setPlayerHealthMessage()
    return true
  else:
    return false
    
