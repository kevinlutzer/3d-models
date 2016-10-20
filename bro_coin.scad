/*
    Author: Kevin Lutzer
    Date Created: Oct 22 2016
    Description: A little coin for my bro
*/

/////////////////////////////////////////////////// Parameters /////////////////////////////////////////////////

coin_diameter = 20;
coin_thickness = 2; 
text_size = 6;
text_depth = coin_thickness-1;

/////////////////////////////////////////////////// Prototypes /////////////////////////////////////////////////

coin();

/////////////////////////////////////////////////// Modules //////////////////////////////////////////////////

module coin(){
    union(){     
        translate([0,0,coin_thickness]){
            needed_text();
        }
        cylinder(coin_thickness, d1 = coin_diameter, d2 = coin_diameter, $fn=100);
    }
}

module needed_text(){
    linear_extrude(height = text_depth) {  
        text("#1", size=text_size, halign="center"); 
            translate([0,-text_size - 1,0]){
                text("B", size=text_size, halign="center");
            }
        }
}

