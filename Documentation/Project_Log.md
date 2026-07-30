# Day 1 (29/07/2026)

## Objectives
- Set up the development environment.
- Create the project architecture.
- Begin vehicle performance calculations.

## Completed

### Project Setup
- Installed MATLAB R2026a Update 4.
- Created MATLAB Project.
- Initialized Git repository.
- Created project folder structure.
- Added README.md.
- Added .gitignore.

### Documentation
- Created:
  - Design_Decisions.md
  - Battery.md
  - Motor.md
  - Vehicle.md
  - Controller.md
  - Project_Log.md

### Vehicle Configuration
- Selected project vehicle:
  - SEV-01
  - Compact Electric SUV
- Vehicle mass: 1650 kg
- Top speed: 150 km/h
- Battery voltage: 400 V
- Battery capacity: 45 kWh
- Motor type: PMSM
- Drivetrain: Front-Wheel Drive

### MATLAB Development
- Created Project_Parameters.m.
- Designed EV structure for project parameters.
- Created Vehicle_Calculations.m.

### Engineering Calculations
Calculated:
- Rolling resistance force
- Aerodynamic drag force
- Total resistance force
- Required cruising motor power
- Acceleration (0–100 km/h in 9.5 s)
- Acceleration force
- Total tractive force
- Peak mechanical power

### Results
- Rolling Resistance Force: 161.87 N
- Aerodynamic Drag Force: 765.62 N
- Total Resistance Force: 927.49 N
- Required Cruising Power: 38.65 kW
- Acceleration: 2.92 m/s²
- Acceleration Force: 4824.56 N
- Total Tractive Force: 5752.05 N
- Peak Mechanical Power: 159.78 kW

### Git
- First commit created.
- Commit message:
  "Initial project setup and vehicle dynamics calculations"

## Lessons Learned
- Use a parameter-driven project structure.
- Store calculated values inside EV.Calculated.
- Verify engineering calculations manually before trusting MATLAB outputs.
- Organize code into logical sections for maintainability.

## Next Milestone
- Determine motor rated power.
- Calculate gear ratio.
- Select PMSM specifications.
- Begin motor sizing calculations.