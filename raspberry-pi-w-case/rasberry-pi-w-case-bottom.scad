/*
    Author: Kevin Lutzer
    Date Created: January 16 2018
    Description: The bottom for a raspberry pi W case. This file contains the meta information to be used with Makerbot/Thingiverse Customizer.
*/

/////////////////////////////////////////////////// Parameters /////////////////////////////////////////////////


/* [Case] */

//Is the olerance of the raspberry pi width and length. This number will effect the tightness of the PCB in the case
base_tolerance = 1;
//Is the diameter of the standoffs used to secure the raspberry pi to the case 
standoff_diameter = 6;
//Is the diameter of the srew hole in the standoffs that are used to secure the raspberry pi to the case
standoff_screw_diameter = 1.5;
//Is the width of the cavity added for extra space to store electronics and wires (Y axis)
case_cavity_width = 5;
//Is the thickness of the case
case_wall_thickness = 2;
//Is the height of the top portion of the case. This value represents the difference between the top face of the case and the top of the hdmi port. 
case_top_height = 35;
//Is the radius of the standoffs used to secure the two parts of the case together
case_standoff_radius = 3;
//Is the radius of the screw used to secure the two parts of the case together
case_hole_radius = 1.5;
//Is the radius of the screw used to mount the case onto some panel. 
case_mount_radius = 3;

/* [Fan] */

// Is the size of the fan. It usually represents the length of the one of the sides of a square fan
fan_size = 30;
// Is the X-Y offset of the mounting holes reference to the nearest sides
fan_hole_spacing_from_corner = 3;
// iIs the radius of the fan hole
fan_hole_radius = 1.8;

/* [Hidden] */

//Length of the raspberry pi
base_length = 65;
//Width of the raspberry pi
base_width = 30;
//Radius of the four corners of the raspberry pi pcb
base_corner_radius = 3;
//Thickness of the raspberry pi pcb
thickness = 1.5;
//Height of the standoffs used to secure the raspberry pi to the case
standoff_height = 3;
//X-Y position of the center of the standoffs to the sides of the raspberry pi pcb
standoff_spacing_from_corner = 3.5;
//Diameter of the standoffs used to support the raspberry pi from the case
standoff_diameter = 6;
//Width of the raspiberry pi (Y axis)
case_width = 2*case_wall_thickness + base_width + base_tolerance;
//Length of the raspberry pi (X axis)
case_length = 2*case_wall_thickness + base_length + base_tolerance;
//Length of the hdmi mini port on the raspberry pi (X axis)
hdmi_port_length = 11.5;
//Height of the hdmi mini port (Z axis)
hdmi_port_height = 3.5;
//X-Position of the center of the hdmi mini port reference to the edge of the pcb 
hdmi_port_offset = 12.4;
//X-Position of the center of the usb port closest to the htmi port, reference to the center of the hdmi port
usb_port_1_offset = 41.4;
//X-Position of the center of second usb port closest reference to the center of the hdmi port
usb_port_2_offset = 54;
//Lenght of the usb ports
usb_port_length = 8;
//Width of the raspberry pi camera connector
camera_zif_width = 20;
//Width of the sd card
sd_width = 12;
//Height of the sd card
sd_height = 1.5;
//Y-Position of the center of the SD card reference to the bottom left edge
sd_offset = 16.9;
//The height of the bottom of the raspberry pi case (Z axis)
case_bottom_height = thickness + case_wall_thickness + standoff_height + hdmi_port_height;

vent_segment_amount = 8;


// Refactor
peripheral_cutout_width = hdmi_port_offset - usb_port_1_offset + hdmi_port_length/2 + usb_port_length/2;
vent_width = case_width - 3*standoff_diameter;
vent_length = case_length - 4*standoff_diameter;
vent_segment_length = vent_length/vent_segment_amount;
fan_cutout_vent_offset = (usb_port_1_offset - hdmi_port_offset) /2 + hdmi_port_offset;


/////////////////////////////////////////////////// Modules //////////////////////////////////////////////////

module base_cutout() {
    rounded_corner_rectangle(base_length + base_tolerance, base_width + base_tolerance, case_cavity_width, base_corner_radius, 0 );
}

module base_corner_standoffs() {
  mounting_holes(base_length - standoff_spacing_from_corner * 2, base_width - standoff_spacing_from_corner * 2, base_corner_radius, standoff_screw_diameter/2, 0);
}

module case_profile() {
  rounded_corner_rectangle(case_length, case_width, case_cavity_width, case_standoff_radius, 0);
}

module case_wall_profile() {
  difference() {
    case_profile();
    base_cutout();
  }
}

module case_wall(height) {
  linear_extrude(height=height) {
    union() {
      case_wall_profile();
      mounting_holes(case_length, case_width, case_standoff_radius, case_hole_radius, case_cavity_width);
    }
  }
}

module case_mount_profile() {
  translate([case_length/2, - 2*case_mount_radius + case_cavity_width/2, 0]) {
    difference() {
      square([4*case_mount_radius, 4*case_mount_radius]);
      translate([2*case_mount_radius, 2*case_mount_radius]) circle(r=case_mount_radius, $fn=100);
    }
  }
  
  translate([ -case_length/2 -4*case_mount_radius, - 2*case_mount_radius + case_cavity_width/2, 0]) {
    difference() {
      square([4*case_mount_radius, 4*case_mount_radius]);
      translate([2*case_mount_radius, 2*case_mount_radius]) circle(r=case_mount_radius, $fn=100);
    }
  }
}

module case_bottom() {
  difference() {
    union() {
        // The wall withitout the bottom mounting holes
        case_wall(case_bottom_height);
        
        // Bottom of the case / The base profile
        linear_extrude(height=case_wall_thickness) {
            case_profile();
        }
        
        //if (air_management) {
          //linear_extrude(height=case_wall_thickness*2) {
          //    case_mount_profile();
          //}
        //}
        
        // Standoffs to hold the rapsberry pi from the base
        translate([0, 0, case_wall_thickness]) {
          linear_extrude(height=standoff_height) {
            base_corner_standoffs();
          }
        }
    }
    
    // Peripherals and other cutouts. 
    peripherals_case_bottom_cutout();
    vent_cutout();
  }
}

module case_top() {
  union() {
    // The wall of the case 
    case_wall(case_top_height + case_wall_thickness);
    linear_extrude(height=case_wall_thickness) {
      difference() {
          case_profile();
          //if (air_management) {
            //translate([base_length/2 - fan_size/2, 0, 0]){fan_profile();}
          //}
      }
    }
  }
}

module case_bottom_base() {
    linear_extrude(height=case_wall_thickness) {
      base_cutout();
    }
}

module vent_profie() {
  translate([0,vent_width/2,0]){circle(d=vent_segment_length/2, $fn=100);}
  translate([-vent_segment_length/4,-vent_width/2,0]){square([vent_segment_length/2,vent_width]);}
  translate([0,-vent_width/2,0]){circle(d=vent_segment_length/2, $fn=100);}
}

module vent_cutout() {
    linear_extrude(height=case_wall_thickness) {
    for(i = [0:vent_segment_amount-1]) {
      translate([i*vent_segment_length - vent_length/2 + vent_segment_length/2, 0, 0]) {
        vent_profie();
      }
    }
  }
}

module peripherals_case_bottom_cutout() {
  translate([0, 0, case_bottom_height-hdmi_port_height]) {
    union() {
      
      // USB/HDMI slot
      linear_extrude(height=hdmi_port_height + 1) {
        translate([hdmi_port_offset - hdmi_port_length/2 -base_length/2, -case_width/2, -1]) { square([base_length-2*standoff_diameter, case_wall_thickness]); }
      }
      
      // Zif (Camera) connector and SD card connector slots
      linear_extrude(height=hdmi_port_height) { 
        translate([case_length/2 - case_wall_thickness, - camera_zif_width/2]) { square([case_wall_thickness, camera_zif_width]); }
        translate([-case_length/2, -base_width/2 + sd_offset - sd_width/2]) { square([case_wall_thickness, sd_width]); }
      }
    } 
  }
}

module fan_profile() {
  // Get the negative of the structure 
  difference() {
    // Base fan profile
    rounded_corner_rectangle(fan_size, fan_size, 0, fan_hole_radius, 0 );
    union() {
     difference() {
     // Base fan profile
     rounded_corner_rectangle(fan_size, fan_size, 0, fan_hole_radius, 0 );
      
      // Mounting Holes
    mounting_holes(fan_size - fan_hole_spacing_from_corner*2, fan_size - fan_hole_spacing_from_corner*2, fan_hole_radius, 0, 0);
      
      // Concentric circles for fan grill
      donut(12, 10);
      donut(8, 6);
      donut(4, 2); 
     }
   
     // Cross for extra stability
     translate([0,0,0]) {
        translate([-fan_size/2, -1]){square([fan_size, 2]);}
        translate([-1, -fan_size/2]){square([2, fan_size]);}
     }
     
   }
 }
}

// Creates a donut 
module donut(outer_radius, inner_radius) {
  difference() {
    circle(r=outer_radius, $fn=100);
    circle(r=inner_radius, $fn=100);
  }
}

// Used for making all the 2D profiles with rounded corners
module rounded_corner_rectangle(length = 0, width = 0, top_offset = 0, corner_radius = 0, corner_spacing = 0 ) {
  hull()
  {
   // top left
   translate([-length/2 + corner_radius, width/2 - corner_radius + top_offset, 0]) { donut(corner_radius, 0);}

   // bottom left
   translate([-length/2 + corner_radius, -width/2 + corner_radius, 0]) { donut(corner_radius, 0);}
   
   // top right
   translate([length/2 - corner_radius, width/2 - corner_radius + top_offset, 0]) { donut(corner_radius, 0);}
   
   // bottom right
   translate([length/2 - corner_radius, corner_radius -width/2, 0]) { donut(corner_radius, 0);}
  }
}

// Used for creating the 2D representation of a standoff set
module mounting_holes(grid_length=0, grid_width=0, standoff_radius=0, screw_radius=0, top_offset=0) {
   // top left
   translate([-grid_length/2, grid_width/2 + top_offset, 0]) { donut(standoff_radius, screw_radius);}

   // bottom left
   translate([-grid_length/2, -grid_width/2, 0]) { donut(standoff_radius, screw_radius);}
   
   // top right
   translate([grid_length/2, grid_width/2 + top_offset, 0]) { donut(standoff_radius, screw_radius);}
   
   // bottom right
   translate([grid_length/2, -grid_width/2, 0]) { donut(standoff_radius, screw_radius);}
} 


/////////////////////////////////////////////////// Prototypes /////////////////////////////////////////////////
vent_cutout();
//case_top();
//case_bottom();