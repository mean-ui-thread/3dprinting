// Magnetic Duct Mount - by Mean-UI-Thread
// This file is part of https://github.com/mean-ui-thread/3dprinting.git repo
// Licensed under the MIT License (see LICENSE file in the repo root)

include <../libs/BOSL2/std.scad>;
include <../libs/BOSL2/threading.scad>;

include <common.scad>;

// === PARAMETERS ===

thread_inner_d = outer_d + (wall_thickness*2) + (tolerance*2);
thread_outer_d = thread_inner_d + (wall_thickness*2);
thread_z = thread_height / 2;

echo(str("Required hole diameter to be drilled: ", thread_outer_d, "mm"));

module add_thread_stub() {
    // outside of the female thread
    translate([0, 0, thread_z])
    cylinder(d=thread_outer_d, h=thread_height, center=true);
}

module carve_out_thread_stub() {
    translate([0, 0, thread_z])
    threaded_rod(
        d=thread_inner_d,
        pitch=thread_pitch,
        length=thread_height + 0.01,
        internal=true
    );
}

difference() {
    union() {
        add_brim();
        add_thread_stub();
    }

    carve_out_thread_stub();
}