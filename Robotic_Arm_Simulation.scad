
$fn = 48;

// 6-DOF ROBOT ARM WITH JOINT-DRIVEN PICK AND PLACE
// View > Animate: FPS 20, Steps 100

L1 = 48;
L2 = 38;
BASE_Z = 33;
TOOL_OFFSET = 32;

t = $t;

function clamp(x,a,b) = min(b,max(a,x));
function sm(a,b,x) =
    let(u=clamp((x-a)/(b-a),0,1))
    u*u*(3-2*u);
function mix(a,b,u) = a+(b-a)*u;

// Planned object-center height
obj_z =
    t < 0.15 ? 25 :
    t < 0.24 ? mix(25,5,sm(0.15,0.24,t)) :
    t < 0.34 ? mix(5,25,sm(0.24,0.34,t)) :
    t < 0.62 ? 25 :
    t < 0.76 ? mix(25,5,sm(0.62,0.76,t)) :
    t < 0.82 ? 5 : 25;

// Base rotation moves the arm from pickup to destination
J1 =
    t < 0.34 ? 0 :
    t < 0.62 ? 90*sm(0.34,0.62,t) :
    t < 0.82 ? 90 : 90*(1-sm(0.82,1,t));

// Home return after release
target_r = t < 0.82 ? 45 : mix(45,30,sm(0.82,1,t));
target_z = obj_z + TOOL_OFFSET;
z_rel = target_z - BASE_Z;

// Inverse kinematics for the two main arm links
c2 = clamp(
    (target_r*target_r + z_rel*z_rel - L1*L1 - L2*L2)
    /(2*L1*L2), -1, 1
);

q2 = acos(c2);
q1 = atan2(z_rel,target_r)
     - atan2(L2*sin(q2),L1+L2*cos(q2));

// Joint angles in degrees
J2 = 90-q1;
J3 = -q2;

// Keep the tool pointing vertically down
J4 = 180-J2-J3;

// Wrist yaw and roll, fixed for this transfer
J5 = 0;
J6 = 0;

// Gripper closes to grasp, opens to release
gap =
    t < 0.20 ? 8 :
    t < 0.24 ? mix(8,2,sm(0.20,0.24,t)) :
    t < 0.76 ? 2 :
    t < 0.82 ? mix(2,8,sm(0.76,0.82,t)) : 8;

dark   = [0.10,0.13,0.17];
metal  = [0.65,0.70,0.76];
cyan   = [0.0,0.85,1.0];
orange = [1.0,0.32,0.08];

// Mechanical joint housing
module joint(r=9) {
    color(dark) sphere(r=r);
    color(metal)
        rotate([90,0,0])
        cylinder(h=5,r=r*0.65,center=true);
    color(cyan)
        rotate([90,0,0])
        cylinder(h=6,r=r*0.25,center=true);
}

// Arm links point along local Z
module link(len=40,w=12) {
    color(dark)
        translate([0,0,len/2])
        cube([w,w,len],center=true);
    color(metal)
        translate([0,-w*0.2,len/2])
        cube([w*0.65,w*0.4,len*0.8],center=true);
    color(cyan)
        translate([0,-w*0.43,len/2])
        cube([2,1.2,len*0.65],center=true);
}

// Worktable
color([0.25,0.29,0.33])
translate([20,20,-7])
cube([140,120,8],center=true);

// Pickup station
color([0.0,0.65,0.9])
translate([45,0,-2])
cylinder(h=1,r=13);

// Drop-off station
color([0.0,0.85,0.5])
translate([0,45,-2])
cylinder(h=1,r=13);

// Fixed base and rotating platform
color(dark) cylinder(h=8,r=32);
color(metal) translate([0,0,8]) cylinder(h=5,r=27);
color(cyan) translate([0,0,13]) cylinder(h=2,r=22);

// Joint hierarchy: every rotation is applied at its pivot
translate([0,0,15])
rotate([0,0,J1]) {
    color(dark) cylinder(h=10,r=19);

    translate([0,0,18]) {
        joint(12); // J2 shoulder

        rotate([0,J2,0]) {
            link(L1,14);

            translate([0,0,L1]) {
                joint(10); // J3 elbow

                rotate([0,J3,0]) {
                    link(L2,12);

                    translate([0,0,L2]) {
                        joint(8); // J4 wrist pitch

                        rotate([0,J4,0])
                        rotate([J5,0,0])
                        rotate([0,0,J6]) {

                            // Wrist and gripper frame
                            color(metal)
                            translate([0,0,8])
                            cylinder(h=9,r=6);

                            translate([0,0,20]) {
                                color(dark)
                                cube([20,14,9],center=true);

                                color(cyan)
                                translate([0,0,5])
                                cube([12,9,2],center=true);

                                // Jaws: gap controls open/close
                                color(orange)
                                translate([gap/2+5.5,0,12])
                                cube([3,5,17],center=true);

                                color(orange)
                                translate([-gap/2-5.5,0,12])
                                cube([3,5,17],center=true);

                                // Object is attached to the gripper.
                                // Its world position follows the arm joints.
                                if (t >= 0.24 && t < 0.82)
                                    color([0.2,0.95,0.3])
                                    translate([0,0,12])
                                    cube([8,8,8],center=true);
                            }
                        }
                    }
                }
            }
        }
    }
}

// Cube sits at pickup before grasp
if (t < 0.24)
    color([0.2,0.95,0.3])
    translate([45,0,5])
    cube([8,8,8],center=true);

// Cube stays at destination after release
if (t >= 0.82)
    color([0.2,0.95,0.3])
    translate([0,45,5])
    cube([8,8,8],center=true);
