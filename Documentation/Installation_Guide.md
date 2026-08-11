# Smart EV Powertrain Simulator

# Installation Guide

## 1. Introduction

This document explains how to install, configure and prepare the **Smart EV Powertrain Simulator** for use.

The project is developed using **MATLAB and Simulink** and contains MATLAB calculation scripts, Simulink models, project configuration files, drive-cycle data, generated results and technical documentation.

The installation process consists of:

1. Obtaining the project
2. Installing and verifying MATLAB and Simulink
3. Opening the MATLAB project
4. Initialising the project
5. Verifying the project structure
6. Running the MATLAB calculation modules
7. Generating the required calculation data
8. Opening the main Simulink model
9. Running the simulation
10. Opening the dashboard
11. Reviewing the generated results

---

# 2. System Requirements

## 2.1 Hardware Requirements

The project is a MATLAB/Simulink simulation and does not require specialised EV hardware.

A computer with the following is recommended:

| Component | Recommended |
|---|---|
| Processor | Modern multi-core CPU |
| RAM | 8 GB minimum, 16 GB recommended |
| Storage | At least 5 GB free space |
| Display | 1920 × 1080 or higher recommended |
| Operating System | Windows / macOS / Linux supported by MATLAB |

Actual simulation performance depends on the MATLAB release, model complexity and computer hardware.

---

# 3. Software Requirements

The project requires:

| Software | Purpose |
|---|---|
| MATLAB | Engineering calculations and data processing |
| Simulink | Dynamic system simulation |
| MATLAB Project | Project organisation and path management |
| Git | Version control |
| GitHub | Remote repository hosting |

The project should preferably be opened using the MATLAB project file:

```text
Smart-EV-Powertrain-Simulator.prj
```

No additional MATLAB toolboxes beyond base MATLAB and Simulink are required to run the calculation scripts and models as delivered.

---

# 4. Obtaining the Project

## 4.1 Clone with Git (recommended)

```bash
git clone https://github.com/devsurya2004/Smart-EV-Powertrain-Simulator.git
cd Smart-EV-Powertrain-Simulator
```

## 4.2 Or Download as a ZIP

If Git isn't available, download the repository as a ZIP archive from GitHub and extract it to a folder of your choice.

---

# 5. Opening the MATLAB Project

Open MATLAB, navigate to the extracted project folder, and open:

```text
Smart-EV-Powertrain-Simulator.prj
```

Opening the `.prj` file (rather than individual scripts) is recommended because the MATLAB Project automatically manages the folders on the MATLAB path for this project.

---

# 6. Initialising the Project

Every calculation script begins by calling:

```matlab
[EV, scriptFolder, projectRoot] = Initialize_Project();
```

`Initialize_Project.m` (in `Scripts/`) performs the following on each call:

1. Clears the command window (in desktop MATLAB)
2. Resolves the project root and Scripts folder paths
3. Verifies that the `Scripts`, `Models` and `Documentation` folders exist
4. Creates the `Data` and `Results` output folders if they're missing
5. Runs `Project_Parameters.m` to load every project setting into the `EV` structure
6. Exports `EV`, `projectRoot` and `scriptFolder` to the MATLAB base workspace

You don't need to call it directly — every script in `Scripts/` does this automatically as its first line.

---

# 7. Verifying the Project Structure

After opening the project, confirm the following folders are present at the project root:

```text
Data/  Documentation/  DriveCycles/  Images/  Models/  Results/  Scripts/
```

`Data/` and `Results/` are created automatically by `Initialize_Project.m` on first run if they don't already exist, so it's normal for `Data/` to be empty before you've run any calculation scripts.

---

# 8. Running the MATLAB Calculation Modules

The simplest way to run every calculation module in the correct order is:

```matlab
Run_Project
```

This runs, in sequence: Battery → Motor → Transmission → Inverter → Vehicle → Vehicle Dynamics → Drive Cycle → Regenerative Braking → Performance Summary, printing a design report for each stage and reporting total execution time.

Alternatively, run individual scripts directly from `Scripts/` (for example, just `Battery` to re-check the pack sizing) — each script can be run on its own as long as any `Data/*.mat` files it loads from upstream modules already exist.

---

# 9. Generating the Required Calculation Data

Running the scripts in step 8 populates `Data/` with one `.mat` file per module (`Battery_Calculations.mat`, `Motor_Calculations.mat`, `Inverter_Calculations.mat`, `Transmission_Calculations.mat`, `Vehicle_Calculations.mat`, `Vehicle_Dynamics.mat`, `Drive_Cycle.mat`, `Regenerative_Braking.mat`) and one plot set per module inside `Results/`. The Simulink model reads several of these `EV.*` values from the base workspace, so the calculation scripts should be run at least once per MATLAB session before simulating.

---

# 10. Opening the Main Simulink Model and Dashboard

With the calculated `EV` structure in the base workspace, open:

```text
Models/Smart_EV_Powertrain.slx
```

and press **Run** ▶️ to simulate the closed-loop powertrain. Then open:

```text
Models/Smart_EV_Powertrain_Dashboard.slx
```

for a consolidated, gauge-style view of vehicle, battery and motor variables during the same simulation.

See the [User Manual](User_Manual.md) for a walkthrough of what happens at each stage and how to read the results.

---

# 11. Reviewing the Generated Results

Generated plots are saved automatically to `Results/<Module>/` as `.png` files at each script run, and can be browsed directly or referenced from the [Documentation](../README.md) pages, which embed the current set of results inline.

---

# 12. Troubleshooting

| Symptom | Likely Cause | Fix |
|---|---|---|
| `Project_Parameters.m not found` error | Scripts run without opening the `.prj` first | Open `Smart-EV-Powertrain-Simulator.prj`, or run scripts from inside `Scripts/` |
| `Required project folder not found` error | Project extracted with a missing subfolder, or scripts run from the wrong directory | Re-extract/re-clone the repository and open the `.prj` from its root |
| A script errors loading a `Data/*.mat` file | An upstream module hasn't been run yet in this session | Run `Run_Project` to execute every module in the correct order |
| Simulink model uses stale/default values | `EV` in the base workspace is from an old run or was cleared | Re-run `Run_Project` (or the relevant scripts) before running the simulation |

---

## Related Documentation

| ← Previous | Index | Next → |
|---|---|---|
| [Design Decisions](Design_Decisions.md) | [Documentation Home](../README.md) | [User Manual](User_Manual.md) |