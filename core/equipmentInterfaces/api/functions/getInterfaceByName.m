% This class is a part of the Equipment Control API
% Benjamin Hershberg, 2020
%
% Usage: 
%
%   [id, index] = getInterfaceByName( name )
%
%   + description: get the id of a named interface
%   + inputs:   name - the unique name of the interface
%   + outputs:  id - the unique id of the interface
%               index - the index of the interface in the underlying (cell
%               array) data structure that stores the equipment interface
%               data.
%
function [id, index] = getInterfaceByName( name )

    global settings;
    
    found = false;
    
    for i = 1:length(settings.lab.interfaces)        
        if(isequal(settings.lab.interfaces{i}.name,name))
            id = settings.lab.interfaces{i}.id;
            index = i;
            found = true;
            continue;
        end
    end
    
    if(~found)
        id = -1;
        warning('Could not find interface by that name');
    end

end

