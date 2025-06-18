// Patrick Star Shear Pin Generator - by Mean-UI-Thread
// This file is part of https://github.com/mean-ui-thread/3dprinting.git repo
// Licensed under the MIT License (see LICENSE file in the repo root)


/* [Shear Pin Size Configuration] */

// Base width (mm)
base_width = 3.5; // [0:0.1:32] 

// Base height (mm)
base_height = 3.5; // [0:0.1:32] 

// Base Length (mm)
base_length = 20.0; // [0:0.1:64]


// Adjust curve resolution
$fn = 256;                   // [8:8:512]


// === MODULES ===
module shear_pin() {

    half_base_width = base_width * 0.5;

    cylinder_diameter = base_width;
    cylinder_height = base_height;

    cylinder_x = base_height * 0.5;
    cylinder_y = base_length - half_base_width;
    cylinder_z = 0;



    difference() {
        union() {
            translate([0, 0, 0])
              cube([
                    base_width,
                    cylinder_y,
                    base_height
                ], center = false);
            translate([cylinder_x, cylinder_y, cylinder_z])
            cylinder(
                h = cylinder_height,
                d = cylinder_diameter,
                center = false
            );
        }
    }
}

shear_pin();