extends CanvasLayer

var elapsedTime = 0
var lastTime    = 0

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

func _increamentAmmo( qty ):
  if numAmmo == maxAmmo:
    return false
  var newAmmo = numAmmo + qty
  numAmmo = newAmmo if newAmmo <= maxAmmo else maxAmmo
  _setAmmoMessage()
  return true
  
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
    
    if UserData.checkCompletionStatus( ):
      UserData.increamentCurrentLevel()
      $'../Message Layer/Message'.activate( 'Player Wins!\n%s' % timeStr )
    else:
      $'../Message Layer/Message/Background/Next'.disabled = false
      $'../Message Layer/Message/Background/Next'.visible = true
      $'../Message Layer/Message/Background/Restart'.disabled = true
      $'../Message Layer/Message/Background/Restart'.visible = false
      $'../Message Layer/Message'.activate( 'Level %d \nCompleted!\n%s' % [ UserData.CURRENT_LEVEL, timeStr ] );

#-----------------------------------------------------------
var maxHealth = 0
var currHealth = 0

func _resetHealth( qty ) :
  currHealth = qty
  maxHealth = qty
  _setHealthMessage()

func _setHealthMessage() :
  get_node( 'Health' ).text = '%d / %d' % [ currHealth, maxHealth ]

func _increamentHealth( qty ) :
  if currHealth == maxHealth and qty > 0:
    return false
  currHealth += qty
  currHealth = currHealth if currHealth <= maxHealth else maxHealth

  _setHealthMessage()
  if currHealth < 0 :
    $'../Player'.kill( )
  return true

