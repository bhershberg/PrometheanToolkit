% This class is a part of the Equipment Control API
% Benjamin Hershberg, 2020
%
% Usage: 
%
%   [value, tf] = getInterfaceProperty(id, propertyName)
%
%   + description: returns the value of the property for the specified
%                   equipment interface
%   + inputs:   id - the id of the equipment interface
%               propertyName - the name of the property to fetch
%   + outputs:  value - the value of the property requested, or empty if it
%                   does not exist.
%               tf - 1 if the property exists, 0 otherwise
%
function [value, tf] = getInterfaceProperty(id, propertyName)

    global settings;
        
    idx = getInterfaceIndex(id);
    
    if(~isfield(settings.lab.interfaces{idx},propertyName))
        tf = 0;
        value = [];
    else
        tf = 1;
        value = settings.lab.interfaces{idx}.(propertyName);
    end
    
end