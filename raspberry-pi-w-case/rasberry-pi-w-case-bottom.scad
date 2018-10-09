/*
    Author: Kevin Lutzer
    Date Created: January 16 2018
    Description: The bottom for a raspberry pi W case. This file contains the meta information to be used with Makerbot/Thingiverse Customizer.
*/

/////////////////////////////////////////////////// Parameters /////////////////////////////////////////////////


/* [Case] */

//Is the side to show in the customizer viewer and make an stl file from
side_to_show = "both"; //[both:Both of the parts of the case, top: Top part of the case, bottom: bottom part of the case]
//Is the olerance of the raspberry pi width and length. This number will effect the tightness of the raspberry pi PCB in the case
base_tolerance = 1; //[0.5, 1, 1.5, 2]
//Is the diameter of the standoffs used to secure the raspberry pi to the case 
standoff_diameter = 5;
//Is the diameter of the srew hole in the standoffs that are used to secure the raspberry pi to the case
standoff_screw_diameter = 1.5;
//Is the width of the cavity added for extra space to store electronics and wires (Y axis)
case_cavity_width = 5;
//Is the thickness of the case
case_wall_thickness = 2;
//Is the height of the top portion of the case. This value represents the difference between the top face of the case and the top of the hdmi port. 
case_top_height = 30;
//Is the radius of the standoffs used to secure the two parts of the case together
case_standoff_radius = 3;
//Is the radius of the screw used to secure the two parts of the case together
case_hole_radius = 1.5;
//Is the radius of the screw used to mount the case onto some panel. 
case_mount_radius = 3;
//Is the user selected heat management for the top sidef of the case. Note that it is recommended to use atleast "Vents". If "Fan" is selected you can adjust the "Fan" parameters to match the your fan  
case_top_heat_management = "fan"; //[none:No Management, fan:Fan, vents:Vents];
//Is the amount of segments used to make the vents for the bottom and top of the case. 
vent_segment_amount = 8;
//Is to select whether or not you want the top part of the case to have vents on the same side as the usb and hdmi ports.
use_top_side_vents = true; //[true, false]
//Is to select whether or not you want the bottom part of the case to have vents underneath the spot the raspberry pi will sit
use_bottom_vents = true; //[true, false]

/* [Fan] */
// Is the size of the fan. Assuming your fan is square, it represents the length between two parallel sides. 
fan_size = 30;
// Is the X-Y offset of the mounting holes reference to the nearest sides
fan_hole_spacing_from_corner = 3;
// Is the radius of the mounting holes for the fan
fan_hole_radius = 1.8;

/* [Hidden] */

//Length of the raspberry pi
base_length = 65;
//Width of the raspberry pi
base_width = 30;
//Length of the raspberry pi accounting for tolerances
base_length_with_tolerance = base_length + base_tolerance;
//Width of the raspberry pi accounting for tolerances
base_width_with_tolerance = base_width + base_tolerance;
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
case_width = 2*case_wall_thickness + base_width_with_tolerance;
//Length of the raspberry pi (X axis)
case_length = 2*case_wall_thickness + base_length_with_tolerance;
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
//Y-Position of the center of the SD card reference to the bottom left edge
sd_offset = 16.9;
//The height of the bottom of the raspberry pi case (Z axis)
case_bottom_height = thickness + case_wall_thickness + standoff_height + hdmi_port_height;
//The width of the vents for the bottom portion of the case
vent_bottom_width = case_width - 3*standoff_diameter;
//The width of the vents for the side of the top portion of the case
vent_top_side_width = (case_top_height - 4*case_wall_thickness);
//The width of the vents for the top portion of the case
vent_top_width = (case_width - 4*case_wall_thickness);
//The total length of the vent. 
vent_length = case_length - 4*standoff_diameter;
//The segment length of the vent. This is determined based on the amount of segments specified by the user
vent_segment_length = vent_length/vent_segment_amount;


/////////////////////////////////////////////////// Modules //////////////////////////////////////////////////

// represents the profile of the raspberry pi pcb
module base_cutout() {
    rounded_corner_rectangle(base_length + base_tolerance, base_width + base_tolerance, case_cavity_width, base_corner_radius, 0 );
}

// the standoff profile used to secure the two parts of the case together
module base_corner_standoffs() {
  mounting_holes(base_length - standoff_spacing_from_corner * 2, base_width - standoff_spacing_from_corner * 2, base_corner_radius, standoff_screw_diameter/2, 0);
}

