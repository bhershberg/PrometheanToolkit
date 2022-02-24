% This function is a part of the Results Manager API
% Benjamin Hershberg, 2020
%
% Usage:
% 
%   setGlobalOptionsState(globalOptionsState);
% 
%   + description: overwrite the current global options state
%   + inputs: globalOptionsState - the state to load
%   + outputs: none
%
function setGlobalOptionsState(globalOptionsState)

    if(isfield(globalOptionsState,'stateType'))
        globalOptionsState = globalOptionsState.stateData;
    end

    global settings;
    backup = getGlobalOptionsState;
    try
        settings.options = globalOptionsState;
    catch
        settings.options = backup.data;
        warning('Failed to set new Global Options state. Reverting to original');
    end

end