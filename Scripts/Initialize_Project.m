function [EV, scriptFolder, projectRoot] = Initialize_Project()
%%=========================================================================
% Initialize Project
%
% Project : Smart EV Powertrain Simulator
% Author  : Suryadev
%
% Description:
% Initializes the Smart EV Powertrain Simulator by:
%   1. Clearing the Command Window
%   2. Setting project paths
%   3. Loading project parameters
%
% Outputs:
%   EV            - Project parameter structure
%   scriptFolder  - Absolute path of Scripts folder
%   projectRoot   - Absolute path of project root
%
%==========================================================================

clc

%%=========================================================================
% Project Paths
%==========================================================================

scriptFolder = fileparts(mfilename('fullpath'));
projectRoot  = fileparts(scriptFolder);
%%=========================================================================
% Create Project Folders
%==========================================================================

folders = {'Data','Results','Models'};

for k = 1:numel(folders)

    folderPath = fullfile(projectRoot, folders{k});

    if ~exist(folderPath,'dir')
        mkdir(folderPath);
    end

end
%%=========================================================================
% Load Project Parameters
%==========================================================================

run(fullfile(scriptFolder,'Project_Parameters.m'));

end

