// TPU Grommet Generator - by Mean-UI-Thread
// Designed for flexible cable pass-through with customizable hole count and sizes.

// Note: Holes and slits are slightly enlarged using the 'TPU tolerance' setting to improve fit.

// === USER SETTINGS ===
diameter = 50.0;            // [10:0.2:128] Inner diameter (mm)
height = 10.6;               // [2:0.2:128] Total height (mm)
top_lip_width = 5.0;        // [1:0.2:128] Top lip distance from inner diameter to the edge (mm)
top_lip_thickness = 1.8;    // [1:0.2:128] Top lip thickness (mm)
bottom_lip_width = 5.0;     // [1:0.2:128] Bottom lip distance from inner diameter to the edge (mm)
bottom_lip_thickness = 1.8; // [1:0.2:128] bottom lip height (mm)
hole_diameter_1 = 5.0;      // [1:0.2:10] Wire Pass-through hole diameter (mm)
hole_diameter_2 = 4.0;      // [1:0.2:10] Wire Pass-through hole diameter (mm)
hole_diameter_3 = 4.0;      // [1:0.2:10] Wire Pass-through hole diameter (mm)
hole_diameter_4 = 4.0;      // [1:0.2:10] Wire Pass-through hole diameter (mm)
hole_diameter_5 = 4.0;      // [1:0.2:10] Wire Pass-through hole diameter (mm)
hole_diameter_6 = 4.0;      // [1:0.2:10] Wire Pass-through hole diameter (mm)


// === ADVANCED SETTINGS ===
hole_count = 3;              // [0:6] Number of wire holes
hole_radius_ratio = 0.20;    // [0.1:0.01:0.45] Distance from center as fraction of inner diameter
include_slit = true;         // true/false Include a slit for each wire holes
slit_width = 0.1;            // [0.0:0.1:2] Width of wire hole slit (mm)
tpu_tolerance = 0.05;        // [0.0:0.05:1.0] TPU tolerance
$fn = 256;                   // [8:8:512] Adjust curve resolution


// === MODULES ===
module grommet() {
    hole_diameters = [
        hole_diameter_1,
        hole_diameter_2,
        hole_diameter_3,
        hole_diameter_4,
        hole_diameter_5,
        hole_diameter_6
    ];
    hole_position_radius = diameter * hole_radius_ratio;
    inner_radius = (diameter * 0.5) - tpu_tolerance;
    top_outter_radius = inner_radius + top_lip_width;
    bottom_outter_radius = inner_radius + bottom_lip_width;
    total_radius = max(inner_radius, top_outter_radius, bottom_outter_radius);
    total_height = height + top_lip_thickness + bottom_lip_thickness;
    slit_length = total_radius - hole_position_radius;
    slit_radius = total_radius - (slit_length * 0.5);
    difference() {
        union() {
            // top lip 
            translate([0, 0, 0])
            cylinder(
                h = top_lip_thickness,
                d = top_outter_radius * 2
            );
            // base
            translate([0, 0, top_lip_thickness])
            cylinder(
                h = height,
                d = inner_radius * 2
            );
            // bottom lip
            translate([0, 0, top_lip_thickness + height])
            cylinder(
                h = bottom_lip_thickness,
                d = bottom_outter_radius * 2
            );
        }
        for (i = [0 : hole_count - 1]) {
            angle = 360 * i / hole_count;
            hole_x = hole_position_radius * cos(angle);
            hole_y = hole_position_radius * sin(angle);
            hole_diameter = hole_diameters[min(i, len(hole_diameters) - 1)];
            if (hole_diameter > 0.0) {
                hole_position_radius = hole_diameter * 0.5 + tpu_tolerance;
                translate([hole_x, hole_y, total_height * 0.5])
                cylinder(
                    h = total_height + 2,
                    d = hole_position_radius * 2.0,
                    center = true
                );
                if (include_slit && slit_width > 0) {
                    slit_x = slit_radius * cos(angle);
                    slit_y = slit_radius * sin(angle);
                    translate([slit_x, slit_y, total_height * 0.5])
                    rotate([0, 0, angle])
                    cube([
                        slit_length,
                        slit_width + (tpu_tolerance * 2.0),
                        total_height + 2
                    ], center = true);
                }   
            }
        }
    }
}

grommet();
