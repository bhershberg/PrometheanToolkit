% Launches the GUI for Promethean Toolkit.
% This GUI operates on the "settings" data structure which contains all the
% state information for configuring the chip. It can be used to set up a
% simulation in cadence or to run measurements in the lab.
%
% Benjamin Hershberg
% imec, 2018-2022
%
function PrometheanToolkit()

    % =========================================
    % INITIALIZATION (DO NOT TOUCH)
    % =========================================
    scriptsDirectory = fileparts(which(mfilename));
    addpath(genpath(scriptsDirectory));
    initializeGUI;
    % =========================================
    
    % NOTE: you can add your own custom tabs to the GUI by registering them
    % in the file:
    %   ./custom/gui_customization/custom__initializeProjectGuiTab.m

end