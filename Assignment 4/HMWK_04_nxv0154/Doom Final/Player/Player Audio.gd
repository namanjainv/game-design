extends AudioStreamPlayer

var sounds = {
    'shoot' : load( 'res://Audio/Pew_Pew-DKnight556-1379997159.wav' ),
    'empty' : load( 'res://Audio/Gun+Empty.wav' ),
    'hit'   : load( 'res://Assets/Player/Audio/Axe Swing-SoundBible.com-2003027449.wav' )
  }

func _playSound( which, fromTime = 0.0 ) :
  var sound = sounds.get( which, null )

  if sound == null :
    print( 'Player: Unknown sound "%s" requested.' % which )
    return

  stream = sound

  play( fromTime )
