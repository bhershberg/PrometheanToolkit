% This function is a part of the Control Variable API
% Benjamin Hershberg, 2020
%
% Usage:
% 
%   [absolutePath, tf] = getAbsoluteControlVariablePath(pathString)
% 
% REQUIRED INPUTS:
%   pathString:     string - the path in the control variable hierarchy to
%                       convert to an absolute path. Does not matter if
%                       this is an absolute or relative path to begin with,
%                       both are accepted.
% OUTPUTS:
%   absolutePath:   string - the input path, converted to an absolute path
%                       with respect to the base "global settings;" structure.
%   success:        1 if a valid path was returned, 0 otherwise
function [absolutePath, tf] = getAbsoluteControlVariablePath(pathString)
    
    global settings;
    
    if(isempty(getGlobalOption('controlVariablePath')))
        setGlobalOption('controlVariablePath','settings.ctrl');
    end
    
    absolutePath = getGlobalOption('controlVariablePath');

    % let's enforce a relative path to begin with:
    pathString = getRelativeControlVariablePath(pathString);
    pathPieces = strsplit(pathString,'.');
    
    for i = 1:length(pathPieces)
        if(~isempty(pathPieces{i}))
            absolutePath = [absolutePath '.' pathPieces{i}];
        else
            % invalid path detected
            tf = 0;
            return;
        end
    end
    
    % Basic checks to see if this seems to be a control variable:
    if(~structFieldPathExists(settings,absolutePath))
        tf = 0;
    elseif(~eval(sprintf('iscell(%s)',absolutePath)))
        tf = 0;
    elseif(eval(sprintf('length(%s) < 1',absolutePath)))
        tf = 0;
    else
        tf = 1;
    end

end