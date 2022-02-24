% This function is a part of the Control Variable API
% Benjamin Hershberg, 2020
%
% Usage:
% 
%   [success] = setControlVariable(pathString, value)
% 
% REQUIRED INPUTS:
%   pathString:     string - the path of the variable to be updated
%   value:          the value to be written
% OUTPUTS:
%   success:        1 if the variable was successfully updated with the requested value, 0 otherwise
function [success] = setControlVariable(pathString, value)

    global settings;
    
    success = 0;

    [absolutePath, tf] = getAbsoluteControlVariablePath(pathString);
    if(~tf)
        warning('Invalid variable path ''%s''.',pathString);
        return;
    end
    
    var = {};
    eval(sprintf('var = %s;',absolutePath));
    
    if(~iscell(var))
        warning('The data at ''%s'' is not a supported variable type.',pathString);
        return;
    end
    
    if(length(var) < 5 )
        eval(sprintf('%s{1} = value;', absolutePath));
        success = 1;
    elseif(length(var) >= 5)
        if(~isnumeric(value))
            warning('Requested write value is not an integer. Digital control variables must have integer values. Variable: ''%s''.'.',pathString);
            return;
        end
        if(value ~= round(value))
            value = round(value);
            warning('Digital control variables must be integer values. Rounding to %d. Variable: ''%s''.',value, pathString);
        end
        if(value < var{3})
            warning('Digital control variable value %d is less than the min value of %d. Setting to %d. Variable: ''%s''.',value, var{3}, var{3}, pathString);
            value = var{3};
        end
        if(value > var{4})
            warning('Digital control variable value %d is more than the max value of %d. Setting to %d. Variable: ''%s''.',value, var{4}, var{4}, pathString);
            value = var{4};
        end
        eval(sprintf('%s{1} = value;', absolutePath));
        success = 1;
    end
    
end