/*
    Author: Kevin Lutzer
    Date Created: January 16 2018
    Description: The bottom for a raspberry pi W case
*/

/////////////////////////////////////////////////// Parameters /////////////////////////////////////////////////

standoff_height = 5;
standoff_width = 5;

board_height = 2;

hmdi_connector_height = 4; // the max clearence needed

rpi_base_length = 65;
rpi_base_width = 30;
rpi_base_corner_radius = 3;
rpi_standoff_diameter = 6;
rpi_standoff_screw_diameter = 0.75;
rpi_standoff_height = 3;
rpi_standoff_spacing_from_corner = 3.5;
rpi_thickness = 1.5;


cavity_length = 25;

// Peripherals

hdmi_port_length = 11.5;
hdmi_port_height = 3.5;
hdmi_port_offset = 12.4;
usb_port_1_offset = 41.4;
usb_port_2_offset = 54;
usb_port_length = 8;
camera_zif_width = 20;
camera_zif_length = 2;
sd_width = 12;
sd_height = 1.5;
fan_cutout_vent_offset = (usb_port_1_offset - hdmi_port_offset) /2 + hdmi_port_offset;

rpi_case_wall_thickness = 3;
rpi_case_bottom_height = rpi_thickness + rpi_case_wall_thickness + rpi_standoff_height + hdmi_port_height;
rpi_case_width = 2*rpi_case_wall_thickness + rpi_base_width;
rpi_case_length = 2*rpi_case_wall_thickness + rpi_base_length + cavity_length;
rpi_case_length = 2*rpi_case_wall_thickness + rpi_base_length;
rpi_case_standoff_radius = 5;
rpi_case_hole_radius = 1.5;
rpi_mount_radius = 3;


/////////////////////////////////////////////////// Modules //////////////////////////////////////////////////

module rpi_corner_standoff(angle = 0) {
  rotate([0,0, angle]) {
    linear_extrude(height=rpi_standoff_height){
      difference() {
        union() {
          square([rpi_standoff_spacing_from_corner, rpi_standoff_spacing_from_corner]);
          circle(d=rpi_standoff_diameter, $fn=100);
        }
        circle(d=rpi_standoff_screw_diameter, $fn=100);
      }
    }
  }
}

module rpi_case_corner_standoff(height) {
  linear_extrude(height=height){
    difference() {
      circle(r=rpi_case_standoff_radius, $fn=100);
      circle(r=rpi_case_hole_radius, $fn=100);
    }
  }
}

module rpi_base_cutout() {
    translate([(-rpi_base_length/2) - cavity_length, -rpi_base_width/2, 0]) {
        square([cavity_length, rpi_base_width]);
    }
   	hull()
	{
		// place 4 circles in the corners, with the given radius
		translate([(-rpi_base_length/2) + rpi_base_corner_radius - cavity_length, (-rpi_base_width/2) + rpi_base_corner_radius, 0])
		circle(r=rpi_base_corner_radius, $fn=100);
	
		translate([(rpi_base_length/2) - rpi_base_corner_radius, (-rpi_base_width/2) + rpi_base_corner_radius, 0])
		circle(r=rpi_base_corner_radius, $fn=100);
	
		translate([(-rpi_base_length/2) + rpi_base_corner_radius - cavity_length, (rpi_base_width/2) - rpi_base_corner_radius, 0])
		circle(r=rpi_base_corner_radius, $fn=100);
	
		translate([(rpi_base_length/2) - rpi_base_corner_radius, (rpi_base_width/2 - rpi_base_corner_radius), 0])
		circle(r=rpi_base_corner_radius, $fn=100);
	}
}

module rpi_case_corner_standoffs(height) {
      
  // bottom left
  translate([(-rpi_case_length/2) - cavity_length, (-rpi_case_width/2), 0])
  rpi_case_corner_standoff(height);

  // bottom right
  translate([(rpi_case_length/2), (-rpi_case_width/2), 0])
  rpi_case_corner_standoff(height);

  // top left
  translate([(-rpi_case_length/2) - cavity_length, (rpi_case_width/2), 0])
  rpi_case_corner_standoff(height);

  // top right
  translate([(rpi_case_length/2), (rpi_case_width/2), 0])
  rpi_case_corner_standoff(height);
}

module rpi_base_corner_standoffs() {
      
  // bottom left
  translate([(-rpi_base_length/2)+(rpi_standoff_spacing_from_corner), (-rpi_base_width/2)+(rpi_standoff_spacing_from_corner), 0])
  rpi_corner_standoff(180);

  // bottom right
  translate([(rpi_base_length/2)-(rpi_standoff_spacing_from_corner), (-rpi_base_width/2)+(rpi_standoff_spacing_from_corner), 0])
  rpi_corner_standoff(270);

  // top left
  translate([(-rpi_base_length/2)+(rpi_standoff_spacing_from_corner), (rpi_base_width/2)-(rpi_standoff_spacing_from_corner), 0])
  rpi_corner_standoff(90);

  // top right
  translate([(rpi_base_length/2)-(rpi_standoff_spacing_from_corner), (rpi_base_width/2)-(rpi_standoff_spacing_from_corner), 0])
  rpi_corner_standoff();
}

