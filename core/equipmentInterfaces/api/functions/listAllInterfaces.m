% This class is a part of the Equipment Control API
% Benjamin Hershberg, 2020
%
% Usage: 
%
%   [names, IDs] = listAllInterfaces()
%
%   + description: Lists all equipment interfaces
%   + inputs:   none
%   + outputs:  names - a cell array of the interface names
%               ids - a cell array of the interface ids
%
function [names, IDs] = listAllInterfaces()

    iGroup = equipmentInterfaceGroup();
    iGroup.addAllWithProperty('name');
    [names, IDs] = iGroup.listInterfaces();

end