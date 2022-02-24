% This function is a part of the Control Variable API
% Benjamin Hershberg, 2020
%
% ==== To add a Digital Control Variable to the system: ===================
% 
% Usage:
%
%   success = createControlVariable(pathString, value, width, min, max, docu);
% 
% REQUIRED INPUTS:
%   pathString:     string - the path in the control hierarchy where the variable will be created.
%   value:          integer - value of the digital control
%   width:          integer - bit-width of the physical digital control register
%   min:            integer - min value that is allowed to be freely set by user
%   max:            integer - max value that is allowed to be freely set by user
%   docu:           string - documentation describing the digital control variable
% OUTPUTS:
%   success:        1 if the variable was successfully created and 0 otherwise.
%
%
% ==== To add a Soft Variable to the system: ==============================
% 
% Usage:
%
%   success = createControlVariable(pathString, value, docu);
% 
% REQUIRED INPUTS:
%   pathString:     string - the path in the control hierarchy where the variable will be created.
%   value:          real or string - can be any real number or a string
%   docu:           string - documentation describing the soft variable
% OUTPUTS:
%   success:        1 if the variable was successfully created and 0 otherwise.
function success = createControlVariable(pathString, value, param1, param2, param3, param4)

    global settings;
    
    success = 0;

    [absolutePath, tf] = getAbsoluteControlVariablePath(pathString);
    if(tf)
       warning('Nothing created. A control variable already exists at this location. Variable: ''%s''.',pathString);
       return; 
    end
    
    if(nargin == 6)
        
       width = param1;
       min = param2;
       max = param3;
       docu = param4;
       
       if(~isnumeric(value) || floor(value) ~= value)
           warning('Digital Control Variable field ''value'' must be an integer.');
           return;
       end
       if(~isnumeric(width) || floor(width) ~= width || width == 0)
           warning('Digital Control Variable field ''width'' must be a non-zero integer.');
           return;
       end
       if(~isnumeric(min) || floor(min) ~= min)
           warning('Digital Control Variable field ''min'' must be an integer.');
           return;
       end
       if(~isnumeric(max) || floor(max) ~= max)
           warning('Digital Control Variable field ''max'' must be an integer.');
           return;
       end
       if(~ischar(docu))
           warning('Digital Control Variable field ''documentation'' must be a string.');
           return;
       end
       
       newVar = {value, width, min, max, docu};
       eval(sprintf('%s = newVar;',absolutePath));
       success = 1;
       
    elseif(nargin == 3)
       
       docu = param1;
       
       if(~isnumeric(value) && ~ischar(value))
           warning('Soft Variable field ''value'' must be either numeric or string.');
           return;
       end
       if(~ischar(docu))
           warning('Soft Variable field ''documentation'' must be a string.');
           return;
       end
       
       newVar = {value, docu};
       eval(sprintf('%s = newVar;',absolutePath));
       success = 1;
       
    else
        
        warning('Unsupported variable type.');
        
    end

end