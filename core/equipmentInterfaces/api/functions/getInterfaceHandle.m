% This class is a part of the Equipment Control API
% Benjamin Hershberg, 2020
%
% Usage: 
%
%   handle = getInterfaceHandle( id )
%
%   + description: Returns the handle for the GUI object corresponding to a
%                  	requested equipment interface.
%   + inputs:   id - the id of the interface
%   + outputs:  handle - the graphical object handle of the panel that
%                   contains the interface requested.
%
function handle = getInterfaceHandle( id )

    global tabEquipmentControl;
    
    idx = getInterfaceIndex(id);
    handle = tabEquipmentControl.UserData.childrenProfiles{idx};
    

end

