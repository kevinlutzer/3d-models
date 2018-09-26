/*
    Author: Kevin Lutzer
    Date Created: January 16 2018
    Description: The bottom for a raspberry pi W case
*/

/////////////////////////////////////////////////// Parameters /////////////////////////////////////////////////


base_length = 65;
base_width = 31;
base_corner_radius = 3;
standoff_diameter = 6;
standoff_screw_diameter = 0.75;
standoff_height = 3;
standoff_spacing_from_corner = 3.5;
thickness = 1.5;

hdmi_port_length = 11.5;
hdmi_port_height = 3.5;
hdmi_port_offset = 12.4;

usb_port_1_offset = 41.4;
usb_port_2_offset = 54;
usb_port_length = 8;
usb_port_height = 3;

camera_zif_width = 20;
camera_zif_length = 2;
camera_zif_height = 2;

sd_width = 12;
sd_height = 1.5;

fan_size = 30;
fan_hole_spacing_from_corner = 3;
fan_hole_radius = 1.8;
fan_cutout_vent_offset = (usb_port_1_offset - hdmi_port_offset) /2 + hdmi_port_offset;

case_cavity_length = 25;
case_wall_thickness = 3;
case_bottom_height = thickness + case_wall_thickness + standoff_height + hdmi_port_height;
case_top_height = 35;
case_width = 2*case_wall_thickness + base_width;
case_length = 2*case_wall_thickness + base_length + case_cavity_length;
case_length = 2*case_wall_thickness + base_length;
case_standoff_radius = 5;
case_hole_radius = 1.5;
case_mount_radius = 3;


/////////////////////////////////////////////////// Modules //////////////////////////////////////////////////

module base_cutout() {
    rounded_corner_rectangle(base_length, base_width, case_cavity_length, base_corner_radius, 0 );
}

module base_corner_standoffs() {
  mounting_holes(base_length - standoff_spacing_from_corner * 2, base_width - standoff_spacing_from_corner * 2, base_corner_radius, standoff_screw_diameter/2, 0);
}

module case_profile() {
  rounded_corner_rectangle(case_length, case_width, case_cavity_length, case_standoff_radius, 0);
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
      mounting_holes(case_length, case_width, case_standoff_radius, case_hole_radius, case_cavity_length);
    }
  }
}

module case_mount_profile() {
  translate([case_length/2, - 2*case_mount_radius, 0]) {
    difference() {
      square([4*case_mount_radius, 4*case_mount_radius]);
      translate([2*case_mount_radius, 2*case_mount_radius]) circle(r=case_mount_radius, $fn=100);
    }
  }
  
  translate([ -case_length/2 - case_cavity_length-4*case_mount_radius, - 2*case_mount_radius, 0]) {
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
          union() {
            case_profile();
            case_mount_profile();
          }
        }
        
        // Standoffs to hold the rapsberry pi from the base
        translate([0, 0, case_wall_thickness]) {
          linear_extrude(height=standoff_height) {
            base_corner_standoffs();
          }
        }
    }
    
    // Remove the htmi port, usb ports etc. 
    peripherals_case_bottom_cutout();
  }
}

module case_top() {
  union() {
    // The wall of the case 
    case_wall(case_top_height);
    peripherals_case_top_cutout();
    linear_extrude(height=case_wall_thickness) {
      difference() {
          case_profile();
          translate([base_length/2 - fan_size/2, 0, 0]){fan_profile();}
      }
    }
  }
}

module case_bottom_base() {
    linear_extrude(height=case_wall_thickness) {
      base_cutout();
    }
}

module peripherals_case_bottom_cutout() {
  translate([-base_length/2, -case_width/2, case_bottom_height - hdmi_port_height]) {
    linear_extrude(height=hdmi_port_height) {
      union() {
        translate([hdmi_port_offset - hdmi_port_length/2, 0, 0]) { square([hdmi_port_length, case_wall_thickness]); }
        translate([usb_port_1_offset - usb_port_length/2, 0, 0]) { square([usb_port_length, case_wall_thickness]); }
        translate([usb_port_2_offset - usb_port_length/2, 0, 0]) { square([usb_port_length, case_wall_thickness]); }
        translate([case_length - case_wall_thickness, case_width/2 - camera_zif_width/2]) { square([case_wall_thickness, camera_zif_width]); }
        translate([0, case_width/2 - sd_width/2]) { square([case_wall_thickness, sd_width]); }
        translate([fan_cutout_vent_offset - 8, 0, 0]) { 
          for(i = [0:5]) {
            translate([i*3, 0, 0]) {square([1.5, case_wall_thickness]);}
            
          }
        }
      }
    }
  }
}

module peripherals_case_top_cutout() {
  translate([-case_length/2, 0, case_top_height]) {
    union(){
      linear_extrude(height=usb_port_height) {
        union() {
          translate([usb_port_1_offset - usb_port_length/2, case_width/2 - case_wall_thickness, 0]) { square([usb_port_length, case_wall_thickness]); }
          translate([usb_port_2_offset - usb_port_length/2, case_width/2 - case_wall_thickness, 0]) { square([usb_port_length, case_wall_thickness]); }
        }
      }
      
      linear_extrude(height=camera_zif_height) {
          translate([case_length - case_wall_thickness, - camera_zif_width/2]) { square([case_wall_thickness, camera_zif_width]); }
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

//translate([0, 50, 0]){
case_bottom();
//}
//case_top();

