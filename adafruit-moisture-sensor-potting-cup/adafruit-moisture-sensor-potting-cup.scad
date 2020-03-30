
// user entered dimensions and features
use_water_outlet = true;
water_outlet_diameter = 5;

foot_post_radius = 5;
wall_thickness = 3;
cup_diameter = 80;
cup_height = 80;

pcb_tolerance = 1;

// dimensions of Adafruit sensor
pcb_width = 14;
sensor_components_length_on_pcb = 26;
pcb_mount_side_width = 4;
pcb_thickness = 1.7;
pcb_hole_diameter = 3;
pcb_hole_position_from_bottom = 3.5;
pcb_hole_position_from_center = 4.5;

// computed properties
wall_height = cup_height - cup_diameter / 2; 
actual_pcb_width = pcb_width + pcb_tolerance;
pcb_mount_width = actual_pcb_width + pcb_mount_side_width;

module capped_cylinder(h, r) {
    union() {
        sphere(r = r, $fn=10);
        cylinder(h = h, r = r, $fn=10);
    }
    
}

// The cylinder wall and the semisphere bottom
module pot_frame(r) {
    union() {
        difference() {
            union() {
                capped_cylinder(wall_height, r); 
                foot_posts(r);
            }
            
            capped_cylinder(wall_height + 1,r - wall_thickness);
            
            if(use_water_outlet) {
                translate([0,0, -cup_diameter / 2])
                cylinder(h = cup_diameter / 2, r = water_outlet_diameter / 2, $fn=100);
            }
            
        }   
        translate([-pcb_mount_width/2, r - wall_thickness, wall_height - sensor_components_length_on_pcb])
            rotate([90,0,0])
                pcb_mount_plate(5);
        
    }
}


// r is the radius of the cyclinder the foot posts will connect too.
module foot_posts(r) {
   for (i = [0:90:360]) {
        rotate([0,0, i])
            translate([r * 2/3, 0, -r])
                cylinder(h = r, r = foot_post_radius, $fn=100);
        
   }
}

module pcb_mount_plate_cutout() {
    union() {
        linear_extrude(height = pcb_thickness - 1/2 * pcb_tolerance)
        difference() {
           square([pcb_mount_width, sensor_components_length_on_pcb]);
           translate([pcb_mount_side_width/2, 0, 0])
            square([actual_pcb_width, sensor_components_length_on_pcb]);
        }
        translate([pcb_mount_width/2 - pcb_hole_position_from_center, pcb_hole_position_from_bottom, 0])
            cylinder(pcb_thickness, d = pcb_hole_diameter - pcb_tolerance / 2, $fn=100);
        translate([pcb_mount_width/2 + pcb_hole_position_from_center, pcb_hole_position_from_bottom, 0])
            cylinder(pcb_thickness, d = pcb_hole_diameter - pcb_tolerance / 2, $fn=100);
    }
}

// the cutout for the pcb on the side wall
module pcb_mount_plate(t)  {
    union() {
        linear_extrude(height = t)
            square([pcb_mount_width, sensor_components_length_on_pcb]);
        translate([-2, sensor_components_length_on_pcb / 2, 0])
            screw_post(t);
        translate([actual_pcb_width + 6, sensor_components_length_on_pcb / 2, 0])
            screw_post(t);
    }
}


module screw_post(h) {
    difference() {
        cylinder(h, r = 4);
        cylinder(h, r = 2);
    }
}

module pcb_support_posts() {
   cylinder(pcb_thickness, d = pcb_hole_diameter - pcb_tolerance / 2, $fn=100);
}


module pcb_mount_reciever() {
    linear_extrude(height = 10)
        square([10, 10]);
}

pot_frame(cup_diameter/2);
//linear_extrude(height =  ) 

//pcb_mount_plate();
//translate([0,0,pcb_thickness])
    //pcb_mount_plate_cutout();

//screw_post(10);