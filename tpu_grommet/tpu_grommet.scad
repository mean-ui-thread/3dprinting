// TPU Grommet Generator - by Mean-UI-Thread
// This file is part of https://github.com/mean-ui-thread/3dprinting.git repo
// Licensed under the MIT License (see LICENSE file in the repo root)

// Designed for flexible cable pass-through with customizable hole count and sizes.

// Note: Holes and slits are slightly enlarged using the 'TPU tolerance' setting to improve fit.

/* [Grommet Size Configuration] */

// Base diameter (mm)
base_diameter = 50.0; // [10:0.2:128] 

// Base height (mm)
base_height = 11; // [2:0.2:64]

// Top lip distance from base diameter to outer edge (mm)
top_lip_width = 5.0; // [0:0.2:32]

// top lip thickness (mm)
top_lip_thickness = 1.8; // [0:0.2:32]

// Bottom lip distance from base diameter to the outer edge (mm)
bottom_lip_width = 5.0;  // [0:0.2:32]

// bottom lip thickness (mm)
bottom_lip_thickness = 1.8; // [0:0.2:32]

/* [Grommet Wire Pass-Through Hole Configuration] */

// Distance ratio from center to the edge of the base
hole_position_radius_ratio = 0.4;  // [0.0:0.01:1.0] 

// Wire Pass-through hole diameter (mm)
hole_diameter_1 = 5.0; // [0:0.1:10]

// Enable/disable slit for wire pass-through hole 1
hole_enable_slit_1 = true;

// Wire Pass-through hole diameter (mm)
hole_diameter_2 = 4.0; // [0:0.1:10]

// Enable/disable slit for wire pass-through hole 2
hole_enable_slit_2 = false;

// Wire Pass-through hole diameter (mm)
hole_diameter_3 = 0.0; // [0:0.1:10]

// Enable/disable slit for wire pass-through hole 3
hole_enable_slit_3 = false;

// Wire Pass-through hole diameter (mm)
hole_diameter_4 = 0.0; // [0:0.1:10]

// Enable/disable slit for wire pass-through hole 4
hole_enable_slit_4 = false;

// Wire Pass-through hole diameter (mm)
hole_diameter_5 = 0.0; // [0:0.1:10]

// Enable/disable slit for wire pass-through hole 5
hole_enable_slit_5 = false;

// Wire Pass-through hole diameter (mm)
hole_diameter_6 = 0.0; // [0:0.1:10]

// Enable/disable slit for wire pass-through hole 6
hole_enable_slit_6 = false;

/* [Advanced Settings] */

// Width of Wire Pass-through hole slit when enabled (mm)
hole_slit_width = 0.1;            // [0.0:0.1:2] 

// TPU tolerance to slightly enlarge holes and slits for better fit (mm)
tpu_size_tolerance = 0.05;        // [0.0:0.05:1.0]

// Adjust curve resolution
$fn = 256;                   // [8:8:512]


// === MODULES ===
module grommet() {
    hole_diameter_idx=0;
    hole_slit_enabled_idx=1;
    hole_configs = [
        [hole_diameter_1, hole_enable_slit_1],
        [hole_diameter_2, hole_enable_slit_2],
        [hole_diameter_3, hole_enable_slit_3],
        [hole_diameter_4, hole_enable_slit_4],
        [hole_diameter_5, hole_enable_slit_5],
        [hole_diameter_6, hole_enable_slit_6]
    ];
    hole_config_count = len(hole_configs);
    base_radius = (base_diameter * 0.5) - tpu_size_tolerance;
    hole_position_radius = base_radius * hole_position_radius_ratio;
    top_outer_radius = base_radius + top_lip_width;
    bottom_outer_radius = base_radius + bottom_lip_width;
    total_radius = max(base_radius, top_outer_radius, bottom_outer_radius);
    total_height = base_height + top_lip_thickness + bottom_lip_thickness;
    slit_length = total_radius - hole_position_radius;
    slit_radius = total_radius - (slit_length * 0.5);
    difference() {
        union() {
            // top lip 
            translate([0, 0, 0])
            cylinder(
                h = top_lip_thickness,
                d = top_outer_radius * 2
            );
            // base
            translate([0, 0, top_lip_thickness])
            cylinder(
                h = base_height,
                d = base_radius * 2
            );
            // bottom lip
            translate([0, 0, top_lip_thickness + base_height])
            cylinder(
                h = bottom_lip_thickness,
                d = bottom_outer_radius * 2
            );
        }

        enabled_hole_configs = [for (i = [0 : hole_config_count - 1]) if (hole_configs[i][hole_diameter_idx] > 0.0) i];
        enabled_hole_configs_count = len(enabled_hole_configs);

        for (hole_config_idx = enabled_hole_configs) {
            hole_diameter = hole_configs[hole_config_idx][hole_diameter_idx];
            hole_enable_slit = hole_configs[hole_config_idx][hole_slit_enabled_idx];
            angle = 360 * hole_config_idx / enabled_hole_configs_count;
            hole_x = hole_position_radius * cos(angle);
            hole_y = hole_position_radius * sin(angle);
            hole_position_radius = hole_diameter * 0.5 + tpu_size_tolerance;
            translate([hole_x, hole_y, total_height * 0.5])
            cylinder(
                h = total_height + 2,
                d = hole_position_radius * 2.0,
                center = true
            );
            if (hole_enable_slit && hole_slit_width > 0) {
                slit_x = slit_radius * cos(angle);
                slit_y = slit_radius * sin(angle);
                translate([slit_x, slit_y, total_height * 0.5])
                rotate([0, 0, angle])
                cube([
                    slit_length,
                    hole_slit_width + (tpu_size_tolerance * 2.0),
                    total_height + 2
                ], center = true);
            }   
        }
    }
}

grommet();
