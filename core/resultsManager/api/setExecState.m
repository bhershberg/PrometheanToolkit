% This function is a part of the Results Manager API
% Benjamin Hershberg, 2020
%
% Usage:
% 
%   setExportState(exportState);
% 
%   + description: overwrite the current export control state
%   + inputs: exportState - the state to load
%   + outputs: none
%
function setExecState(execState)

    if(isfield(execState,'stateType'))
        execState = execState.stateData;
    end

    global settings;
    backup = getExecState;
    try
        settings.export.profiles = execState;
        redrawExportControlTab;
    catch
        settings.export.profiles = backup.data;
        redrawExportControlTab;
        warning('Failed to set new Execution Manager State. Reverting to original');
    end

end