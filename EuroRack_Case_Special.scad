/*************************************************
|                                                |
|  https://github.com/KrsByr/3d-print-eurorack   |
|  AGPL-3.0 license                              |
|                                                |
|  version 2023-07-21v1                          |
|                                                |
*************************************************/ 

include <EuroRack_Case.scad>

/*************************************************
|  Case without Connectors                |
|    z = length [mm]                             |
*************************************************/ 
module Case_WithoutConnectors(z)
{
// links (oben) ************************************************
	cube([_xWand, _caseDeep + _verbinderHigh, z]);
	
	// Rail
	translate([0, _caseDeep + _verbinderHigh, 0])
		RailHead(z, leftRim = true);
	
	// rechts (unten) ************************************************
	translate([_caseHigh - _xWand, 0, 0])
		cube([_xWand, _caseDeep + _verbinderHigh, z]);	
	
	// Rail
	translate([_caseHigh - _railWidth, _caseDeep + _verbinderHigh, 0])
		RailHead(z, rightRim = true);
		
	// unten (rückwand) ************************************************		
	translate([_xWand, 0, 0])
		cube([_caseHigh - 2 * (_xWand), _xWand, z]);	
}

/*************************************************
|  Case_PowerSupply_MeanWell_RT65                |
|    Mean Well                                   |
|    RT-65 series                                |
*************************************************/ 
module Case_PowerSupply_MeanWell_RT65()
{
	width = _caseWidthPerUnit * 26;
	//_hasHoles = true;

	difference()
	{
		Case(26);
	
		nHoles = round((width - 20) / 20 - 0.4);
		echo(nHoles);
		for (s = [1 : 1 : 2])
		{
			for (r = [1 : 1 : 5])
			{
				for (n = [1 : 1 : nHoles])
				{
					yOffset = (r > 3) ? 8 : 4;
					zOffset = (r % 2 == 0) ? 0 : 10;
					y = r * 10 + yOffset;
					z = n * 20 + zOffset;
					x = (s == 1) ? -1 : 122;

					if (!((r % 2 == 0) && (n == 1))) // die beiden nicht
						translate([x, y, z])
							rotate([0, 90, 0])
								cylinder(10, d=12, $fn=6);
				}
			}
		}
	
        // holes 
        $fn=36;
        
		for (s = [-16.5 : 33 : 16.5])
		{
			translate([_caseHigh / 2 + s, 8, 78])
				rotate([90, 0, 0])
					cylinder(10, d=3.4);

			translate([_caseHigh / 2 + s, 2, 78])
				rotate([90, 0, 0])
					cylinder(10, d=8);
		}
	}
}
