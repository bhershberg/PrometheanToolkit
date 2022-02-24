% This class is a part of the Equipment Control API
% Benjamin Hershberg, 2020
%
% Usage: 
%
%   [name, index] = getInterfaceName(id)
%
%   + description: returns the user-defined name of the requested 
%                   equipment interface
%   + inputs:   id - the id of the equipment interface
%   + outputs:  name - the name of the requested equipment interface
%               index - the index of the interface in the underlying (cell
%               array) data structure that stores the equipment interface
%               data.
%
function [name, index] = getInterfaceName(id)

    global settings;
    
    found = false;
    
    for i = 1:length(settings.lab.interfaces)        
        if(isequal(settings.lab.interfaces{i}.id,id))
            index = i;
            name = settings.lab.interfaces{i}.name;
            found = true;
            continue;
        end
    end
    
    if(~found)
        name = 'not found';
        index = -1;
        warning('Could not find interface by that name');
    end

end
