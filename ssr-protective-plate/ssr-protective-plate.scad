/*------------------------ Parameters ------------------------*/
length = 62; 
width = 45; // actual dimension is 60mm, just added wiggle room 
thickness = 3; 

light_port_width = 3;

screw_base_container_width = 17;
screw_base_container_height = 7.50;

screw_port_width = 5; 
screw_port_height = 5;

mount_width = 1.5;
mount_offset = 7.5;

/*------------------------ Prototpyes ------------------------*/
ssr_plate();

/*------------------------ Modules ------------------------*/
module ssr_plate() {
    difference() {
        union() {
            bottom();
            connection_protector();
            translate([width - screw_base_container_width, 0, 0]) {
                connection_protector();
            }
            translate([width - screw_base_container_width, length+thickness, 0]) {
                connection_protector();
            }
            translate([0, length+thickness, 0]) {
                connection_protector();
            }
        }
        translate([width/2, mount_offset, 0]) {
            cylinder(thickness, mount_width, mount_width, $fn=100);
        }
        translate([width/2, length - mount_offset, 0]) {
            cylinder(thickness, mount_width, mount_width, $fn=100);
        }    
    }
}

module bottom() {
    difference() {
        cube([width, length, thickness]);
        translate([34,20,0]) {
            cylinder(thickness, light_port_width, light_port_width, $fn=100); // cutout for the signal led
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