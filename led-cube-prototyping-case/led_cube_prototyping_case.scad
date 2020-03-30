/* 
    Author: Kevin Lutzer
    Created: March 28 2020
    Description: Case for a led 4X4 Led matrix I made.
*/

// Dimensions
pcb_width = 72;
pcb_length = 92;
pcb_height_from_bottom = 3;
wall_thickness = 2;
bottom_thickness = 2;
wall_height = 16;
screw_position = 4;


// Hole dimensions for led points
hole_width = 35;
hole_length = 8;
hole_spacing = 16;
hole_diameter = 5;

// connections dimensions
connection_width = 30;
connection_length = 12;

module bottom() {
   linear_extrude(height = bottom_thickness)
    square([pcb_width + 2 * wall_thickness, pcb_length + 2 * wall_thickness]);
}

module wall() {
    linear_extrude(height = wall_height)
        difference() {
            square([pcb_width + 2 * wall_thickness, pcb_length + 2 * wall_thickness]);
            translate([wall_thickness, wall_thickness])
                square([pcb_width, pcb_length]);
        }     
}


module base_screw_post() {
   linear_extrude(height = wall_height + bottom_thickness )
        difference() {
            circle(r = 4);
            circle(d = 2.4);
        }
}

module base_screw_posts() {
  translate([-wall_thickness, -wall_thickness])
    base_screw_post();
  translate([-wall_thickness, pcb_length + wall_thickness])
    base_screw_post(); 
  translate([pcb_width + wall_thickness, pcb_length + wall_thickness])
    base_screw_post(); 
  translate([pcb_width + wall_thickness, - wall_thickness])
    base_screw_post(); 
} 

module pcb_screw_post() {
   linear_extrude(height = bottom_thickness + pcb_height_from_bottom )
        difference() {
            circle(r = 4);
            circle(d = 2.4);
        }
}

module pcb_screw_posts() {
    translate([screw_position, screw_position])
        pcb_screw_post();
    translate([screw_position, pcb_length - screw_position])
        pcb_screw_post();
    translate([pcb_width - screw_position, screw_position])
        pcb_screw_post();
    translate([pcb_width - screw_position, pcb_length - screw_position])
        pcb_screw_post();
}

module base() {
    union() {
        translate([-wall_thickness, -wall_thickness, bottom_thickness])
            wall();
        translate([-wall_thickness, -wall_thickness, 0])
            bottom();
        pcb_screw_posts();
        base_screw_posts();
    }
}

module top() {
    linear_extrude(height = bottom_thickness)
        square([pcb_length + 2 * wall_thickness, pcb_width + 2 * wall_thickness]);
}


module hole_grid() {
    linear_extrude(h = bottom_thickness) {
        for (j = [0:hole_spacing:3 * hole_spacing]) {
            for (i = [0:hole_spacing:3 * hole_spacing]) {
                translate([hole_width + i, hole_length + j, 0])
                    circle(d = hole_diameter, $fn=100);
            }
        }
    }
        
}

difference() {
    top();
    hole_grid();
    translate([0,0,0])
        square([connection_width, connection_length]);
}
