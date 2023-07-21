/*************************************************
|                                                |
|  https://github.com/KrsByr/3d-print-eurorack   |
|  AGPL-3.0 license                              |
|                                                |
|  version 2023-07-21v1                          |
|                                                |
*************************************************/ 

include <EuroRack_Case.scad>
include <EuroRack_Case_Special.scad>

/*** Rail (single) ******************************/ 
 //Rail(80, holeDiameter = 4); 

/*** Case ***************************************/
 Case(units = 15);
 //CaseEndMale();
 //CaseEndFemale();

/*** Case Special *******************************/
 //Case_PowerSupply_MeanWell_RT65();
 //Case_WithoutConnectors(42);

/*** Testing ************************************/
 //RailHead(42, leftRim = true, rightRim = false);
 //Verbinder(42);


