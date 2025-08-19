// Magnetic Duct Mount - by Mean-UI-Thread
// This file is part of https://github.com/mean-ui-thread/3dprinting.git repo
// Licensed under the MIT License (see LICENSE file in the repo root)

// === CONSTANTS ===
spacing = 4.5;
inner_d = 97;
outer_d = 99.5;
magnet_count = 12;
magnet_d = 6.0;
magnet_h = 2.0;
thread_pitch = 2.5;
tolerance = 0.2;
$fn = 256;


// === CALCULATED CONSTANTS ===
brim_height = magnet_h + 1; // add 1mm on top of the magnets
brim_width = magnet_d + 4; // add 2mm on each side of the magnets
brim_d = outer_d + (brim_width * 2);
brim_z = (brim_height / 2);
magnet_radius = (outer_d + brim_width) /2; // Distance from center to ring of magnets
magnet_z = (magnet_h / 2);
thread_height = spacing + brim_height;
wall_thickness = (outer_d - inner_d) / 2;

assert(outer_d > inner_d, "outer_d must be greater than inner_d");

module add_brim() {
    translate([0, 0, brim_z])
    cylinder(
        d=brim_d,
        h=brim_height,
        center=true
    );
}

module carve_out_brim() {
    translate([0, 0, brim_z])
    cylinder(
        d=inner_d,
        h=brim_height + 0.01,
        center=true
    );
}

module carve_out_magnet_recesses() {
    for (i = [0 : 360/magnet_count : 359]) {
        rotate([0, 0, i])
        translate([
            magnet_radius,
            0,
            magnet_z
        ])
        cylinder(
            d=magnet_d + tolerance,
            h=magnet_h + (tolerance * 2), // add double tolerance to avoid potential nozzle collision
            center=true
        );
    }
}

