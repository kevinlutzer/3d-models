/*
    Author: Kevin Lutzer
    Date Created: 7th October 2016 
    
    Description: Z axis limit switch support
*/

//////////////////////////////////////// Parameters /////////////////////////////////////////

length = 45;
width = 12;
thickness = 12;

hinge_thickness = 7.87;
hinge_width = 3.175;
hinge_length = 7; 

mount_screw_seperation = 8.50;
mount_screw_width = 2.93;
mount_screw_head_width = 4.60;
mount_screw_head_height = 3;

switch_screw_width = 0.5; 
switch_screw_seperation = 8;
switch_amount = 10;


///////////////////////////////////////// Modules ///////////////////////////////////////////

//////////////////////////////////////// Prototypes /////////////////////////////////////////
difference(){    
    union()
    {
        cube([width, length, thickness], 0);
        for( i = [0 : 8 + mount_screw_seperation + hinge_length : 8 + mount_screw_seperation + hinge_length ] ){
            translate([width/2 - hinge_width/2,i,thickness]){ cube([hinge_width, hinge_length,          hinge_thickness],0); }
            translate([width/2 - hinge_width/2,i,thickness]){ cube([hinge_width, hinge_length,          hinge_thickness],0); }
        }
            
    }
        for( i = [0 : mount_screw_seperation : mount_screw_seperation] ){
            translate([width/2, hinge_length + 4 + i ,0]){
                cylinder(thickness +1, d1 = mount_screw_width, d2 =         mount_screw_width, 0, $fn=100);   
            }
            translate([width/2, hinge_length + 4 + i ,0]){
                cylinder(mount_screw_head_height, d1 = mount_screw_head_width, d2 =         mount_screw_head_width, 0, $fn=100);   
            }
        
        }
         
}