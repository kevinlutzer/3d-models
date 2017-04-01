/* 
Author: Kevin Lutzer
Date: February 28 2016 
Description: A part that is meant to hold a limit switch for the positive limit of the y-axis, as well as the bearing. 
Notes: All parts are centered on the positive y-axis onless otherwise specified.

*/

///////////////////////////////// Parameters //////////////////////////////////

//////////////////// Frame Dependant Dimensions 

// thickness of frame material 
thickness = 7.6;
// width of insert that goes into the frame 
frame_insert_width = 4.6;
// dimensions of the base of the part
base_height = 45;
base_width = 27;
// dimensions and position of the bearing, measured from the base of the y-axis 
bearing_displacement = 21;
bearing_hole_diam = 8.5;
// dimensions of screws and nuts used in the joints
screw_height = 9;
screw_width = 4;
nut_height = 3;
nut_width = 6;
// distance between the two frame inserts 
joint_displacement = 8.5;
// dimensions and positions of the limit switch
switch_screw_diam = 2;
switch_screw_width_displacement = 6.5;
switch_screw_height_displacement = 5;


///////////////////////////////// Prototype ////////////////////////////////////

linear_extrude(height = thickness, center = thickness/2, convexity = 10, twist = 0){
    frame();
}

///////////////////////////////// Modules /////////////////////////////////////

// the 2d module of the frame, it needs to be linearly extruded to get the final 3D model of the part
module frame(){
    difference(){
        union(){
            base();    
            translate([-joint_displacement, 0, 0]){
                frame_insert();
            }
            translate([joint_displacement, 0, 0]){
                frame_insert();
            }
        }
        screw_joint();
        translate([0, bearing_displacement, 0]){
            circle(d=bearing_hole_diam, $fn=100);
        }
        translate([0,base_height,0]){
            switch_cutout();
        }
    }
}


// a rectangle that represents the plateform that shapes will be added too, and cut from. 
module base(){
    translate([-base_width/2, 0, 0]){
        square([base_width, base_height]);
    }
}

// the small rectangle that is meant to be the 2D version of the part that inserts into the frame of the 3D printer
module frame_insert(){
    translate([-frame_insert_width/2, -thickness, 0]){
        square([frame_insert_width, thickness]);
    }
}

// the 't' shape that is meant to join the part to the printer.
module screw_joint(){
    union(){
        translate([-screw_width/2, 0]){
            square([screw_width, screw_height]);
        }
        translate([-nut_width/2, screw_height/2-nut_height/2]){
            square([nut_width, nut_height]);
        }
    }
}

// the cutout to for the screw holes to properly position the switch so that the contact is at the edge of the part.
module switch_cutout(){ 
    union(){
        translate([switch_screw_width_displacement/2,-switch_screw_height_displacement,0]){
            circle(d=switch_screw_diam, $fn=40);
        }
        translate([-switch_screw_width_displacement/2,-switch_screw_height_displacement,0]){
            circle(d=switch_screw_diam, $fn=40);
        }
    }
}