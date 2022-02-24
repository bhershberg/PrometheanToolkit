% This function is a part of the Results Manager API
% Benjamin Hershberg, 2020
%
% Usage:
% 
%   setControlState(controlState);
% 
%   + description: overwrite the current control variable state
%   + inputs: controlState - the control state to load
%   + outputs: none
%
function setControlState(controlState)
    
    if(isfield(controlState,'stateType'))
        controlState = controlState.stateData;
    end

    global settings;
    
    basePath = getGlobalOption('controlVariablePath');
    
    backup = getControlState;
    try
        eval(sprintf('%s = controlState;',basePath));
        redrawControlVariableEditorTab;
    catch
        eval(sprintf('%s = backup.data;',basePath));
        redrawControlVariableEditorTab;
        warning('Failed to set new Control State. Reverting to original');
    end

end