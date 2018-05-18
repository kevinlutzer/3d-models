/*
    Author: Kevin Lutzer
    Date Created: January 16 2018
    Description: The bottom for a raspberry pi W case
*/

/////////////////////////////////////////////////// Parameters /////////////////////////////////////////////////

case_thickness = 4;
rpi_width = 70;
rpi_length = 25;

case_width = 2*case_thickness + rpi_width;
case_length = 2*case_thickness + rpi_length;

standoff_height = 5;
standoff_width = 5;

board_height = 2;

hmdi_connector_height = 4; // the max clearence needed

/////////////////////////////////////////////////// Prototypes /////////////////////////////////////////////////

case_bottom();

/////////////////////////////////////////////////// Modules //////////////////////////////////////////////////

module case_bottom(){
    needed_text();
}

module needed_text(){
    linear_extrude(height = case_thickness) {  
        square([rpi_width, rpi_length]);
    }
    linear_extrude(height = 100) { 
        square([case_width, case_length]);
    }
    linear_extrude() {
        cylinder(standoff_height, d=4, $fn=100);
    }
}

module stand_off(){
    cylinder(standoff_height, d=standoff_width, $fn=100);
}