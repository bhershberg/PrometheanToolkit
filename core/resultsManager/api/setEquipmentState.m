% This function is a part of the Results Manager API
% Benjamin Hershberg, 2020
%
% Usage:
% 
%   setEquipmentState(equipmentState);
% 
%   + description: overwrite the current equipment control state
%   + inputs: equipmentState - the state to load
%   + outputs: none
%
function setEquipmentState(equipmentState)

    if(isfield(equipmentState,'stateType'))
        equipmentState = equipmentState.stateData;
    end

    global settings;
    backup = getEquipmentState;
    try
        settings.lab.interfaces = equipmentState;
        redrawInterfaces;
    catch
        settings.lab.interfaces = backup.data;
        redrawInterfaces;
        warning('Failed to set new Equipment State. Reverting to original');
    end

end