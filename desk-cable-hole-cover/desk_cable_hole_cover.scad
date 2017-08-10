/*
Author: Kevin Lutzer
Date Created: Oct 8 2016 
Description: A part to protect a whole in a desk meant for threading cables through.
*/

///////////////////////////////////////////////// Parameter /////////////////////////////////////////////////

wall_thickness = 3;
hole_diameter = 45; 

cover_height = 3; 
cover_thickness = 5;
hole_height = 18.5;

///////////////////////////////////////////////// Prototypes /////////////////////////////////////////////////
union()
{
    difference(){
        cylinder(hole_height + cover_height, d1 = hole_diameter, d2 = hole_diameter, 0, $fn=50 );
        cylinder(hole_height + cover_height, d1 = (hole_diameter-wall_thickness), d2 = (hole_diameter-wall_thickness), 0, $fn=50);
    }
    translate([0,0,hole_height]){
        difference(){
            cylinder(cover_height, d1 = (hole_diameter+cover_thickness), d2 = (hole_diameter), 0, $fn=50);
            cylinder(cover_height, d1 = hole_diameter, d2 = hole_diameter, 0, $fn=50);    
        }
        
    }
}
////////////////////////////////////////////////// modules //////////////////////////////////////////////////

