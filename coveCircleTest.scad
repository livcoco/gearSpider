/* [Radius Params:] */
// Edge-rounding radius
edgeRound=4;
// Circle radius
circRadi=61;
// Start angle
startAngle=15;
// End angle
endAngle=75;
// Segments per circle
$fn=40;
// Points in quarter-round (0-90 degrees)
QRn=5;
// Show point and rectangles lists
showDetails=false;

use <coveCircle.scad>

coveMold (edgeRound, circRadi, startAngle, endAngle, $fn, QRn, showDetails);

/* Local Variables:   */
/* mode:        scad  */
/* tab-width:      2  */
/* c-basic-offset: 2  */
/* End:               */
