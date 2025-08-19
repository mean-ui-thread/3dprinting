// Magnetic Duct Mount - by Mean-UI-Thread
// This file is part of https://github.com/mean-ui-thread/3dprinting.git repo
// Licensed under the MIT License (see LICENSE file in the repo root)

include <../libs/BOSL2/std.scad>;
include <../libs/BOSL2/threading.scad>;

include <common.scad>;

// === PARAMETERS ===

thread_stub_z = brim_height + (thread_height / 2);

module add_threaded_stub() {
    // This module adds the threaded stub to the mount
    translate([0, 0, thread_stub_z])
    threaded_rod(
        d=outer_d + (wall_thickness * 2),
        pitch=thread_pitch,
        length=thread_height,
        internal=false
    );
}

module carve_out_threaded_stub() {
    // This module carves out the threaded stub from the mount
    translate([0, 0, thread_stub_z])
    cylinder(d=inner_d, h=thread_height + 0.01, center=true);
}

// === MODULE ===
difference() {
    union() {
        add_brim();
        add_threaded_stub();
    }
    carve_out_brim();
    carve_out_threaded_stub();
    carve_out_magnet_recesses();
}