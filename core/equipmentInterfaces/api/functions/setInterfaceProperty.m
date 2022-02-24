% This class is a part of the Equipment Control API
% Benjamin Hershberg, 2020
%
% Usage: 
%
%   previousValue = setInterfaceProperty(interfaceId, propertyName, propertyValue)
%
%   + description: sets a new value to the specified property field in an
%                   equipment interface
%   + inputs:   id - the id of the equipment interface
%               propertyName - the name of the property to write to
%               propertyValue - the value to write
%   + outputs:  prevousValue - the previous value of this property, which
%                   will be overwritten
%
function previousValue = setInterfaceProperty(id, propertyName, propertyValue)

    global settings;
    
    idx = getInterfaceIndex(id);
    previousValue = settings.lab.interfaces{idx}.(propertyName);
    settings.lab.interfaces{idx}.(propertyName) = propertyValue;

end