# Robotic Arm Simulation — Pick-and-Place

## Project Overview

This project demonstrates the 3D design and basic motion simulation of a robotic arm using OpenSCAD. The arm performs a pick-and-place operation by approaching an object, grasping it, transporting it to another location, and releasing it.

## Objectives

- Design a 3D robotic arm model.
- Identify the arm's degrees of freedom (DOF).
- Simulate a basic pick-and-place sequence.
- Understand robotic joint movements and end-effector operation.

## Degrees of Freedom (DOF)

The model represents six rotational joint axes:

| Joint | Movement | Purpose |
|---|---|---|
| J1 | Base rotation | Rotates the arm |
| J2 | Shoulder pitch | Raises or lowers the upper arm |
| J3 | Elbow pitch | Bends or extends the forearm |
| J4 | Wrist pitch | Tilts the wrist |
| J5 | Wrist yaw | Changes wrist orientation sideways |
| J6 | Wrist roll | Rotates the end-effector |

The gripper opens and closes separately to grasp and release objects. The scripted animation may use only some of these axes during the transfer.

## Simulation Workflow

1. Start with the robotic arm in its initial position.
2. Move the gripper toward the object.
3. Grasp and lift the object.
4. Transport it to the destination.
5. Lower the object and release it.
6. Observe the completed pick-and-place operation.

## Technologies Used

- OpenSCAD
- OpenSCAD scripting language
- Parametric 3D modelling
- Scripted animation

## Project Files

```text
Robotic_Arm_Assignment/
├── Robotic_Arm_Simulation.scad
├── Robotic_Arm_Report.docx
├── Screenshot_1_Pickup.png
├── Screenshot_2_Carry.png
├── Screenshot_3_Placement.png
└── README.md
```

## How to Run

1. Install OpenSCAD from https://openscad.org/
2. Open `Robotic_Arm_Simulation.scad`.
3. Press **F5** to preview the model.
4. Open **View → Animate**.
5. Set the animation FPS and Steps values as required.
6. Start the animation to observe the pick-and-place sequence.

## Results

The project demonstrates a 3D robotic arm and its scripted pick-and-place motion. Screenshots of the pickup, carrying, and placement stages document the simulation.

## Limitations

This is an educational visual simulation. It does not independently validate real-world dynamics, payload capacity, collision avoidance, or hardware performance.

## Future Improvements

- Implement inverse kinematics for target positioning.
- Add joint limits and collision detection.
- Integrate a physics-based robotics simulator.
- Extend the model with sensor feedback and robotic control.

## References

- OpenSCAD Documentation: https://openscad.org/documentation.html
- OpenSCAD User Manual: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual

