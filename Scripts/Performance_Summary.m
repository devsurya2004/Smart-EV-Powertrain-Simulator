%%=========================================================================
% Performance Summary
%
% Project : Smart EV Powertrain Simulator
% Author  : Suryadev
%
% Description:
% Generates a complete summary of the Smart EV Powertrain Simulator
% by loading the results from all subsystem calculation modules.
%
%==========================================================================

clc

close all

clear

[EV, scriptFolder, projectRoot] = Initialize_Project();

%%=========================================================================
% Load Simulation Results
%==========================================================================

loadedBattery = load( ...
    fullfile(projectRoot,'Data','Battery_Calculations.mat'),'EV');

loadedMotor = load( ...
    fullfile(projectRoot,'Data','Motor_Calculations.mat'),'EV');

loadedTransmission = load( ...
    fullfile(projectRoot,'Data','Transmission_Calculations.mat'),'EV');

loadedInverter = load( ...
    fullfile(projectRoot,'Data','Inverter_Calculations.mat'),'EV');

loadedVehicle = load( ...
    fullfile(projectRoot,'Data','Vehicle_Calculations.mat'),'EV');

loadedVehicleDynamics = load( ...
    fullfile(projectRoot,'Data','Vehicle_Dynamics.mat'),'EV');

loadedDriveCycle = load( ...
    fullfile(projectRoot,'Data','Drive_Cycle.mat'),'EV');

loadedRegeneration = load( ...
    fullfile(projectRoot,'Data','Regenerative_Braking.mat'),'EV');

%%=========================================================================
% Combine Loaded Results
%==========================================================================

EV.Battery = loadedBattery.EV.Battery;

EV.Motor = loadedMotor.EV.Motor;

EV.Transmission = loadedTransmission.EV.Transmission;

EV.Inverter = loadedInverter.EV.Inverter;

EV.Vehicle = loadedVehicle.EV.Vehicle;

EV.VehicleDynamics = loadedVehicleDynamics.EV.VehicleDynamics;

EV.DriveCycle = loadedDriveCycle.EV.DriveCycle;

EV.Regeneration = loadedRegeneration.EV.Regeneration;

%%=========================================================================
% Verification
%==========================================================================

fprintf('\n');

fprintf('Loading simulation modules...\n');

fprintf('------------------------------------------------------------\n');

fprintf('Battery               Loaded\n');

fprintf('Motor                 Loaded\n');

fprintf('Transmission          Loaded\n');

fprintf('Inverter              Loaded\n');

fprintf('Vehicle               Loaded\n');

fprintf('Vehicle Dynamics      Loaded\n');

fprintf('Drive Cycle           Loaded\n');

fprintf('Regenerative Braking  Loaded\n');

fprintf('------------------------------------------------------------\n');

fprintf('All modules loaded successfully.\n');

%%=========================================================================
% Overall Performance Calculations
%==========================================================================

SystemEfficiency = ...
    EV.Inverter.Efficiency .* ...
    EV.Transmission.Efficiency;

EnergyConsumption = ...
    EV.DriveCycle.Calculated.EnergyConsumptionkWhPerkm;

EstimatedRange = ...
    EV.Battery.Calculated.Energy.kWh ./ ...
    EnergyConsumption;

OverallStatus = "PASS";
%%=========================================================================
% Performance Summary Report
%==========================================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('           SMART EV POWERTRAIN SIMULATOR\n');
fprintf('              PERFORMANCE SUMMARY\n');
fprintf('============================================================\n\n');

%%=========================================================================
% Battery Pack
%==========================================================================

fprintf('Battery Pack\n');
fprintf('------------------------------------------------------------\n');

fprintf('Target Voltage       : %.2f V\n', ...
    EV.Battery.TargetPackVoltage);

fprintf('Target Energy        : %.2f kWh\n', ...
    EV.Battery.TargetPackEnergykWh);

