// Parameters

length = 45; 
width = 62; // actual dimension is 60mm, just added wiggle room 
thickness = 5; 

light_port_width = 3;

screw_base_container_width = 17;
screw_base_container_height = 7.50;

screw_port_width = 5; 
screw_port_height = 5;

// prototypes
    bottom();
    connection_protector();

// modules
module base() {
    cube([length, width, thickness]);
}

module light_port() {
    cylinder(thickness + 1, light_port_width, light_port_width);
}

module bottom() {
    difference() {
        base();
        translate([34,20,0]) {
            light_port();
        }
    }
}

// centered: 4th Quadrent
module connection_protector() {
    difference() {
        translate([0, -thickness, -screw_base_container_height]) {
            cube([screw_base_container_width, thickness, screw_base_container_height + thickness]);
        }
        screw_terminal_cutout();
    }
    
}

module screw_terminal_cutout() {
    translate([(screw_base_container_width -screw_port_width)/2, -thickness, -screw_base_container_height]) {
        cube([screw_port_width, thickness, screw_port_height]);
    }
}
