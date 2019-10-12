/*
    Author: Kevin Lutzer
    Date Created: January 16 2018
    Description: A raspberry pi zero case. This file contains the meta information to be used with Makerbot/Thingiverse Customizer. ALL MEASUREMENTS ARE IN MILIMETERS
*/

/////////////////////////////////////////////////// Parameters /////////////////////////////////////////////////


/* [Case] */
//Is to select whether or not you want the top part of the case to have a cutout for header. It is recommend to not select this if you plan on using a fan mount 
use_header = true; // [true, false] 
//Is to select whether or not you want the top part of the case to have vents on the same side as the usb and hdmi ports.
use_top_side_vents = true; //[true, false]
//Is to select whether or not you want the bottom part of the case to have vents underneath the spot the raspberry pi will sit
use_bottom_vents = true; //[true, false]
//Is to slect whether or not you want some panel mounting tabs on the bottom portion of the case
use_panel_mounts = true; //[true, false]
//Is the side to show in the customizer viewer and make an stl file from
side_to_show = "both"; //[both:Both of the parts of the case, top: Top part of the case, bottom: bottom part of the case]
//Is the user selected heat management for the top sidef of the case. Note that it is recommended to use atleast "Vents". If "Fan" is selected you can adjust the "Fan" parameters to match the your fan  
case_top_heat_management = "vents"; //[none:No Management, fan:Fan, vents:Vents];
//Is the tolerance of the raspberry pi pcb width and length. This number will effect the tightness of the raspberry pi pcb in the case
pcb_tolerance = 1; //[0, 0.5, 1, 1.5, 2]
//Is the tolerance of the header width and length
header_tolerance = 1; //[0, 0.5, 1, 1.5, 2]
//Is the diameter of the standoffs used to secure the raspberry pi to the case 
standoff_diameter = 5;
//Is the diameter of the srew hole in the standoffs that are used to secure the raspberry pi to the case
standoff_screw_diameter = 1.5;
//Is the width of the cavity added for extra space to store electronics and wires. It effects the total width of the case. This cavity is added to the header side of the case.
case_cavity_width = 0;
//Is the thickness of the walls of the case. This value is used for both the top and bottom parts of the case.
case_wall_thickness = 2;
//Is the height of the top portion of the case. This value represents the internal height of the top portion of the case. For example, if you want to add a perma proto hat from adafruit to your raspberry pi project set this number to 20 and you will have enough room for it in your case! If you want a minimalist case you could set this value to zero to have a flat top. 
case_top_height = 30;
//Is the radius of the standoffs used to secure the two parts of the case together
case_standoff_radius = 3;
//Is the radius of the screw used to secure the two parts of the case together
case_hole_radius = 1.5;
//Is the radius of the screw used to mount the case onto some panel. 
case_mount_radius = 3;
//Is the amount of segments used to make the vents for the bottom and top of the case. 
vent_segment_amount = 8;


/* [Fan] */
// Is the size of the fan. Assuming your fan is square, it represents the length between two parallel sides. 
fan_size = 30;
// Is the X-Y offset of the mounting holes reference to the nearest sides
fan_hole_spacing_from_corner = 3;
// Is the radius of the mounting holes for the fan
fan_hole_radius = 1.8;

/* [Hidden] */

//Length of the raspberry pi
pcb_length = 65;
//Width of the raspberry pi
pcb_width = 30;
//Length of the raspberry pi accounting for tolerances
pcb_length_with_tolerance = pcb_length + pcb_tolerance;
//Width of the raspberry pi accounting for tolerances
pcb_width_with_tolerance = pcb_width + pcb_tolerance;
//Radius of the four corners of the raspberry pi pcb
pcb_corner_radius = 3;
//Thickness of the raspberry pi pcb
thickness = 1.5;
//Height of the standoffs used to secure the raspberry pi to the case
standoff_height = 3;
//X-Y position of the center of the standoffs to the sides of the raspberry pi pcb
standoff_spacing_from_corner = 3.5;
//Diameter of the standoffs used to support the raspberry pi from the case
standoff_diameter = 6;
//Width of the raspiberry pi (Y axis)
case_width = 2*case_wall_thickness + pcb_width_with_tolerance;
//Length of the raspberry pi (X axis)
case_length = 2*case_wall_thickness + pcb_length_with_tolerance;
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
//Length of the usb ports
usb_port_length = 8;
//Width of the raspberry pi camera connector
camera_zif_width = 20;
//Width of the sd card
sd_width = 12;
//Y-Position of the center of the SD card reference to the bottom left edge
sd_offset = 16.9;
//Y Dimension of the header
header_width = 5;
//X Dimension of the header
header_length = 51;
//Y position of the center of the header from the top side of the PCB
header_width_offset = 3.5;
//X position of the center of the header
header_length_offset = 29;
//Length of the header accounting for tolerances
header_length_with_tolerance = header_length + header_tolerance;
//Width of the header accounting for tolerances
header_width_with_tolerance = header_width + header_tolerance;
header_spacing = header_width_with_tolerance/2 - header_width_offset; 
//The height of the bottom of the raspberry pi case (Z axis)
case_bottom_height = thickness + case_wall_thickness + standoff_height + hdmi_port_height;
//The width of the vents for the bottom portion of the case
vent_bottom_width = case_width - 3*standoff_diameter;
//The width of the vents for the side of the top portion of the case
vent_top_side_width = (case_top_height - 4*case_wall_thickness);
//The width of the vents for the top portion of the case
vent_top_width = (case_width - 4*case_wall_thickness);
//The width of the vents for the top portion of the case assuming a spot for the header will be cutout as well. 
vent_top_width_for_header = vent_top_width + 10*header_spacing - header_width_with_tolerance;
//The total length of the vent. 
vent_length = case_length - 4*standoff_diameter;
//The segment length of the vent. This is determined based on the amount of segments specified by the user
vent_segment_length = vent_length/vent_segment_amount;


/////////////////////////////////////////////////// Modules //////////////////////////////////////////////////

// represents the profile of the top and bottom surfaces of the case
module case_profile() {
  rounded_corner_rectangle(case_length, case_width, case_cavity_width, case_standoff_radius, 0);
}

// the profile of the case wall which is the difference between the base and case profiles
module case_wall_profile() {
  difference() {
    case_profile();
    // represents the profile of the raspbery pi pcb
    rounded_corner_rectangle(pcb_length + pcb_tolerance, pcb_width_with_tolerance, case_cavity_width, pcb_corner_radius, 0 );
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
