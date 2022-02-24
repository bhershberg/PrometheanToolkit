% This function is a part of the File Manager API
% Benjamin Hershberg, 2020
%
% Usage:
% 
%   options = setGlobalOption(optionName, value);
% 
%   + description: update the value of a 'global' option saved in the
%                   state data
%   + inputs:   optionName - the name of the option to update
%               value - the value to write to the specified option field
%   + outputs:  options - the entire globalOptions data structure
%
function options = setGlobalOption(optionName, value)

    global settings;
    
    settings.options.(optionName) = value;
    options = settings.options;

end