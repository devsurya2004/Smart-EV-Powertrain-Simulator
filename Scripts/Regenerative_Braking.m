clc

close all

clear

[EV, scriptFolder, projectRoot] = Initialize_Project();
%%=========================================================================
% Load Required Data
%==========================================================================

loadedDriveCycle = load( ...
    fullfile(projectRoot,'Data','Drive_Cycle.mat'), ...
    'EV');

EV.DriveCycle = loadedDriveCycle.EV.DriveCycle;

loadedBattery = load( ...
    fullfile(projectRoot,'Data','Battery_Calculations.mat'), ...
    'EV');

EV.Battery = loadedBattery.EV.Battery;
%%=========================================================================
% Braking Detection
% Detects vehicle deceleration suitable for regenerative braking.
%==========================================================================

EV.Regeneration.Calculated.IsBraking = ...
    EV.DriveCycle.Acceleration < 0;

EV.Regeneration.Calculated.IsRegenerationActive = ...
    EV.Regeneration.Calculated.IsBraking & ...
    (EV.DriveCycle.Speedkmh >= EV.Regeneration.MinSpeedkmh);
%%=========================================================================
% Available Braking Power
% Calculates power available during braking.
%==========================================================================

EV.Regeneration.Calculated.BrakingPowerkW = ...
    zeros(size(EV.DriveCycle.Time));

EV.Regeneration.Calculated.BrakingPowerkW( ...
    EV.Regeneration.Calculated.IsRegenerationActive) = ...
    abs( ...
    EV.DriveCycle.Calculated.BatteryPowerkW( ...
    EV.Regeneration.Calculated.IsRegenerationActive));
%%=========================================================================
% Recovered Power
% Calculates electrical power recovered by regenerative braking.
%==========================================================================

EV.Regeneration.Calculated.RecoveredPowerkW = ...
    EV.Regeneration.Calculated.BrakingPowerkW .* ...
    EV.Regeneration.Efficiency;
%%=========================================================================
% Regeneration Power Limit
% Limits recovered power to the maximum allowable value.
%==========================================================================

EV.Regeneration.Calculated.RecoveredPowerkW = ...
    min( ...
    EV.Regeneration.Calculated.RecoveredPowerkW, ...
    EV.Regeneration.MaxPowerkW);
%%=========================================================================
% Recovered Energy
% Calculates cumulative recovered battery energy.
%==========================================================================

RecoveredEnergyPerSecond = ...
    EV.Regeneration.Calculated.RecoveredPowerkW / ...
    3600;

EV.Regeneration.Calculated.RecoveredEnergykWh = ...
    cumsum(RecoveredEnergyPerSecond);
%%=========================================================================
% Net Battery Energy
% Calculates net battery energy after regeneration.
%==========================================================================

EV.Regeneration.Calculated.NetBatteryEnergykWh = ...
    EV.DriveCycle.Calculated.EnergykWh - ...
    EV.Regeneration.Calculated.RecoveredEnergykWh;
%%=========================================================================
% Total Recovered Energy
%==========================================================================

EV.Regeneration.Calculated.TotalRecoveredEnergykWh = ...
    EV.Regeneration.Calculated.RecoveredEnergykWh(end);
%%=========================================================================
% Recovery Percentage
%==========================================================================

TotalConsumedEnergy = ...
    EV.DriveCycle.Calculated.EnergykWh(end);

if TotalConsumedEnergy > 0

    EV.Regeneration.Calculated.RecoveryPercent = ...
        EV.Regeneration.Calculated.TotalRecoveredEnergykWh / ...
        TotalConsumedEnergy * 100;

else

    EV.Regeneration.Calculated.RecoveryPercent = 0;

end
%%=========================================================================
% Battery State of Charge
%==========================================================================

BatteryCapacitykWh = ...
    EV.Battery.Calculated.Energy.kWh;

InitialSOC = 100;

EnergyUsedPercent = ...
    EV.Regeneration.Calculated.NetBatteryEnergykWh ./ ...
    BatteryCapacitykWh * 100;

EV.Regeneration.Calculated.StateOfChargePercent = ...
    InitialSOC - EnergyUsedPercent;
%%=========================================================================
% Validation
%==========================================================================

ValidationStatus = "PASS";

if EV.Regeneration.Calculated.RecoveryPercent > 100

    ValidationStatus = "FAIL";

end

if any(EV.Regeneration.Calculated.StateOfChargePercent > 100)

    ValidationStatus = "FAIL";

end
%%=========================================================================
% Display Report
%==========================================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('            REGENERATIVE BRAKING REPORT\n');
fprintf('============================================================\n\n');

fprintf('Regeneration Information\n');
fprintf('------------------------------------------------------------\n');

fprintf('Efficiency            : %.2f %%\n', ...
    EV.Regeneration.Efficiency * 100);

