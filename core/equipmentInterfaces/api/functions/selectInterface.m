% This class is a part of the Equipment Control API
% Benjamin Hershberg, 2020
%
% Usage: 
%
%   [names, ids] = selectInterface(promptString, selectMultiple)
%
%   + description: Opens an interactive list dialog box that allows the 
%       user to interactively select one or more equipment interfaces.
%   + inputs:   promptString - optional text string that will be shown to
%                   the user (e.g. 'please select the core VDD power supply:')
%               selectMultiple - optional parameter, if = 1, allows
%                   multiple interfaces to be selected and returned, or 0
%                   to only allow a single item to be selected. By default,
%                   this is set to 0 (single select)
%   + outputs:  name - a cell array listing the name(s) of the interface(s)
%                   selected by the user
%               id - a cell array listing the id(s) of the interface(s)
%                   selected by the user
%
function [names, ids] = selectInterface(promptString, selectMultiple)

    if(nargin < 1)
        promptString = 'Select an equipment interface:';
    end
    if(nargin < 2)
        selectMultiple = false;
    end
    if(selectMultiple)
        selectionMode = 'multiple';
    else
        selectionMode = 'single';
    end

    iGroup = equipmentInterfaceGroup();
    iGroup.addAllWithProperty('name');
    [allNames, allIDs] = iGroup.listInterfaces;
    
    [idx,tf] = listDialog(promptString,allNames,[],selectionMode);

    if(~tf)
        ids = {};
        names = {};
        return;
    else
        ids = allIDs(idx);
        names = allNames(idx);
    end
    
end