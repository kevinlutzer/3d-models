/*
    Author: Kevin Lutzer
    Date Created: January 16 2018
    Description: The bottom for a raspberry pi W case
*/

/////////////////////////////////////////////////// Parameters /////////////////////////////////////////////////

case_thickness = 4;
rpi_width = 70;
rpi_length = 25;

case_width = 2*case_thickness + rpi_width;
case_length = 2*case_thickness + rpi_length;

standoff_height = 5;
standoff_width = 5;

board_height = 2;

hmdi_connector_height = 4; // the max clearence needed

rpi_base_length = 65;
rpi_base_width = 30;
rpi_base_corner_radius = 3;
rpi_standoff_diameter = 6;
rpi_standoff_screw_diameter = 2.75;
rpi_standoff_height = 3;
rpi_header_height = 9;
rpi_thickness = 1.5;


rpi_case_wall_thickness = 3;
rpi_case_bottom_height = rpi_header_height + rpi_standoff_height;
rpi_case_width = 2*rpi_case_wall_thickness + rpi_base_width;
rpi_case_length = 2*rpi_case_wall_thickness + rpi_base_length;
rpi_case_hole_radius = 4;

hdmi_port_length = 11.5;
hdmi_port_height = 3.5;
usb_port_length = 8;

/////////////////////////////////////////////////// Modules //////////////////////////////////////////////////

module rpi_corner_standoff() {
    linear_extrude(height=rpi_standoff_height){
      difference() {
        circle(d=rpi_standoff_diameter, $fn=100);
        circle(d=rpi_standoff_screw_diameter, $fn=100);
      }
  }
}

module rpi_base_cutout() {
   	hull()
	{
		// place 4 circles in the corners, with the given radius
		translate([(-rpi_base_length/2)+(rpi_base_corner_radius/2), (-rpi_base_width/2)+(rpi_base_corner_radius/2), 0])
		circle(r=rpi_base_corner_radius, $fn=100);
	
		translate([(rpi_base_length/2)-(rpi_base_corner_radius/2), (-rpi_base_width/2)+(rpi_base_corner_radius/2), 0])
		circle(r=rpi_base_corner_radius, $fn=100);
	
		translate([(-rpi_base_length/2)+(rpi_base_corner_radius/2), (rpi_base_width/2)-(rpi_base_corner_radius/2), 0])
		circle(r=rpi_base_corner_radius, $fn=100);
	
		translate([(rpi_base_length/2)-(rpi_base_corner_radius/2), (rpi_base_width/2)-(rpi_base_corner_radius/2), 0])
		circle(r=rpi_base_corner_radius, $fn=100);
	}
}

module rpi_base_corner_standoffs() {
      translate([(-rpi_base_length/2)+(rpi_base_corner_radius/2), (-rpi_base_width/2)+(rpi_base_corner_radius/2), 0])
      rpi_corner_standoff();
  
      translate([(rpi_base_length/2)-(rpi_base_corner_radius/2), (-rpi_base_width/2)+(rpi_base_corner_radius/2), 0])
      rpi_corner_standoff();
  
      translate([(-rpi_base_length/2)+(rpi_base_corner_radius/2), (rpi_base_width/2)-(rpi_base_corner_radius/2), 0])
      rpi_corner_standoff();
  
      translate([(rpi_base_length/2)-(rpi_base_corner_radius/2), (rpi_base_width/2)-(rpi_base_corner_radius/2), 0])
      rpi_corner_standoff();
}

module rpi_case_base() {
  translate([-rpi_case_length/2, -rpi_case_width/2]) {
    square([rpi_case_length, rpi_case_width]);
  }
}

module rpi_case_bottom() {
  union() {
    translate([0,0,rpi_case_wall_thickness]) {
        linear_extrude(height=rpi_case_bottom_height) {
          difference() {
              rpi_case_base();
              rpi_base_cutout();
          }
        }
      rpi_base_corner_standoffs();
    }
    linear_extrude(height=rpi_case_wall_thickness) {
      rpi_case_base();
    }
  }
}

module rpi_case_mount() {
  linear_extrude(height=rpi_case_wall_thickness) {
    difference() {
        square([4*rpi_case_hole_radius, 4*rpi_case_hole_radius]);
        translate([2*rpi_case_hole_radius, 2*rpi_case_hole_radius]) circle(r=rpi_case_hole_radius, $fn=100);
    }
  }
}

module rpi_case_mounts() {
  translate([rpi_case_length/2, - 2*rpi_case_hole_radius, 0]) rpi_case_mount();
  translate([-rpi_case_length/2 - 4 *rpi_case_hole_radius, - 2*rpi_case_hole_radius, 0]) rpi_case_mount();
}

module rpi_peripherals_case_bottom_cutout() {
  translate([-rpi_base_length/2, -rpi_base_width/2])
  linear_extrude(height=hdmi_port_height) {
    square([hdmi_port_length, rpi_case_wall_thickness]);
  }
  
  linear_extrude(height=hdmi_port_height) {
    square([hdmi_port_length, rpi_case_wall_thickness]);
  }
}

/////////////////////////////////////////////////// Prototypes /////////////////////////////////////////////////

//case_bottom();
//rpi_base_cutout();
//rpi_base_corner_standoffs();
//rpi_corner_standoff();
//rpi_corner_standoff();
//rpi_base_corner_standoffs();
//rpi_case_bottom();
//rpi_case_mount();
rpi_peripherals_case_bottom_cutout();
//rpi_case_mounts();