fprintf('Nominal Voltage      : %.2f V\n', ...
    EV.Battery.Calculated.Voltage.Nominal);

fprintf('Pack Capacity        : %.2f Ah\n', ...
    EV.Battery.Calculated.Capacity.Ah);

fprintf('Stored Energy        : %.2f kWh\n', ...
    EV.Battery.Calculated.Energy.kWh);

fprintf('Continuous Current   : %.2f A\n', ...
    EV.Battery.Calculated.Current.Continuous);

fprintf('Battery Mass         : %.2f kg\n\n', ...
    EV.Battery.Calculated.Mass.Total);

%%=========================================================================
% Motor
%==========================================================================

fprintf('Motor\n');
fprintf('------------------------------------------------------------\n');

fprintf('Motor Type           : %s\n', ...
    EV.Motor.Type);

fprintf('Rated Power          : %.2f kW\n', ...
    EV.Motor.RatedPower/1000);

fprintf('Peak Power           : %.2f kW\n', ...
    EV.Motor.PeakPower/1000);

fprintf('Rated Torque         : %.2f Nm\n', ...
    EV.Motor.RatedTorque);

fprintf('Peak Torque          : %.2f Nm\n', ...
    EV.Motor.PeakTorque);

fprintf('Base Speed           : %.0f RPM\n', ...
    EV.Motor.BaseSpeedRPM);

fprintf('Maximum Speed        : %.0f RPM\n\n', ...
    EV.Motor.MaximumSpeedRPM);

%%=========================================================================
% Transmission
%==========================================================================

fprintf('Transmission\n');
fprintf('------------------------------------------------------------\n');

fprintf('Transmission Type    : %s\n', ...
    EV.Transmission.Type);

fprintf('Gear Ratio           : %.2f\n', ...
    EV.Transmission.GearRatio);

fprintf('Efficiency           : %.2f %%\n\n', ...
    EV.Transmission.Efficiency*100);

%%=========================================================================
% Inverter
%==========================================================================

fprintf('Inverter\n');
fprintf('------------------------------------------------------------\n');

fprintf('Inverter Type        : %s\n', ...
    EV.Inverter.Type);

fprintf('Topology             : %s\n', ...
    EV.Inverter.Topology);

fprintf('Switching Frequency  : %.0f Hz\n', ...
    EV.Inverter.SwitchingFrequency);

fprintf('Efficiency           : %.2f %%\n\n', ...
    EV.Inverter.Efficiency*100);

%%=========================================================================
% Vehicle
%==========================================================================

fprintf('Vehicle\n');
fprintf('------------------------------------------------------------\n');

fprintf('Vehicle Mass         : %.2f kg\n', ...
    EV.Vehicle.Mass);

fprintf('Wheel Radius         : %.3f m\n', ...
    EV.Vehicle.WheelRadius);

fprintf('Drag Coefficient     : %.2f\n', ...
    EV.Vehicle.DragCoefficient);

fprintf('Frontal Area         : %.2f m^2\n\n', ...
    EV.Vehicle.FrontalArea);

%%=========================================================================
% Vehicle Dynamics
%==========================================================================

fprintf('Vehicle Dynamics\n');
fprintf('------------------------------------------------------------\n');

fprintf('Tractive Force       : %.2f N\n', ...
    EV.VehicleDynamics.Calculated.Forces.TractiveN);

fprintf('Rolling Resistance   : %.2f N\n', ...
    EV.VehicleDynamics.Calculated.Forces.RollingResistanceN);

fprintf('Aerodynamic Drag     : %.2f N\n', ...
    EV.VehicleDynamics.Calculated.Forces.AerodynamicDragN);

fprintf('Net Force            : %.2f N\n\n', ...
    EV.VehicleDynamics.Calculated.Forces.NetForceN);

fprintf('Acceleration         : %.2f m/s^2\n', ...
    EV.VehicleDynamics.Calculated.Performance.Acceleration);