// represents the profile of the top and bottom surfaces of the case
module case_profile() {
  rounded_corner_rectangle(case_length, case_width, case_cavity_width, case_standoff_radius, 0);
}

// the profile of the case wall which is the difference between the base and case profiles
module case_wall_profile() {
  difference() {
    case_profile();
    base_cutout();
  }
}

// The extruded case wall profile
module case_wall(height) {
  linear_extrude(height=height) {
    union() {
      case_wall_profile();
      mounting_holes(case_length, case_width, case_standoff_radius, case_hole_radius, case_cavity_width);
    }
  }
}

// The profile of the tab mounts used to secure the bottom part of the case to a panel. 
module case_mounts_profile() {
  // right mount
  translate([case_length/2, - 2*case_mount_radius + case_cavity_width/2, 0]) {
    difference() {
      square([4*case_mount_radius, 4*case_mount_radius]);
      translate([2*case_mount_radius, 2*case_mount_radius]) circle(r=case_mount_radius, $fn=100);
    }
  }
  // left mount
  translate([ -case_length/2 -4*case_mount_radius, - 2*case_mount_radius + case_cavity_width/2, 0]) {
    difference() {
      square([4*case_mount_radius, 4*case_mount_radius]);
      translate([2*case_mount_radius, 2*case_mount_radius]) circle(r=case_mount_radius, $fn=100);
    }
  }
}

// The full bottom portion of the case including the cutouts for ventalation and peripherals
module case_bottom() {
  difference() {
    union() {
        // The wall withitout the bottom mounting holes
        case_wall(case_bottom_height);
        
        // Bottom of the case / The base profile
        linear_extrude(height=case_wall_thickness) {
            case_profile();
        }
        
        // Standoffs to hold the rapsberry pi from the base
        translate([0, 0, case_wall_thickness]) {
          linear_extrude(height=standoff_height) {
            base_corner_standoffs();
          }
        }
    }
    
    // Peripherals and other cutouts. 
    peripherals_case_bottom_cutout();
    vent_cutout(vent_bottom_width);
  }
}

// The full top portion of the case including the cutouts for ventalation and peripherals
module case_top() {
  difference() {
    //The frame of the top portion of the case including the standoffs
    union() {
      linear_extrude(height=case_wall_thickness){
        case_profile();
      }
      case_wall(case_top_height);
    }

    //Vent cutout if the user has selected it
    if (case_top_heat_management == "vents") {
      // center vent in center of the case accounting for the cavity width
      translate([0,case_cavity_width/2,0]){vent_cutout(vent_top_width);}
    }

    //Fan cutout if the user has selected it
    if (case_top_heat_management == "fan") {
      // center fant in center of the case accounting for the cavity width
      translate([0,case_cavity_width/2,0]){fan_cutout();}
    }

    //Have side vent cutouts by default if they can fit
    if (vent_top_side_width > case_wall_thickness*8) {
      translate([0,-base_width_with_tolerance/2, (case_top_height + case_wall_thickness)/2]){rotate([90,0,0]){vent_cutout(vent_top_side_width);}}
    }
  }
}

// The profile of an individual vent segment used for air flow in the case
module vent_segment_profie(width = 0) {
  translate([0,width/2,0]){circle(d=vent_segment_length/2, $fn=100);}
  translate([-vent_segment_length/4,-width/2,0]){square([vent_segment_length/2,width]);}
  translate([0,-width/2,0]){circle(d=vent_segment_length/2, $fn=100);}
}

// The base vent cutout. The length will always be constant, but the width can be passed in to adjust sizing for the portions of the case this vent cutout will be used on 
module vent_cutout(width = 0) {
    linear_extrude(height=case_wall_thickness) {
    for(i = [0:vent_segment_amount-1]) {
      translate([i*vent_segment_length - vent_length/2 + vent_segment_length/2, 0, 0]) {
        vent_segment_profie(width);
      }
    }
  }
}

// cutout for the usb, hdmi, camera, sd card slots
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

// extruded fan profile used for the fan cutout on the top of the case
module fan_cutout() {
    linear_extrude(height=case_wall_thickness) {
        fan_profile();
    }
}

// simple fan profile 
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

// Used for creating the 2D representation of a 4x4 standoff set
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

if (side_to_show == "both") {
  translate([0,case_width/2 + case_cavity_width + case_standoff_radius*4, 0]){case_top();}
  translate([0,-case_width/2, 0]){case_bottom();}
}

if (side_to_show == "top") {
  case_top();
}

if (side_to_show == "bottom") {
  case_bottom();
}