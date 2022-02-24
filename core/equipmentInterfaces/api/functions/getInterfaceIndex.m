% This class is a part of the Equipment Control API
% Benjamin Hershberg, 2020
%
% Usage: 
%
%   [ index ] = getInterfaceIndex( interface_id )
%
%   + description: returns the index of the requested equipment interface
%                   element, denoting its location in the underlying cell
%                   array data structure that stores the equipment
%                   interface data.
%   + inputs:   id - the id of the equipment interface
%   + outputs:  index - the index of the interface in the underlying (cell
%               array) data structure that stores the equipment interface
%               data.
%
function [ index ] = getInterfaceIndex( id )

    global settings;
    
    for i = 1:length(settings.lab.interfaces)
        % just in case the interface didn't make its own id, let's make one
        % for it:
        if(~isfield(settings.lab.interfaces{i},'id'))
            settings.lab.interfaces{i}.id = DataHash(now);
        end
        
        if(isequal(settings.lab.interfaces{i}.id,id))
            index = i;
            continue;
        end
    end


end

