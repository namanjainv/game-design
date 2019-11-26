extends Node

#-----------------------------------------------------------
var rng = RandomNumberGenerator.new()

func _ready() :
  rng.randomize()

#-----------------------------------------------------------
# A die roll is a set of <num>d<size> or <value> items connected
# with + signs.  Spaces are ignored.

# Example:
#   "2d6 + 3" means roll a six sided die twice, add the results,
#   and then add 3 to that sum.

func dieRoll( dieStr ) :
  #print( "dieRoll( %s )" % str( dieStr ) )

  if typeof( dieStr ) in [ TYPE_INT, TYPE_REAL ] :
    #print( "  was int or real, returning %s." % str( dieStr ) )
    return dieStr

  dieStr = dieStr.replace( ' ', '' )

  var dies = dieStr.split( '+' )
  var roll = 0

  for die in dies :
    #print( "  die is %s" % die )

    var thisDie = die.split( 'd' )

    if len( thisDie ) == 1 :
      roll += int( thisDie[0] )

    elif len( thisDie ) == 2 :
      var num  = int( thisDie[0] )
      var size = int( thisDie[1] )
      var v;

      for __ in range( num ) :
        v = rng.randi_range( 1, size )
        #print( '  %d + %d => %d' % [ roll, v, roll+v ] )
        roll += v

    else :
      print( 'dieRoll does not understand "%s" (the "%s" part) as a die string.' %
        [ dieStr, die ] )

  #print( "  returning %d." % roll )

  return roll

#-----------------------------------------------------------

