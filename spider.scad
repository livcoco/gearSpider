// spider.scad -- test-fixture/gear-holder for use with gears and arms
// as made by 8gear.scad.  jiw 26 Apr 2019

/* [Arm and Countersink Params:] */
// Number of arms to print
numberArmsPrint = 3;
// Hub Diameter
HubDiam=20;
// Edge-holder Diameter
EdgeDiam=20;
// Nominal Arm Length (0=none)
ArmLength=60;
// Arm Width, mm
ArmWidth=9;
// Arm Thickness, mm (0=none)
ArmThick=10;
// Countersink polygon sides
counterSides=6;
// Countersink diameter (0=none, <0=inscribed, >0=circumscribed)
counterDiam=-11.3;
// Countersink depth
counterDepth=5;
/* [Gear Params:] */
// Circular pitch of gears
circPitch=7; // [1:100]
// Central (Sun) Teeth
sunTeeth=18; // [3:3:300]
// Edge (Planet) Teeth
edgeTeeth=18; // [3:3:300]
/* [Ring Params:] */
// Ring outside diameter
ringOD = 127;
// Ring inside diameter
ringID = 117;
// Ring Thickness, mm (0=none)
ringThick=10;
/* [Plate and Hole Params:] */
// Plate diameter
plateDiam = 127;
// Plate Thickness, mm (0=none)
plateThick=2;
// Sun Gear Holder Thickness
SgearThick=10;
// Edge Gear Holder Thickness
EgearThick=10;
// Through hole tap diameter 
holeDiam = 6.3;
// Segments per circle
$fn=60;

// Notes for holeDiam initial customizer value:
//   5.2 mm = ~ .205" = approx. tap hole size for 1/4-20 screw
// Notes for counterDiam.  7/16" = 0.4375" = 11.11 mm + .15mm slop = 11.26 =~ 11.3mm .  This is the apothem so use -11.3mm (inscribed)
// 
// GFgear provides gear outlines and functions for gear dimensions
use <GFgear.scad>

// Compute sun and edge gears center-to-center distance
centerToCenter = pitch_radius(sunTeeth,circPitch) + pitch_radius(edgeTeeth,circPitch);

angleStep = 360/numberArmsPrint;

// Make a polyhedron of `depth` thickness, horizontal top and bottom
// surfaces, and `nSides` vertical sides.  The diameter is inscribed
// if diam<0, none if diam==0 or depth==0, and circumscribed if diam>0.
module countersink(nSides, diam, depth, topAt) {
  if (diam != 0 && depth>0) {
    wd = diam<0? (-diam / cos(180/nSides)) : diam;
    //echo ("Countersink diam", diam, "depth", depth, "circle", wd);
    translate([0,0,topAt-depth]) {
      linear_extrude(height=depth*2, center=false, convexity=2, twist=0) {
        circle(d=wd,$fn=nSides);
      }
    }
  }
}

difference() {
  union() {
    // Arms with edge bolt-holder stanchions ...
    for (arm = [0:numberArmsPrint-1]) {
      rotate([0,0,arm*angleStep]) {
        translate([centerToCenter,0,0])
          cylinder (d=EdgeDiam, h=EgearThick, center=false);
        if (ArmThick>0) {
          translate([0,-ArmWidth/2,0])
            cube([ArmLength, ArmWidth, ArmThick], center=false);
        }
      }
    }
    
    if (ringThick>0) { // Surrounding ring ...
      difference() {
        cylinder (d=ringOD, h=ringThick, center=false);
        cylinder (d=ringID, h=ringThick*3, center=true);
      }
    }
    
    if (plateThick>0) { // Plate ...
      cylinder (d=plateDiam, h=plateThick, center=false);
    }

    // Hub bolt-holder stanchion
    cylinder (d=HubDiam, h=SgearThick, center=false);
  }
  // Now take away bolt holes and countersinks
  cylinder(d=holeDiam, h=SgearThick*3, center=true); // Hub
  countersink(counterSides, counterDiam, counterDepth, SgearThick);
  if (EdgeDiam>0) {
    for (arm = [0:numberArmsPrint-1])
      rotate([0,0,arm*angleStep]) {
        translate([centerToCenter,0,0]) {
          cylinder(d=holeDiam, h=EgearThick*3, center=true);
          countersink(counterSides, counterDiam, counterDepth, EgearThick);
        }
      }
  }
}

/* Local Variables:   */
/* mode:        scad  */
/* tab-width:      2  */
/* c-basic-offset: 2  */
/* End:               */
