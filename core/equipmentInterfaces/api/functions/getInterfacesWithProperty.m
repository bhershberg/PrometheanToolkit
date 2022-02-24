% This class is a part of the Equipment Control API
% Benjamin Hershberg, 2020
%
% Usage: 
%
%   [ids, indexes, values] = getInterfacesWithProperty(property, value)
%
%   + description: get all interfaces with a certain property. Note that
%                   this can be done better and cleaner by using the
%                   equipmentInterfaceGroup object class instead.
%   + inputs:   propertyName - the name of the property to search for
%               propertyValue - optional, if specified will also require
%                   that the value of the property match propertyValue
%   + outputs:  ids - cell array of the ids of all equipment interfaces that contain this
%                   propertyName (and optionally, are also set to propertyValue)
%               indexes - cell array of the indexes of the matching equipment interfaces
%                   in the underlying cell array data structure where the
%                   equipment interface data is stored
%               values - cell array of the values of propertyName in the matching 
%                   equipement interfaces
%
function [ids, indexes, values] = getInterfacesWithProperty(propertyName, propertyValue)

    global settings;
    
    ids = {};
    indexes = {};
    values = {};
    
    for i = 1:length(settings.lab.interfaces)
       if(isfield(settings.lab.interfaces{i},propertyName))
           if(nargin > 1 && ~isequal(settings.lab.interfaces{i}.(propertyName),propertyValue))
               continue;
           end
           ids{end+1} = settings.lab.interfaces{i}.id;
           indexes{end+1} = i;
           values{end+1} = settings.lab.interfaces{i}.(propertyName);
       end
    end

end