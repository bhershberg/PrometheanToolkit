% This function is a part of the Results Manager API
% Benjamin Hershberg, 2020
%
% Usage:
% 
%   equipmentState = getEquipmentState();
% 
%   + description: fetch a copy of the current equipment interface state. This
%                   can be useful for attaching to saved results for traceability.
%   + inputs: none
%   + outputs: equipmentState - the current equipment interface state data
%
function equipmentState = getEquipmentState()

    global settings;
    
    equipmentState.stateType = 'Equipment Interfaces';
    equipmentState.restoreFunction = @setEquipmentState;
    equipmentState.stateData = settings.lab.interfaces;

end