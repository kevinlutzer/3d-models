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

// Fan Peripherals
fan_size = 30;
fan_hole_spacing_from_corner = 3;
fan_hole_radius = 1.8;


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
rpi_case_top_height = 35;
rpi_case_width = 2*rpi_case_wall_thickness + rpi_base_width;
rpi_case_length = 2*rpi_case_wall_thickness + rpi_base_length + cavity_length;
rpi_case_length = 2*rpi_case_wall_thickness + rpi_base_length;
rpi_case_standoff_radius = 5;
rpi_case_hole_radius = 1.5;
rpi_mount_radius = 3;


/////////////////////////////////////////////////// Modules //////////////////////////////////////////////////

module rpi_base_cutout() {
    rounded_corner_rectangle(rpi_base_length, rpi_base_width, cavity_length, rpi_base_corner_radius, 0 );
}

module rpi_case_corner_standoffs(height) {
  linear_extrude(height=height){
    mounting_holes(rpi_case_length, rpi_case_width, rpi_case_standoff_radius, rpi_case_hole_radius, cavity_length);
  }
}

module rpi_base_corner_standoffs() {
  mounting_holes(rpi_base_length - rpi_standoff_spacing_from_corner * 2, rpi_base_width - rpi_standoff_spacing_from_corner * 2, rpi_base_corner_radius, rpi_standoff_screw_diameter/2, 0);
}

module rpi_case_profile() {
  rounded_corner_rectangle(rpi_case_length, rpi_case_width, cavity_length, rpi_case_standoff_radius, 0);
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
      rpi_case_corner_standoffs(rpi_case_top_height);
      linear_extrude(height=rpi_case_top_height) {
            difference() {
                rpi_case_profile();
                rpi_base_cutout();
            }
          }
        
      linear_extrude(height=rpi_case_wall_thickness) {
        difference() {
            rpi_case_profile();
            translate([rpi_base_length/2 - fan_size/2, 0, 0]){fan_profile();}
        }
        
      }
    }
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
      disk(12, 10);
      disk(8, 6);
      disk(4, 2); 
     }
   
     // Cross for extra stability
     translate([0,0,0]) {
        translate([-fan_size/2, -1]){square([fan_size, 2]);}
        translate([-1, -fan_size/2]){square([2, fan_size]);}
     }
     
   }
 }
}

module disk(outer_radius, inner_radius) {
  difference() {
    circle(r=outer_radius, $fn=100);
    circle(r=inner_radius, $fn=100);
  }
}

module rounded_corner_rectangle(length = 0, width = 0, left_offset = 0, corner_radius = 0, corner_spacing = 0 ) {
  hull()
  {
   // top left
   translate([-length/2 - left_offset + corner_radius, width/2 - corner_radius, 0]) { disk(corner_radius, 0);}

   // bottom left
   translate([-length/2 - left_offset + corner_radius, -width/2 + corner_radius, 0]) { disk(corner_radius, 0);}
   
   // top right
   translate([length/2 - corner_radius, width/2 - corner_radius, 0]) { disk(corner_radius, 0);}
   
   // bottom right
   translate([length/2 - corner_radius, corner_radius -width/2, 0]) { disk(corner_radius, 0);}
  }
}

module mounting_holes(grid_length=0, grid_width=0, standoff_radius=0, screw_radius=0, left_offset=0) {
   // top left
   translate([-grid_length/2 - left_offset, grid_width/2, 0]) { disk(standoff_radius, screw_radius);}

   // bottom left
   translate([-grid_length/2 - left_offset, -grid_width/2, 0]) { disk(standoff_radius, screw_radius);}
   
   // top right
   translate([grid_length/2, grid_width/2, 0]) { disk(standoff_radius, screw_radius);}
   
   // bottom right
   translate([grid_length/2, -grid_width/2, 0]) { disk(standoff_radius, screw_radius);}
} 


/////////////////////////////////////////////////// Prototypes /////////////////////////////////////////////////

translate([0, 50, 0]){
  rpi_case_top();
}

rpi_case_bottom();

//rpi_base_cutout()
//rpi_base_corner_standoffs();
//rpi_case_profile();
//rpi_base_cutout();
//rpi_case_profile();
//rpi_base_cutout();


//rpi_base_cutout();
//rpi_case_bottom_base();

//rpi_case_mounts();
//rpi_base_corner_standoffs();
//rpi_case_corner_standoffs(rpi_case_bottom_height);

//rpi_case_profile();
