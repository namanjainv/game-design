extends AudioStreamPlayer

var sounds = { 
  "burst": load( "res://Assets/Explosive Barrel/Audio/Explosion7.wav" )
}

func _playSound( which, fromTime = 0.0 ) :
  var sound = sounds.get( which, null )

  if sound == null :
    print( 'Barrel: Unknown sound "%s" requested.' % which )
    return

  stream = sound

  play( fromTime )