fprintf('Wheel Power          : %.2f kW\n', ...
    EV.VehicleDynamics.Calculated.Performance.WheelPowerkW);

fprintf('Power-to-Weight      : %.2f kW/ton\n\n', ...
    EV.VehicleDynamics.Calculated.Performance.PowerToWeightkWPerTon);

%%=========================================================================
% Drive Cycle
%==========================================================================

fprintf('Drive Cycle\n');
fprintf('------------------------------------------------------------\n');

fprintf('Simulation Time      : %.0f s\n', ...
    EV.DriveCycle.Calculated.TripTimeSeconds);

fprintf('Distance Travelled   : %.3f km\n', ...
    EV.DriveCycle.Calculated.Distancekm);

fprintf('Average Speed        : %.2f km/h\n', ...
    EV.DriveCycle.Calculated.AverageSpeedkmh);

fprintf('Maximum Speed        : %.2f km/h\n', ...
    EV.DriveCycle.Calculated.MaximumSpeedkmh);

fprintf('Energy Consumed      : %.4f kWh\n\n', ...
    EV.DriveCycle.Calculated.EnergykWh(end));

%%=========================================================================
% Regenerative Braking
%==========================================================================

fprintf('Regenerative Braking\n');
fprintf('------------------------------------------------------------\n');

fprintf('Recovered Energy     : %.4f kWh\n', ...
    EV.Regeneration.Calculated.TotalRecoveredEnergykWh);

fprintf('Recovery             : %.2f %%\n', ...
    EV.Regeneration.Calculated.RecoveryPercent);

fprintf('Final Battery SOC    : %.2f %%\n\n', ...
    EV.Regeneration.Calculated.StateOfChargePercent(end));

%%=========================================================================
% Overall Performance
%==========================================================================

fprintf('Overall Performance\n');
fprintf('------------------------------------------------------------\n');

fprintf('System Efficiency    : %.2f %%\n', ...
    SystemEfficiency*100);

fprintf('Energy Consumption   : %.3f kWh/km\n', ...
    EnergyConsumption);

fprintf('Estimated Range      : %.2f km\n', ...
    EstimatedRange);

fprintf('Overall Status       : %s\n', ...
    OverallStatus);

fprintf('\n============================================================\n');
%%=========================================================================
% Plot 1
% Energy Distribution
%==========================================================================

figEnergy = figure( ...
    'Name','Energy Distribution', ...
    'Color','w');

EnergyValues = [ ...
    EV.Battery.Calculated.Energy.kWh,...
    EV.DriveCycle.Calculated.EnergykWh(end),...
    EV.Regeneration.Calculated.TotalRecoveredEnergykWh,...
    EV.Battery.Calculated.Energy.kWh ...
    - EV.DriveCycle.Calculated.EnergykWh(end) ...
    + EV.Regeneration.Calculated.TotalRecoveredEnergykWh];

Labels = { ...
    'Battery',...
    'Consumed',...
    'Recovered',...
    'Remaining'};

b = bar(EnergyValues);

grid on
box on

set(gca,...
    'XTickLabel',Labels,...
    'FontSize',11,...
    'LineWidth',1.2);

ylabel('Energy (kWh)');
title('Battery Energy Distribution');

ylim([0 max(EnergyValues)*1.15])

for k = 1:length(EnergyValues)

    text( ...
        k,...
        EnergyValues(k)+0.5,...
        sprintf('%.2f',EnergyValues(k)),...
        'HorizontalAlignment','center',...
        'FontWeight','bold');

end
%%=========================================================================
% Plot 2
% Efficiency Breakdown
%==========================================================================

figEfficiency = figure( ...
    'Name','Efficiency Breakdown', ...
    'Color','w');

bar( ...
    [100 ...
    EV.Inverter.Efficiency*100 ...
    EV.Transmission.Efficiency*100 ...
    SystemEfficiency*100], ...
    'LineWidth',1.5);

