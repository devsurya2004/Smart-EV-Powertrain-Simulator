%%=========================================================================
% Vehicle Calculations
% Smart-EV-Powertrain-Simulator
%
% Purpose:
% Calculate the vehicle forces and power requirements.
%
% Outputs:
%   - Rolling Resistance Force
%   - Aerodynamic Drag Force
%   - Total Resistance Force
%   - Required Cruising Motor Power
%   - Acceleration
%   - Acceleration Force
%   - Total Tractive Force
%   - Peak Mechanical Power
%==========================================================================

clc

close all

clear

[EV, scriptFolder, projectRoot] = Initialize_Project();

%%=========================================================================
% Rolling Resistance Force
%==========================================================================

EV.Calculated.RollingResistanceForce = ...
    EV.Vehicle.RollingResistanceCoeff * ...
    EV.Vehicle.Mass * ...
    EV.Environment.Gravity;

%%=========================================================================
% Aerodynamic Drag Force
%==========================================================================

EV.Calculated.AerodynamicDragForce = ...
    0.5 * ...
    EV.Environment.AirDensity * ...
    EV.Vehicle.DragCoefficient * ...
    EV.Vehicle.FrontalArea * ...
    EV.Requirements.TopSpeed^2;

%%=========================================================================
% Total Resistive Force
%==========================================================================

EV.Calculated.TotalResistanceForce = ...
    EV.Calculated.RollingResistanceForce + ...
    EV.Calculated.AerodynamicDragForce;

%%=========================================================================
% Required Cruising Motor Power
%==========================================================================

EV.Calculated.RequiredMotorPower = ...
    EV.Calculated.TotalResistanceForce * ...
    EV.Requirements.TopSpeed;

%%=========================================================================
% Acceleration Performance
%==========================================================================

TargetSpeed = 100 / 3.6;      % m/s
AccelerationTime = 9.5;       % s

EV.Calculated.Acceleration = ...
    TargetSpeed / AccelerationTime;

EV.Calculated.AccelerationForce = ...
    EV.Vehicle.Mass * EV.Calculated.Acceleration;

EV.Calculated.TotalTractiveForce = ...
    EV.Calculated.RollingResistanceForce + ...
    EV.Calculated.AerodynamicDragForce + ...
    EV.Calculated.AccelerationForce;

EV.Calculated.PeakMechanicalPower = ...
    EV.Calculated.TotalTractiveForce * TargetSpeed;

%%=========================================================================
% Display Results
%==========================================================================

fprintf('\n');
fprintf('================ Vehicle Calculations ================\n');

fprintf('Rolling Resistance Force : %.2f N\n', ...
    EV.Calculated.RollingResistanceForce);

fprintf('Aerodynamic Drag Force   : %.2f N\n', ...
    EV.Calculated.AerodynamicDragForce);

fprintf('Total Resistance Force   : %.2f N\n', ...
    EV.Calculated.TotalResistanceForce);

fprintf('Required Motor Power     : %.2f kW\n', ...
    EV.Calculated.RequiredMotorPower / 1000);

fprintf('------------------------------------------------------\n');

fprintf('Acceleration             : %.2f m/s^2\n', ...
    EV.Calculated.Acceleration);

fprintf('Acceleration Force       : %.2f N\n', ...
    EV.Calculated.AccelerationForce);

fprintf('Total Tractive Force     : %.2f N\n', ...
    EV.Calculated.TotalTractiveForce);

fprintf('Peak Mechanical Power    : %.2f kW\n', ...
    EV.Calculated.PeakMechanicalPower / 1000);

fprintf('======================================================\n');

%%=========================================================================
% Save Results
%==========================================================================

save(fullfile(projectRoot,'Data','Vehicle_Calculations.mat'),'EV');