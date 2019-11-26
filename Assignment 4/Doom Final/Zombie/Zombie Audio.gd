extends AudioStreamPlayer

var sounds = {
    'grunt' : load( 'res://Audio/Male Grunt-SoundBible.com-68178715.wav' ),
    'die'   : load( 'res://Audio/Wilhelm Scream - 0477.wav' )
  }

func _playSound( which, fromTime = 0.0 ) :
  var sound = sounds.get( which, null )

  if sound == null :
    print( 'Zombie: Unknown sound "%s" requested.' % which )
    return

  stream = sound

  play( fromTime )
