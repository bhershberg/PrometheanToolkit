% This function is a part of the Control Variable API
% Benjamin Hershberg, 2020
%
% Usage:
% 
%   [relativePath, tf] = getRelativeControlVariablePath(pathString)
% 
% REQUIRED INPUTS:
%   pathString:     string - the path in the control variable hierarchy to
%                       convert to a relative path. Does not matter if
%                       this is an absolute or relative path to begin with,
%                       both are accepted.
% OUTPUTS:
%   absolutePath:   string - the input path, converted to relative path.
%                       More specifically, relative to the base path defined 
%                       by getGlobalOption('controlVariablePath');
%   success:        1 if a valid path was returned, 0 otherwise
function [pathString, tf] = getRelativeControlVariablePath(pathString)
    
    global settings;

    basePath = getGlobalOption('controlVariablePath','settings.ctrl');
    idx = strfind(pathString,basePath);
    
    if(~isempty(idx) && idx == 1 && ~isempty(basePath))
       pathString = pathString(length(basePath)+2:end); 
    end
    
    if(structFieldPathExists(settings,sprintf('%s.%s',basePath,pathString)))
        tf = 1;
    else
        tf = 0;
    end
    
end