grid on

box on

set(gca, ...
    'XTickLabel', ...
    {'Battery','Inverter','Transmission','Overall'}, ...
    'FontSize',11, ...
    'LineWidth',1.2);

ylabel('Efficiency (%)');

title('Powertrain Efficiency');
%%=========================================================================
% Plot 3
% Power Flow Through the Powertrain
%==========================================================================

PeakBatteryPower = max(EV.DriveCycle.Calculated.BatteryPowerkW);

PeakMotorPower = max(EV.DriveCycle.Calculated.MotorPowerkW);

PeakWheelPower = max(EV.DriveCycle.Calculated.WheelPowerkW);

figPowerFlow = figure( ...
    'Name','Power Flow', ...
    'Color','w');

PowerData = [ ...
    PeakBatteryPower ...
    PeakMotorPower ...
    PeakWheelPower];

bar(PowerData, ...
    'LineWidth',1.5);

grid on
box on

set(gca,...
    'XTickLabel',...
    {'Battery','Motor','Wheel'},...
    'FontSize',11,...
    'LineWidth',1.2);

ylabel('Peak Power (kW)');

title('Peak Power Flow Through the Powertrain');

ylim([0 max(PowerData)*1.15]);

%-------------------------------------------------------------
% Display values above each bar
%-------------------------------------------------------------
for k = 1:length(PowerData)

    text( ...
        k, ...
        PowerData(k)+0.5, ...
        sprintf('%.2f kW',PowerData(k)), ...
        'HorizontalAlignment','center', ...
        'FontSize',10);

end
%%=========================================================================
% Plot 4
% Powertrain Architecture
%==========================================================================

figArchitecture = figure( ...
    'Name','System Overview', ...
    'Color','w');

axis off

annotation('textbox',[0.05 0.45 0.12 0.12], ...
    'String','Battery', ...
    'HorizontalAlignment','center');

annotation('textbox',[0.28 0.45 0.12 0.12], ...
    'String','Inverter', ...
    'HorizontalAlignment','center');

annotation('textbox',[0.50 0.45 0.12 0.12], ...
    'String','Motor', ...
    'HorizontalAlignment','center');

annotation('textbox',[0.72 0.45 0.12 0.12], ...
    'String','Transmission', ...
    'HorizontalAlignment','center');

annotation('textbox',[0.90 0.45 0.08 0.12], ...
    'String','Vehicle', ...
    'HorizontalAlignment','center');

annotation('arrow',[0.17 0.28],[0.51 0.51]);

annotation('arrow',[0.40 0.50],[0.51 0.51]);

annotation('arrow',[0.62 0.72],[0.51 0.51]);

annotation('arrow',[0.84 0.90],[0.51 0.51]);

title('Smart EV Powertrain Architecture');
%%=========================================================================
% Save Figures
%==========================================================================

resultsFolder = fullfile(projectRoot,'Results','PerformanceSummary');

if ~exist(resultsFolder,'dir')
    mkdir(resultsFolder);
end

exportgraphics( ...
    figEnergy, ...
    fullfile(resultsFolder,'EnergyDistribution.png'), ...
    'Resolution',300);

exportgraphics( ...
    figEfficiency, ...
    fullfile(resultsFolder,'EfficiencyBreakdown.png'), ...
    'Resolution',300);

exportgraphics( ...
    figPowerFlow, ...
    fullfile(resultsFolder,'PowerFlow.png'), ...
    'Resolution',300);

exportgraphics( ...
    figArchitecture, ...
    fullfile(resultsFolder,'SystemArchitecture.png'), ...
    'Resolution',300);
%%=========================================================================
% Close Figures
%==========================================================================

close(figEnergy);

close(figEfficiency);

close(figPowerFlow);

close(figArchitecture);

fprintf('\nPerformance summary figures saved successfully.\n');

fprintf('Location : %s\n', resultsFolder);
