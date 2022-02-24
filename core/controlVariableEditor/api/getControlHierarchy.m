% This function is a part of the Control Variable API
% Benjamin Hershberg, 2020
%
% Usage:
% 
%   ctrlStruct = getControlHierarchy( pathString )
% 
% OPTIONAL INPUTS:
%   pathString:     string - the path in the control variable hierarchy to
%                       fetch the control variable hierarchy starting from. 
%                       Does not matter if this is an absolute or relative path,
%                       both are accepted.
% OUTPUTS:
%   ctrlStruct:     structure containing the raw control variable heiarachy
%                       data from the starting point of the pathString and
%                       below.
%   success:        1 if a valid ctrlStruct was returned, 0 otherwise
%
% EXAMPLES:
%   allControlData = getControlHierarchy;
%   subSetOfControlData = getControlHierarchy('digital.CH1');
%
function [ctrlStruct, tf] = getControlHierarchy( pathString )

    global settings;
    ctrlStruct = struct;
    
    if(nargin < 1) 
        pathString = getGlobalOption('controlVariablePath');
    end
    
    absolutePath = getAbsoluteControlVariablePath(pathString);
    
    try
        eval(sprintf('ctrlStruct = %s;',absolutePath));
        tf = 1;
    catch 
        warning('invalid path');
        tf = 0;
    end

end