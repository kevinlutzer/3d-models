/* 
Author: Kevin Lutzer
Date: February 28 2016 
*/

///////////////////////////////// Parameters //////////////////////////////////

thickness = 8;
base_height = 45;
base_width = 27;
bearing_displacement = 21.5;
bearing_hole_diam = 8.5;
screw_height = 9;
screw_width = 4;
frame_insert_width = 5;
nut_height = 3;
nut_width = 6;
joint_displacement = 8.5;
switch_screw_diam = 2;
switch_screw_width_displacement = 6.5;
switch_screw_height_displacement = 5;


///////////////////////////////// Prototype ////////////////////////////////////

linear_extrude(height = thickness, center = thickness/2, convexity = 10, twist = 0){
    frame();
}

///////////////////////////////// Modules /////////////////////////////////////

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

module base(){
    translate([-base_width/2, 0, 0]){
        square([base_width, base_height]);
    }
}

module frame_insert(){
    translate([-frame_insert_width/2, -thickness, 0]){
        square([frame_insert_width, thickness]);
    }
}

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