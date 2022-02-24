% This class is a part of the Equipment Control API
% Benjamin Hershberg, 2020
%
% Usage: 
%
%   state = getInterface( id )
%
%   + description: Gets the underlying data structure that defines the
%       specified equipment interface
%   + inputs:   id - the id of the interface
%   + outputs:  state - the interface state data (what actually gets stored
%                   in the state files saved to disk) that the GUI and API 
%                   operate on.
%
function state = getInterface( id )

    global settings;
    
    idx = getInterfaceIndex(id);
    state = settings.lab.interfaces{idx};
    
end

