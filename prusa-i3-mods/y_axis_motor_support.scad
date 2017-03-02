/* 
Author: Kevin Lutzer
Date: February 28 2016 
*/

///////////////////////////////// Parameters //////////////////////////////////

thickness = 7.6;
motor_base_height = 45;
motor_base_width = 40; 
attachment_base_width = 60;
attachment_base_height = 18;
motor_shaft_hole_diam = 23.5;
motor_hole_diam = 3.5;
motor_hole_space = 31;
frame_insert_width = 4.6;
screw_height = 9;
screw_width = 4;
nut_height = 3;
nut_width = 6;
joint_displacement = 4.5;
switch_base_width = 15;
switch_base_height = 10;
switch_screw_diam = 2;
switch_screw_width_displacement = 6.5;
switch_screw_height_displacement = 5;

///////////////////////////////// Prototype ////////////////////////////////////


linear_extrude(height = thickness, center = thickness/2, convexity = 10, twist = 0){
    frame();
}

        
///////////////////////////////// Modules /////////////////////////////////////

module base(){
    union(){
        translate([-motor_base_width/2,0,0]){
            square([motor_base_width, motor_base_height]);
        }
        translate([-attachment_base_width/2,0,0]){
            square([attachment_base_width, attachment_base_height]);
        }
    }
}

module hole_cutout(){
    union(){
        translate([motor_hole_space/2, motor_hole_space/2, 0]){
            circle(d=motor_hole_diam, $fn=40);
        }
        translate([motor_hole_space/2, -motor_hole_space/2, 0]){
            circle(d=motor_hole_diam, $fn=40);
        }
        translate([-motor_hole_space/2, motor_hole_space/2, 0]){
            circle(d=motor_hole_diam, $fn=40);
        }
        translate([-motor_hole_space/2, -motor_hole_space/2, 0]){
            circle(d=motor_hole_diam, $fn=40);
        }
        circle(d=motor_shaft_hole_diam, $fn=40);
    }
}

module frame(){
    union(){
        difference(){
            base();
            translate([0,motor_base_height/2,0]){
                hole_cutout();
            }
            translate([-motor_base_width/2 - joint_displacement,0,0]){
                screw_joint();
            }
            translate([motor_base_width/2 + joint_displacement,0,0]){
                screw_joint();
            }
        }
        translate([0,0,0]){
            frame_insert();
        }
        translate([-motor_hole_space/2,0,0]){
            frame_insert();
        }
        translate([motor_hole_space/2,0,0]){
            frame_insert();
        }
        translate([0,motor_base_height,0]){
            switch_holder();
        }
        translate([-motor_base_width/2+switch_base_width/2, motor_base_height+switch_base_height,0]){
            switch_holder();
        }
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
        translate([]){
            
        }
    }
}

module switch_holder(){
    difference(){
        translate([-switch_base_width/2,-switch_base_height,0]){
            square([switch_base_width,switch_base_height]);
        }
        switch_cutout();
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
