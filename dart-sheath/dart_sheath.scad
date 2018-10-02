  /*
  Description: A sheath for a throwing dart
*/



///////////////////////////// Parameters //////////////////////////////////

// knife parameters

// The total thickness of the blade
knife_thickness = 6;
// The width of the sharp edge of the blade
blade_width = 36;
// The height of the blade measured from the tip to center of the base of the blade
blade_height = 59;
blade_angle = atan(blade_height/blade_width);

// case parameters 

// The thickness of the walls for the sheath
wall_thickness = 10;
wall_seperator = wall_thickness/(2*cos(blade_angle));

base_width = 2 * (wall_seperator + blade_width/2);
base_height = tan(blade_angle) * base_width;

// The hole radius for the bungie cord loops
bungie_hole_radius = 4;
// The radius of the holes used to register the two sides of the sheath 
support_hole_radius = 2;
// Margin for the holes used to register the two sides of the sheath
support_hole_slop = 0.5;
// Thickness of the sheath. This number must always be greater then the knife thickness
sheath_thickness = 10;
bottom_support_height = bungie_hole_radius * 4;
bottom_support_width = base_width + 8 * bungie_hole_radius;

nose_cutout_height = base_height - blade_height - wall_thickness;
nose_cutout_width = nose_cutout_height/tan(blade_angle);


///////////////////////////// Modules //////////////////////////////////////

module half_knife() {
    linear_extrude(height = knife_thickness/2+1, center = 0, convexity = 10, twist = 0){
      knife_profile();
    }
}

module knife_profile() {
    polygon(points=[[blade_width/2, 0], [0, blade_height], [-blade_width/2, 0]]);
}

module base_profile() {
    polygon(points=[[base_width/2, 0],[0, base_height],[-base_width/2, 0]]);
}

module half_base() {
    linear_extrude(height = sheath_thickness/2, center = 0, convexity = 10, twist = 0){
      difference() {
        union(){
          base_profile();
          translate([-bottom_support_width/2,0,0]) {
            square([bottom_support_width, bottom_support_height]);
          }
        }
        translate([-bottom_support_width/2+2*bungie_hole_radius, bottom_support_height/2, 0]){
          circle(r=bungie_hole_radius, $fn=100);
        }
        translate([bottom_support_width/2-2*bungie_hole_radius, bottom_support_height/2, 0]){
          circle(r=bungie_hole_radius, $fn=100);
        }
      }
    }  
}

module nose_cutout() {
  translate([-nose_cutout_width, blade_height+wall_thickness,-2]) {
      linear_extrude(height = sheath_thickness/2+4, center = 0, convexity = 10, twist = 0) {
        square([50,30]);
      }
  }
}

module half_sheath() {
  difference() {
    union(){
      half_base();
    }
    translate([0,0,sheath_thickness/2-knife_thickness/2]){
      half_knife(); 
    }
    nose_cutout();
  }
}

module bottom_half_sheath() {
  union() {
    difference() {
      union(){
        half_base();
      }
      translate([0,0,sheath_thickness/2-knife_thickness/2]){
        half_knife(); 
      }
      nose_cutout();
    }
    translate([0,0,sheath_thickness/4]){
      support_hole_template();
    }
  }
}

module top_half_sheath() {
  difference() {
    difference() {
      union(){
        half_base();
      }
      nose_cutout();
    }
    translate([0,0,sheath_thickness/4]){
      support_hole_template(support_hole_slop);
    }
  }
}

module support_hole_template(slop = 0) {
  linear_extrude(height = sheath_thickness/2, center = 0, convexity = 10, twist = 0) {
    translate([-base_width/2, bottom_support_height/2, 0]){ circle(r=support_hole_radius + slop, $fn=100); }
    translate([base_width/2, bottom_support_height/2, 0]){ circle(r=support_hole_radius + slop, $fn=100); }
    translate([0, blade_height + wall_thickness/2, 0]){ circle(r=support_hole_radius + slop, $fn=100); }     
  } 
}

///////////////////////////// Design
top_half_sheath();
translate([0,-base_height,0]) {
    bottom_half_sheath();
};