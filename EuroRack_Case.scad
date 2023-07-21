/*************************************************
|                                                |
|  https://github.com/KrsByr/3d-print-eurorack   |
|  AGPL-3.0 license                              |
|                                                |
|  version 2023-07-21v1                          |
|                                                |
*************************************************/ 

_caseHigh = 128.5 + 3;
_caseWidthPerUnit = 5.08; // * Units | Einheiten
_caseDeep = 40;
_railWidth = 9.5;
_xWand = 4;
_verbinderHigh = 25;

/*************************************************
|  RailHead                                      |
|    z = length [mm]                             |
|    leftRim = rim on left side                  |
|    rightRim = rim on right side                |
*************************************************/ 
module RailHead(z = 10, leftRim = false, rightRim = false)
{
	difference()
	{
		cube([_railWidth, 7.5, z]);	
		
		translate([2, 3.9, -1])
			cube([5.5, 2.2, z+2]);	

		translate([3, 2, -1])
			cube([3.5, 5.5+1, z+2]);	
	}
	
	if (leftRim)
		cube([1, _railWidth, z]);	
	
	if (rightRim)
		translate([_railWidth - 1, 0, 0])
			cube([1, _railWidth, z]);	
}	

/*************************************************
|  Rail (single)                                 |
|    z = length [mm]                             |
|    rim = rim on montage side                   |
|    holeDiameter = diameter for montage hole    |
*************************************************/ 
module Rail(z = 10, rim = true, holeDiameter = 5)
{
    difference()
    {
        union()
        {
            RailHead(z, leftRim = rim);
            
            translate([0, -10, 0])
                cube([2, 10, z]);	
        }       
       
      // holes  
        $fn = 36;

        translate([-1, -5, 10])
            rotate([0, 90, 0])
                cylinder(4, d = holeDiameter);
        
        translate([-1, -5, z - 10])
            rotate([0, 90, 0])
                cylinder(4, d = holeDiameter);
    }
}

/*************************************************
|  Verbinder aka. Connector                      |
|    z = length [mm]                             |
*************************************************/ 
module Verbinder(z = 42)
{
	y = _verbinderHigh;
	difference()
	{
		union()
		{
			// Rahmen 
			cube([4, y, z]);	
			
			cube([8, 4, y]);
			translate([0, 21, 0])	
				cube([8, 4, y]);	
			
			translate([4, 0, 20])
				cube([4, y, z - 20]);	
			
			translate([4, 4.2, z])
				cube([4, _verbinderHigh-8.4, 20 - 1]);	
		}
        
        // holes  
        $fn = 36;
		
		translate([-1, y/2, 10])
			rotate([0, 90, 0])
			{
				cylinder(3, d=8);
				cylinder(6, d=3.5);
			}
		
		translate([6, y/2 - 3, z + 7])
			cube([3, 6, 6]);
			
		translate([1, y/2, z + 10])
			rotate([0, 90, 0])
				cylinder(6, d=3.5);
	}
}

/*************************************************
|  Case                                          |
|    units = CaseUnits [1 Unit = 5.08 mm]        |
*************************************************/ 
module Case(units = 10)
{
    // length
    z = units * _caseWidthPerUnit;
    
	// links (oben) ************************************************
	cube([_xWand, _caseDeep, z]);
	
	// verbinder
	translate([0, _caseDeep, 0])
		Verbinder(z);
	
	// Rail
	translate([0, _caseDeep + _verbinderHigh, 0])
		RailHead(z, leftRim = true);
	
	// rechts (unten) ************************************************
	translate([_caseHigh - _xWand, 0, 0])
		cube([_xWand, _caseDeep, z]);	
	
	// verbinder
	translate([_caseHigh, _caseDeep + _verbinderHigh, 0])
		rotate([0, 0, 180])
			Verbinder(z);
	
	// Rail
	translate([_caseHigh - _railWidth, _caseDeep + _verbinderHigh, 0])
			RailHead(z, rightRim = true);
			
		
	// unten (rückwand) ************************************************		
	// verbinder
	translate([_verbinderHigh + _xWand, 0, 0])
		rotate([0, 0, 90])
			Verbinder(z);
			
	// verbinder
	translate([_caseHigh - _xWand, 0, 0])
		rotate([0, 0, 90])
			Verbinder(z);
	
	translate([_xWand + _verbinderHigh, 0, 0])
		cube([_caseHigh - 2 * (_verbinderHigh + _xWand), _xWand, z]);	
	
}

/*************************************************
|  CaseEndFemale                                 |
|    2-TE (mit Stecker)                          |
*************************************************/ 
module CaseEndMale()
{
    units = 6;
	caseY = _caseDeep + _verbinderHigh + _railWidth;
	z = _caseWidthPerUnit * units;
	z2 = _caseWidthPerUnit * 4;

    // right position
    translate([0, 0, -z2+5])
    {
        difference()
        {
            union()
            {
                difference()
                {
                    Case(units);
                    
                    translate([-1,-1,-1])
                        cube([200, 200, z2]);
                }


                translate([0, 0, z2 - 5])
                    cube([_caseHigh, caseY, 5]);
            }
        
        // screw hold (16 oben 7 seite)
           translate([7, caseY - 16, 0])
                cylinder(28, d=3.5);
           
            translate([3.5, caseY - 19, z2])
                cube([6, 6, 3]);
              
            translate([_caseHigh - 7, caseY - 16, 0])
                cylinder(28, d=3.5);
            
            translate([_caseHigh - 9.5, caseY - 19, z2])
                cube([6, 6, 3]);
        }
    }
}

/*************************************************
|  CaseEndFemale                                 |
|    6-TE (mit Buchse)                           |
*************************************************/ 
module CaseEndFemale()
{
    units = 6;
	caseY = _caseDeep + _verbinderHigh + _railWidth;
	z = _caseWidthPerUnit * units;
	z2 = z - _caseWidthPerUnit;

    // right position
    translate([_caseHigh, 0, z])
      rotate([0, 180, 00])
      {
        difference()
        {
            union()
            {
                difference()
                {
                    Case(units);
                    
                    translate([-1,-1, z2 ])
                        cube([200, 200, 50]);
                }

                translate([0, 0, z2])
                    cube([_caseHigh, caseY, 5]);
            }
        
        // screw hold (16 oben 7 seite)
            translate([7, caseY - 16, 0])
                cylinder(z, d=3.5);
            
            translate([3.5, caseY - 19, z2-3])
                cube([6, 6, 3]);
            
            translate([_caseHigh - 7, caseY - 16, 0])
                cylinder(z, d=3.5);
            
            translate([_caseHigh - 9.5, caseY - 19, z2 - 3])
                cube([6, 6, 3]);
        }
      }
}







