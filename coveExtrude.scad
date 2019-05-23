// openscad module to make an extruded polyhedron for a quarter-round
// cove-molding shape along a circular path.  Written 22 May 2019 by
// James Waldby.  © 2019.  Available for use without warranty under
// GPL v3 terms per http://www.gnu.org/licenses/gpl.html

module coveMold (edgeRadius=4,     // Edge-rounding radius
                 circleRadius=100, // Circle radius
                 startAngle=0,     // Start angle
                 endAngle=90,      // End angle
                 stepsPerCircle=60, // Segments per circle
                 stepsPerCove=5,    // Points in cove quarter-round
                 showDetails=false) // Whether to print recurve points
{ eps = 0.01;
  // Make list with x,y pairs for shape to extrude
  // Need 90+epsilon to prevent missing 90, particularly if stepsPerCove=8
  recurve = [for(qangle=[0 : 90/(stepsPerCove-1) : 90+eps])
      [circleRadius-edgeRadius*(1-sin(qangle)),
       edgeRadius*(1-cos(qangle))], [circleRadius, 0]];
  if (showDetails) echo("recurve",recurve);
  rotate(a=[0,0,startAngle])
    rotate_extrude(angle=endAngle-startAngle, convexity=10, $fn=stepsPerCircle)
      polygon(points=recurve);
}
/* Local Variables:   */
/* mode:        scad  */
/* tab-width:      2  */
/* c-basic-offset: 2  */
/* End:               */
