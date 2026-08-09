[EV, scriptFolder, projectRoot] = Initialize_Project();

%%=========================================================================
% Load Required Data
%==========================================================================

loadedVehicle = load( ...
    fullfile(projectRoot,'Data','Vehicle_Calculations.mat'), ...
    'EV');

EV.Calculated = loadedVehicle.EV.Calculated;

loadedTransmission = load( ...
    fullfile(projectRoot,'Data','Transmission_Calculations.mat'), ...
    'EV');

EV.Transmission.Calculated = ...
    loadedTransmission.EV.Transmission.Calculated;

loadedInverter = load( ...
    fullfile(projectRoot,'Data','Inverter_Calculations.mat'), ...
    'EV');

EV.Inverter.Calculated = ...
    loadedInverter.EV.Inverter.Calculated;
%%=========================================================================
% Tractive Force Calculations
% Calculates the force available at the wheels.
%==========================================================================

EV.VehicleDynamics.Calculated.Forces.TractiveN = ...
    EV.Transmission.Calculated.Output.TorqueNm / ...
    EV.Vehicle.WheelRadius;
%%=========================================================================
% Road Load Forces
% Loads rolling resistance and aerodynamic drag.
%==========================================================================

EV.VehicleDynamics.Calculated.Forces.RollingResistanceN = ...
    EV.Calculated.RollingResistanceForce;

EV.VehicleDynamics.Calculated.Forces.AerodynamicDragN = ...
    EV.Calculated.AerodynamicDragForce;
%%=========================================================================
% Net Force Calculations
% Calculates the net force acting on the vehicle.
%==========================================================================

EV.VehicleDynamics.Calculated.Forces.NetForceN = ...
    EV.VehicleDynamics.Calculated.Forces.TractiveN - ...
    EV.VehicleDynamics.Calculated.Forces.RollingResistanceN - ...
    EV.VehicleDynamics.Calculated.Forces.AerodynamicDragN;
%%=========================================================================
% Vehicle Acceleration
% Calculates the vehicle acceleration.
%==========================================================================

EV.VehicleDynamics.Calculated.Performance.Acceleration = ...
    EV.VehicleDynamics.Calculated.Forces.NetForceN / ...
    EV.Vehicle.Mass;
%%=========================================================================
% Wheel Power
% Calculates the wheel power.
%==========================================================================

WheelPower = ...
    EV.VehicleDynamics.Calculated.Forces.TractiveN * ...
    EV.Requirements.TopSpeed;

EV.VehicleDynamics.Calculated.Performance.WheelPowerkW = ...
    WheelPower / 1000;
%%=========================================================================
% Power-to-Weight Ratio
% Calculates the vehicle power-to-weight ratio.
%==========================================================================

VehicleMassTon = ...
    EV.Vehicle.Mass / 1000;

EV.VehicleDynamics.Calculated.Performance.PowerToWeightkWPerTon = ...
    EV.Motor.PeakPower / 1000 / ...
    VehicleMassTon;
%%=========================================================================
% Vehicle Dynamics Validation
% Validates the calculated vehicle dynamics parameters.
%==========================================================================

ValidationStatus = "PASS";

if EV.VehicleDynamics.Calculated.Forces.NetForceN <= 0
    ValidationStatus = "FAIL";
end
%%=========================================================================
% Display Results
% Displays vehicle dynamics calculation summary.
%==========================================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('              SMART EV POWERTRAIN SIMULATOR\n');
fprintf('              VEHICLE DYNAMICS REPORT\n');
fprintf('============================================================\n');
fprintf('\nVehicle Forces\n');
fprintf('------------------------------------------------------------\n');

fprintf('Tractive Force       : %.2f N\n', ...
    EV.VehicleDynamics.Calculated.Forces.TractiveN);

fprintf('Rolling Resistance   : %.2f N\n', ...
    EV.VehicleDynamics.Calculated.Forces.RollingResistanceN);

fprintf('Aerodynamic Drag     : %.2f N\n', ...
    EV.VehicleDynamics.Calculated.Forces.AerodynamicDragN);

fprintf('Net Force            : %.2f N\n', ...
    EV.VehicleDynamics.Calculated.Forces.NetForceN);
fprintf('\nVehicle Performance\n');
fprintf('------------------------------------------------------------\n');

fprintf('Acceleration         : %.2f m/s^2\n', ...
    EV.VehicleDynamics.Calculated.Performance.Acceleration);

fprintf('Wheel Power          : %.2f kW\n', ...
    EV.VehicleDynamics.Calculated.Performance.WheelPowerkW);

fprintf('Power-to-Weight      : %.2f kW/ton\n', ...
    EV.VehicleDynamics.Calculated.Performance.PowerToWeightkWPerTon);
fprintf('\nValidation\n');
fprintf('------------------------------------------------------------\n');

fprintf('Overall Status       : %s\n', ...
    ValidationStatus);

fprintf('\n============================================================\n');
%%=========================================================================
% Save Results
% Saves vehicle dynamics calculation results.
%==========================================================================

save( ...
    fullfile(projectRoot,'Data','Vehicle_Dynamics.mat'), ...
    'EV');

fprintf('\nVehicle dynamics calculations saved successfully.\n');
fprintf('Location : %s\n', ...
    fullfile(projectRoot,'Data','Vehicle_Dynamics.mat'));