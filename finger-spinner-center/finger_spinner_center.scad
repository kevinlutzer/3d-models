/*
    Author:Kevin Lutzer
    Date: Oct 19 2016
    Description: replacement peace for a finger spinner 
*/


/////////////////////////////////////// Parameters //////////////////////////////////////////

disk_diameter = 22;
disk_thickness = 1.8;

bearing_depth = 7; 
inner_bearing_diameter = 8; 
outer_bearing_diameter = 10;
bearing_seperation = 0.5;

bevel_height = 0.3; 

screw_diameter = 2.87;
screw_head_height = 5;
screw_head_diameter = 2.87;
screw_length = 7.41;

total_thickness = disk_thickness + bearing_depth;
/////////////////////////////////////// protoypes ////////////////////////////////////////////
translate([-disk_diameter/2 - 2.5, 0, 0]){ bottom_disk(); }
translate([disk_diameter/2 + 2.5, 0, 0]){ top_disk(); }

/////////////////////////////////////// Modules /////////////////////////////////////////////

module disk_blank(){
    union(){
        cylinder(disk_thickness, d1=disk_diameter, d2=disk_diameter, $fn=100 );
        translate([0,0,disk_thickness+bearing_seperation]){
            cylinder(bearing_depth/2-bevel_height, d1=inner_bearing_diameter, d2=inner_bearing_diameter, $fn=100 );   
        }
        translate([0,0,disk_thickness+bearing_depth/2-bevel_height+bearing_seperation]){
            cylinder(bevel_height, d1=inner_bearing_diameter, d2=inner_bearing_diameter-bevel_height, $fn=100 );
        }
        translate([0,0,disk_thickness]){
                cylinder(bearing_seperation, d1=outer_bearing_diameter, d2 =outer_bearing_diameter, $fn=100 );
        }
    }
}

module top_disk(){
    difference(){
        disk_blank();
        cylinder(screw_head_height, d1 = screw_head_diameter, d2 = screw_head_diameter, $fn=100 );
        translate([0,0,0]){
            cylinder(screw_head_height, d1 = screw_head_diameter, d2 = screw_head_diameter, $fn=100);
        }
        translate([0,0,screw_head_height]){
            cylinder( screw_length, d1 = screw_diameter, d2 = screw_diameter, $fn = 100);
        }
    }
}

module bottom_disk(){
    difference(){
        disk_blank();
        translate([0,0,total_thickness - screw_length]){    
            cylinder( screw_length, d1 = screw_diameter, d2 = screw_diameter, $fn = 100);
        }
    }
}