module rpi_case_profile() {
  hull()
  {
    // bottom left
    translate([(-rpi_case_length/2) - cavity_length + rpi_case_standoff_radius, (-rpi_case_width/2) + rpi_case_standoff_radius, 0])
    circle(r=rpi_case_standoff_radius, $fn=100);

    // bottom right
    translate([(rpi_case_length/2) - rpi_case_standoff_radius, (-rpi_case_width/2) + rpi_case_standoff_radius, 0])
    circle(r=rpi_case_standoff_radius, $fn=100);

    // top left
    translate([(-rpi_case_length/2) - cavity_length + rpi_case_standoff_radius, (rpi_case_width/2) - rpi_case_standoff_radius, 0])
    circle(r=rpi_case_standoff_radius, $fn=100);

    // top right
    translate([(rpi_case_length/2) - rpi_case_standoff_radius, (rpi_case_width/2) - rpi_case_standoff_radius, 0])
    circle(r=rpi_case_standoff_radius, $fn=100);
  }  
}

module rpi_case_bottom() {
  difference() {
    union() {
      rpi_case_mounts();
      rpi_base_corner_standoffs();
      rpi_case_corner_standoffs(rpi_case_bottom_height);
      translate([0, 0, rpi_case_wall_thickness]) {rpi_base_corner_standoffs();}
      linear_extrude(height=rpi_case_bottom_height) {
            difference() {
                rpi_case_profile();
                rpi_base_cutout();
            }
          }
        
      linear_extrude(height=rpi_case_wall_thickness) {
        rpi_case_profile();
      }
    }
    rpi_peripherals_case_bottom_cutout();
  }
}

module rpi_case_top() {
  difference() {
    union() {
      rpi_case_mounts();
      rpi_base_corner_standoffs();
      rpi_case_corner_standoffs(rpi_case_bottom_height);
      translate([0, 0, rpi_case_wall_thickness]) {rpi_base_corner_standoffs();}
      linear_extrude(height=rpi_case_bottom_height) {
            difference() {
                rpi_case_profile();
                rpi_base_cutout();
            }
          }
        
      linear_extrude(height=rpi_case_wall_thickness) {
        rpi_case_profile();
      }
    }
    rpi_peripherals_case_bottom_cutout();
  }
}

module rpi_case_mount() {
  linear_extrude(height=rpi_case_wall_thickness) {
    difference() {
        square([4*rpi_mount_radius, 4*rpi_mount_radius]);
        translate([2*rpi_mount_radius, 2*rpi_mount_radius]) circle(r=rpi_mount_radius, $fn=100);
    }
  }
}

module rpi_case_mounts() {
  translate([rpi_case_length/2, - 2*rpi_mount_radius, 0]) rpi_case_mount();
  translate([-rpi_case_length/2 - 4 *rpi_mount_radius - cavity_length, - 2*rpi_mount_radius, 0]) rpi_case_mount();
  
}

module rpi_case_bottom_base() {
    linear_extrude(height=rpi_case_wall_thickness) {
      rpi_base_cutout();
    }
}

module rpi_peripherals_case_bottom_cutout() {
  translate([-rpi_case_length/2, -rpi_case_width/2, rpi_case_bottom_height - hdmi_port_height]) {
    linear_extrude(height=hdmi_port_height) {
      union() {
        translate([hdmi_port_offset - hdmi_port_length/2, 0, 0]) { square([hdmi_port_length, rpi_case_wall_thickness]); }
        translate([usb_port_1_offset - usb_port_length/2, 0, 0]) { square([usb_port_length, rpi_case_wall_thickness]); }
        translate([usb_port_2_offset - usb_port_length/2, 0, 0]) { square([usb_port_length, rpi_case_wall_thickness]); }
        translate([rpi_case_length - rpi_case_wall_thickness, rpi_case_width/2 - camera_zif_width/2]) { square([rpi_case_wall_thickness, camera_zif_width]); }
        translate([0, rpi_case_width/2 - sd_width/2]) { square([rpi_case_wall_thickness, sd_width]); }
        translate([fan_cutout_vent_offset - 8, 0, 0]) { 
          for(i = [0:5]) {
            translate([i*3, 0, 0]) {square([1.5, rpi_case_wall_thickness]);}
            
          }
        }
      }
    }
  }
}

/////////////////////////////////////////////////// Prototypes /////////////////////////////////////////////////
//rpi_case_bottom_base();
//rpi_case_base();
rpi_case_top();
//rpi_base_cutout();
//rpi_case_profile();
//rpi_base_corner_standoffs();
//rpi_corner_standoff(270);
//rpi_base_corner_standoffs();
//rpi_case_profile();
//rpi_base_cutout();
//rpi_case_bottom();
//rpi_base_corner_standoffs();
//rpi_case_corner_standoffs(rpi_case_bottom_height);
//rpi_case_corner_standoffs();
//rpi_case_corner_standoff();
//rpi_case_corner_standoff();
//rpi_case_mount();
//rpi_peripherals_case_bottom_cutout();
//rpi_case_mounts();