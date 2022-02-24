% This function is a part of the Results Manager API
% Benjamin Hershberg, 2020
%
% Usage:
% 
%   globalOptionsState = getGlobalOptionsState();
% 
%   + description: fetch a copy of the current global options state. This
%                   can be useful for attaching to saved results for traceability.
%   + inputs: none
%   + outputs: globalOptionsState - the current global options state data
%
function globalOptionsState = getGlobalOptionsState()

    global settings;

    globalOptionsState.stateType = 'Global Options';
    globalOptionsState.restoreFunction = @setGlobalOptionsState;
    globalOptionsState.stateData = settings.options;

end