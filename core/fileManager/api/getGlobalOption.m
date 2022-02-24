% This function is a part of the File Manager API
% Benjamin Hershberg, 2020
%
% Usage:
% 
%   [value, options, tf] = getGlobalOption(optionName);
% 
%   + description: fetch the value of a 'global' option saved in the
%                   state data
%   + inputs:   optionName - the name of the option to fetch
%               defaultValue - optional input. If the option 'optionName'
%                   doesn't exist, it will be created and set to this value
%   + outputs:  value - the value of the requested option, or empty [] if
%                   the option does not exist
%               options - the entire globalOptions data structure
%               tf - 1 if the requested options exists, 0 otherwise
%
function [value, allOptions, tf] = getGlobalOption(optionName, defaultValue)

    global settings;
    if(~structFieldPathExists(settings,'settings.options'))
        settings.options = struct;
    end
    
    allOptions = settings.options;
    
    if(~isfield(allOptions,optionName) && nargin < 2)
        value = [];
        tf = 0;
    elseif(~isfield(allOptions,optionName) && nargin >= 2)
        setGlobalOption(optionName, defaultValue);
        [value, allOptions, tf] = getGlobalOption(optionName);
    else    
        value = allOptions.(optionName);
        tf = 1;
    end

end