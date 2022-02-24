% This function is a part of the Results Manager API
% Benjamin Hershberg, 2020
%
% Usage:
% 
%   exportState = getExportState();
% 
%   + description: fetch a copy of the current Export Control state. This
%                   can be useful for attaching to saved results for traceability.
%   + inputs: none
%   + outputs: exportState - the current state data for Export Control.
%
function execState = getExecState()

    global settings;
    
    execState.stateType = 'Execution Manager';
    execState.restoreFunction = @setExecState;
    execState.stateData = settings.export.profiles;

end