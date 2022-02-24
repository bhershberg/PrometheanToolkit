% This class is a part of the Equipment Control API
% Benjamin Hershberg, 2020
%
% Usage: 
%
%   [id, index] = getInterfaceByType( type )
%
%   + description: get the id of a named interface
%   + inputs:   type - the "type" of the interface as defined by its 
%                   "create interface" function. E.g. 'Tek 123XYZ Voltage
%                   Source'.
%   + outputs:  id - cell array of the interface ids matching the query
%               index - integer array of indexes of matching interfaces in
%                   the underlying equipment interface data structure.
%
function [id, index] = getInterfaceByType( type )

    global settings;
    
    found = false;
    
    id = {};
    index = [];
    
    for i = 1:length(settings.lab.interfaces)        
        if(isequal(settings.lab.interfaces{i}.type,type))
            id{end+1} = settings.lab.interfaces{i}.id;
            index(end+1) = i;
            found = true;
        end
    end
    
    if(~found)
        id = -1;
%         interface_index = -1;
%         interface_handle = [];
        warning('Could not find interface by that name');
    end

end
