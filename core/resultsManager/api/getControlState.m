% This function is a part of the Results Manager API
% Benjamin Hershberg, 2020
%
% Usage:
% 
%   controlState = getControlState();
% 
%   + description: fetch a copy of the current control variable state. This
%                   can be useful for attaching to saved results for traceability.
%   + inputs: none
%   + outputs: controlState - the current control variable state data
%
function controlState = getControlState()

    global settings;

    basePath = getGlobalOption('controlVariablePath','settings.lab.results');
    if(~structFieldPathExists(settings,basePath))
        eval(sprintf('%s = struct();',basePath));
    end
    
    controlState.stateType = 'Control Variable';
    controlState.restoreFunction = @setControlState;
    eval(sprintf('controlState.stateData = %s;',basePath));

end