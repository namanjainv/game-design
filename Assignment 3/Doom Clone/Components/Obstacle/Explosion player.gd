extends AudioStreamPlayer

var sounds = {
    'explode' : load( 'res://Audio/Explosion7.wav' )
  }

func _playSound( which, fromTime = 0.0 ) :
  var sound = sounds.get( which, null )

  if sound == null :
    print( 'Player: Unknown sound "%s" requested.' % which )
    return

  stream = sound

  play( fromTime )