fprintf('Maximum Power         : %.2f kW\n', ...
    EV.Regeneration.MaxPowerkW);

fprintf('Minimum Speed         : %.2f km/h\n\n', ...
    EV.Regeneration.MinSpeedkmh);

fprintf('Energy Recovery\n');
fprintf('------------------------------------------------------------\n');

fprintf('Recovered Energy      : %.4f kWh\n', ...
    EV.Regeneration.Calculated.TotalRecoveredEnergykWh);

fprintf('Recovery Percentage   : %.2f %%\n\n', ...
    EV.Regeneration.Calculated.RecoveryPercent);

fprintf('Battery\n');
fprintf('------------------------------------------------------------\n');

fprintf('Final SOC             : %.2f %%\n', ...
    EV.Regeneration.Calculated.StateOfChargePercent(end));

fprintf('Net Battery Energy    : %.4f kWh\n\n', ...
    EV.Regeneration.Calculated.NetBatteryEnergykWh(end));

fprintf('Validation\n');
fprintf('------------------------------------------------------------\n');

fprintf('Overall Status        : %s\n', ...
    ValidationStatus);

fprintf('\n============================================================\n');
%%=========================================================================
% Plot 1
% Braking Power
%==========================================================================

figBrakingPower = figure( ...
    'Name','Braking Power', ...
    'Color','w');

plot( ...
    EV.DriveCycle.Time, ...
    EV.Regeneration.Calculated.BrakingPowerkW, ...
    'LineWidth',2);

hold on

grid on

box on

xlabel('Time (s)','FontSize',11);

ylabel('Power (kW)','FontSize',11);

title('Braking Power','FontWeight','bold');

set(gca,'FontSize',11,'LineWidth',1.2);
%%=========================================================================
% Plot 2
% Recovered Power
%==========================================================================

figRecoveredPower = figure( ...
    'Name','Recovered Power', ...
    'Color','w');

plot( ...
    EV.DriveCycle.Time, ...
    EV.Regeneration.Calculated.RecoveredPowerkW, ...
    'LineWidth',2);

hold on

grid on

box on

xlabel('Time (s)','FontSize',11);

ylabel('Power (kW)','FontSize',11);

title('Recovered Power','FontWeight','bold');

set(gca,'FontSize',11,'LineWidth',1.2);
%%=========================================================================
% Plot 3
% Recovered Energy
%==========================================================================

figRecoveredEnergy = figure( ...
    'Name','Recovered Energy', ...
    'Color','w');

plot( ...
    EV.DriveCycle.Time, ...
    EV.Regeneration.Calculated.RecoveredEnergykWh, ...
    'LineWidth',2);

hold on

grid on

box on

xlabel('Time (s)','FontSize',11);

ylabel('Energy (kWh)','FontSize',11);

title('Recovered Energy','FontWeight','bold');

set(gca,'FontSize',11,'LineWidth',1.2);
%%=========================================================================
% Plot 4
% Battery State of Charge
%==========================================================================

figSOC = figure( ...
    'Name','Battery State of Charge', ...
    'Color','w');

plot( ...
    EV.DriveCycle.Time, ...
    EV.Regeneration.Calculated.StateOfChargePercent, ...
    'LineWidth',2);

hold on

grid on

box on

xlabel('Time (s)','FontSize',11);

ylabel('SOC (%)','FontSize',11);

ylim([95 100]);

title('Battery State of Charge','FontWeight','bold');

set(gca,'FontSize',11,'LineWidth',1.2);
%%=========================================================================
% Save Figures
%==========================================================================

resultsFolder = fullfile(projectRoot,'Results','RegenerativeBraking');

if ~exist(resultsFolder,'dir')
    mkdir(resultsFolder);
end

exportgraphics(figBrakingPower, ...
    fullfile(resultsFolder,'BrakingPower.png'), ...
    'Resolution',300);

exportgraphics(figRecoveredPower, ...
    fullfile(resultsFolder,'RecoveredPower.png'), ...
    'Resolution',300);

exportgraphics(figRecoveredEnergy, ...
    fullfile(resultsFolder,'RecoveredEnergy.png'), ...
    'Resolution',300);

exportgraphics(figSOC, ...
    fullfile(resultsFolder,'StateOfCharge.png'), ...
    'Resolution',300);

close(figBrakingPower);
close(figRecoveredPower);
close(figRecoveredEnergy);
close(figSOC);
%%=========================================================================
% Save Results
%==========================================================================

save( ...
    fullfile(projectRoot,'Data','Regenerative_Braking.mat'), ...
    'EV');

fprintf('\nRegenerative braking results saved successfully.\n');

fprintf('Location : %s\n', ...
    fullfile(projectRoot,'Data','Regenerative_Braking.mat'));
