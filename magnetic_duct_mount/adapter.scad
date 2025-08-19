// Magnetic Duct Mount - by Mean-UI-Thread
// This file is part of https://github.com/mean-ui-thread/3dprinting.git repo
// Licensed under the MIT License (see LICENSE file in the repo root)


include <../libs/BOSL2/std.scad>;
include <../libs/BOSL2/threading.scad>;

include <common.scad>;

// === PARAMETERS ===
duct_insert_height = 30; // Height of the duct insert, which is the part that will be inserted into the duct
duct_insert_z = brim_height + (duct_insert_height / 2);

module add_duct_insert() {
    // This module adds the duct insert to the adapter
    translate([0, 0, duct_insert_z])
    cylinder(
        d=outer_d,
        h=duct_insert_height,
        center=true
    );
}

module carve_out_duct_insert() {
    // This module carves out the duct insert from the adapter
    translate([0, 0, duct_insert_z])
    cylinder(
        d=inner_d,
        h=duct_insert_height + 0.01,
        center=true
    );
}

// === MODULE ===
difference() {
    union() {
        add_brim();
        add_duct_insert();
    }
    carve_out_brim();
    carve_out_duct_insert();
    carve_out_magnet_recesses();
}