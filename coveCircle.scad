// openscad module to make a polyhedron for a quarter-round
// cove-molding shape along a circular path.  Written 17 May 2019 by
// James Waldby.  © 2019.  Available for use without warranty under
// GPL v3 terms per http://www.gnu.org/licenses/gpl.html

module coveMold (edgeRadius=4,     // Edge-rounding radius
                 circleRadius=100, // Circle radius
                 startAngle=0,     // Start angle
                 endAngle=90,      // End angle
                 stepsPerCircle=60, // Segments per circle
                 stepsPerCove=5,    // Points in cove quarter-round
                 showDetails=false) // Whether to print RZ, rex & pointl
{ function slice(a) = [ for (rz=sliceRZ) [rz[0]*cos(a), rz[0]*sin(a), rz[1]] ];
  function makeRex(b1, b2) =  // want list in clockwise order
    [ for(i=[0:QRn])[b1+i, b1+(i+1)%QRm, b2+(i+1)%QRm, b2+i] ];

  QRn = stepsPerCove;
  QRm = QRn+1;
  eps = 0.01;
  // Number of steps in arc of circle from startAngle to endAngle
  nStep = ceil(stepsPerCircle*(endAngle-startAngle)/360);
  // Make list with r,z pairs: radial distance and height of point
  // Need 90+epsilon to prevent missing 90, particularly if QRn=8
  sliceRZ = [for(qangle=[0 : 90/(QRn-1) : 90+eps])
      [circleRadius-edgeRadius*(1-sin(qangle)),
       edgeRadius*(1-cos(qangle))], [circleRadius, 0]];
  if (showDetails) echo("sliceRZ",sliceRZ);
  // Make clockwise surface rectangles + clockwise end-slices
  frex = [ for (k=[0 : nStep-1]) each makeRex(k*QRm, k*QRm+QRm),
         [ each [0 : 1 : QRn] ],
         [ each [QRm*nStep+QRn : -1 : QRm*nStep]] ];
  if (showDetails) echo("frex",frex);
  // Make list of points, ie of rectangle corner coordinates.
  // Rectangles are planar because slices are radial and equal
  pointl = [for(a=[startAngle : (endAngle-startAngle)/nStep : endAngle+eps])
      for (rz=sliceRZ) [rz[0]*cos(a), rz[0]*sin(a), rz[1]]];
  if (showDetails) echo("pointl",pointl);
  polyhedron(points=pointl, faces=frex);
}
/* Local Variables:   */
/* mode:        scad  */
/* tab-width:      2  */
/* c-basic-offset: 2  */
/* End:               */
