% This function is a part of the File Manager API
% Benjamin Hershberg, 2020
%
% Usage:
% 
%   tf = deleteGlobalOption(optionName);
% 
%   + description: delete a global option
%   + inputs:   optionName - the name of the option to remove/delete
%   + outputs:  tf - 1 if option was found and removed, 0 otherwise
%
function tf = deleteGlobalOption(optionName)

    global settings;
    
    if(isfield(settings.options,optionName))
        settings.options = rmfield(settings.options,optionName);
        tf = 1;
    else
        tf = 0;
    end

end