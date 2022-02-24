% =========================================================================
% Example - Export of Control Variables to an ADE state in Cadence
% =========================================================================
% Benjamin Hershberg, 2020
%
function example__exportToADE(options)

    global settings;
    
    % Setup:
    parser = structFieldDefaults();
    parser.add('returnDefaults',false); % do not remove
    parser.add('debug',true);
    parser.add('libraryPath','./outputs/CADENCE_LIBRARY/');
    parser.add('statePrefix','BH_'); % use this to put a naming prefix on the ADE states that export, to make things easier for mutli-user environments where several people are sharing a Cadence library.
    parser.add('exportADE',true);
    options = parser.applyDefaults(options);
    if(options.returnDefaults), global defaultOptions; defaultOptions = options; return; end  % do not remove
    
    % An example of making an ADE variable state for a top-level testbench:
    adeSpec = struct;
    adeSpec.name = 'Testbench_TOP';
    adeSpec.parts = {};
    adeSpec.parts{end+1} = {'digital','D_'}; % all the digital controls, we put a "D_" prefix onto to make it easier to separate/sort digital controls in Cadence
    adeSpec.parts{end+1} = {'sim'};
    exportSettingsToADE(settings, adeSpec, options);
    
    % An example of making an ADE variable state for a channel-level testbench:
    adeSpec = struct;
    adeSpec.name = 'Testbench_CHANNEL';
    adeSpec.parts = {};
    adeSpec.parts{end+1} = {'digital.CH1','D_CH1_'};
    adeSpec.parts{end+1} = {'sim'};
    exportSettingsToADE(settings, adeSpec, options);
    
    % Notice here how we just set up exporters for two different variable
    % states for two different testbenches in Cadence, but it is all
    % generated from a single SOURCE. This is the key to always keeping
    % everything up to date and synchronized.

end