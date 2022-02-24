% This function is a part of the Control Variable API
% Benjamin Hershberg, 2020
%
% Usage:
% 
%   [value, info, success] = getControlVariable(pathString)
% 
% REQUIRED INPUTS:
%   pathString:     string - the path of the variable to read.
% OUTPUTS:
%   value:          the value of the variable requested
%   info:           a structure with more information about the variable
%                   - for a digital control variable, this contains:
%                       - info.value - the integer variable value
%                       - info.width - the digital register bit-width
%                       - info.min - the minimum allowed value
%                       - info.max - the maximum allowed value
%                       - info.docu - the documentation description
%                       - info.type - the string 'Digital Control Variable'
%                   - for a soft variable, this contains:
%                       - info.value - the numeric or string variable value
%                       - info.docu - the documentation description
%                       - info.type - the string 'Soft Variable'
%   success:        1 if the read was successful, 0 otherwise
function [value, info, success] = getControlVariable(pathString)

    global settings;
    
    info = struct;
    success = 0;

    [absolutePath, tf] = getAbsoluteControlVariablePath(pathString);

    if(~tf)
        value = [];
        info = struct;
        return;
    end
    
    var = {};
    eval(sprintf('var = %s;',absolutePath));
    
    % If a soft variable is missing documentation, let's spoof it:
    if(iscell(var) && length(var) < 2)
        var{2} = '';
    end
    % If a digital control variable is missing documentation, let's spoof it:
    if(iscell(var) && length(var) == 4)
        var{5} = '';
    end
    
    if(iscell(var) && length(var) >= 5)
        value = var{1};
        info.value = value;
        info.width = var{2};
        info.min = var{3};
        info.max = var{4};
        info.docu = var{5};
        info.type = 'Digital Control Variable';
        success = 1;
    elseif(iscell(var) && length(var) < 5)
        value = var{1};
        info.value = value;
        info.docu = var{2};
        info.type = 'Soft Variable';
        success = 1;
    else
        value = [];
        info.error = 'unsupported variable type';
        info.type = 'Unknown';
        success = 0;
    end
    
end