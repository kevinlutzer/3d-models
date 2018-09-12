/*
  Description: A sheath for a throwing dart
*/



///////////////////////////// Parameters //////////////////////////////////

// knife parameters
thickness = 4;
width = 36;
height = 59;

// case parameters 
wall_scale = 1.5;
sheath_thickness = 10;
bottom_support_height = 16;
bottom_support_width = 60;

// bungie cord terminals
hole_width = 4;
hole_placement_from_side = 7;

///////////////////////////// Modules //////////////////////////////////////

module half_knife() {
    linear_extrude(height = thickness/2, center = 0, convexity = 10, twist = 0){
      half_knife_profile();
    }
}

module half_knife_profile() {
    polygon(points=[[width/2, 0], [0, height], [-width/2, 0]]);
}

module half_base() {
    linear_extrude(height = sheath_thickness/2, center = 0, convexity = 10, twist = 0){
      difference() {
        union(){
          scale([wall_scale, wall_scale]) {
            half_knife_profile();
          }
          translate([-bottom_support_width/2,0,0]) {
            square([bottom_support_width, bottom_support_height]);
          }
        }
        translate([-bottom_support_width/2+hole_placement_from_side, bottom_support_height/2, 0]){
          circle(r=hole_width, $fn=100);
        }
        translate([bottom_support_width/2-hole_placement_from_side, bottom_support_height/2, 0]){
          circle(r=hole_width, $fn=100);
        }
      }
    }  
}

module nose_cutout() {
  linear_extrude(height = sheath_thickness/2, center = 0, convexity = 10, twist = 0){ 
    difference() {
      translate([-5,0]){
        square([10,10]);
      }
      circle(r=5);
    }
  }
}

module bottom_half_sheath() {
  difference() {
    union(){
      half_base();
    }
    translate([0,0,sheath_thickness/2-thickness/2]){
      half_knife(); 
    }
  }
}

///////////////////////////// Design
//nose_cutout();
bottom_half_sheath();