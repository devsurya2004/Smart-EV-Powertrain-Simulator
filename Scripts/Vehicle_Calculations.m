%%=========================================================================
% Vehicle Calculations
%==========================================================================

clear
clc

run('Project_Parameters.m')

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
% Required Motor Power
%==========================================================================

EV.Calculated.RequiredMotorPower = ...
    EV.Calculated.TotalResistanceForce * ...
    EV.Requirements.TopSpeed;

%%=========================================================================
% Results
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
    EV.Calculated.RequiredMotorPower/1000);

fprintf('======================================================\n');

save('../Data/Vehicle_Calculations.mat','EV');