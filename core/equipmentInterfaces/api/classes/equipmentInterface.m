% This class is a part of the Equipment Control API
% Benjamin Hershberg, 2020
%
% Description: This class can be used to access and modify items in the 
% equipment interface sub-system.
%
% INITIALIZE:
%
%   There are three options for chossing the interface to connect to,
%   supporting both hard-wired, or interactive/user-defined:
%
%   interface = equipmentInterface();
%       + input: none (will ask the user interactively what to select)
%       + output: interface - equipment interface object
%
%   interface = equipmentInterface(interfaceName);
%       + input: interfaceName - a string of the interface name to access
%       + output: interface - equipment interface object
%
%   interface = equipmentInterface('askUser', promptString);
%       + input: promptString - optional, selection list prompt string
%       + output: interface - equipment interface object
%
%
% METHODS:
%
%   ++ apply:
%
%     interface.apply();
%       + description: updates the GUI with the interface's properties and
%           calls the interface's apply function (same as clicking the apply
%       button in the GUI).
%       + inputs:   none
%       + outputs:  none
%
%   ++ getProperty:
%
%     [propertyValue, tf] = interface.getProperty(propertyName);
%       + description: fetches the current value of the named property.
%       + inputs:   none
%       + outputs:  propertyValue - the value requested, or 0 if the
%                       property does not exist
%                   tf - 1 if the requested property exists, 0 otherwise
% 
%   ++ listProperties:
%
%     [propertyStruct, propertyNames, propertyValues] = interface.listProperties();
%       + description: lists all properties of the interface.
%       + inputs:   none
%       + outputs:  propertyStruct - structure of all properties & values
%                   propertyNames - cell array of all property names
%                   propertyValues - cell array of all property values
%
%   ++ propertyExists:
%
%     [tf] = interface.propertyExists(propertyName);
%       + description: determines if the interface contains a property.
%       + inputs:   propertyName - the name of the property to examine
%       + outputs:  tf - 1 if the property exists, 0 otherwise
%
%   ++ redraw:
%
%     interface.redraw();
%       + description: redraw the GUI. This will make any changes to the
%           interface's property values appear on-screen in the GUI.
%       + inputs:   none
%       + outputs:  none
%
%   ++ setProperty:
%
%     [previousValue] = interface.setProperty(propertyName, propertyValue);
%       + description: writes propertyValue to the interface's property of
%           propertyName. This only modifies the underlying data structure, it 
%           does not appear in the GUI or apply to the physical instrument. For 
%           those things, see the redraw(), apply(), setPropertyAndApply(...)
%           methods of this class, and also the applyAllInterfaces() function.
%       + inputs:   propertyName - the property name to write into
%                   propertyValue - the value to write
%       + outputs:  prevousValue - the value that is overwritten
%
%   ++ setPropertyAndApply:
%
%     [previousValue] = interface.setPropertyAndApply(propertyName, propertyValue);
%       + description: the same as calling setProperty (see above) followed
%           by apply (see above).
%
% EXAMPLE USE:
%
% % create an interface object:
%   equip = equipmentInterface('askUser','Select core supply:');
% 
% % update some values to be sent to the physical instrument:
%   equip.setProperty('voltage',0.5);
%   equip.setProperty('measure_current',true);
% 
% % redraw the GUI panel and update the physical instrument:
%   equip.apply;
% 
% % fetch some information returned by the phsyical instrument:
%   I_vdda = equip.getProperty('current_measured');
%
classdef equipmentInterface < handle

    properties
        interfaceId;
    end

    methods
        function self = equipmentInterface(interfaceName, promptString)
            if(nargin < 2)
                promptString = 'Select an equipment interface:'; 
            end
            if(nargin < 1)
               interfaceName = 'askUser'; 
            end
            if(isequal(interfaceName,'askUser'))
                [~, id] = selectInterface(promptString);
                while(isempty(id))
                    uiwait(msgbox('You must select something. Let''s try again..'));
                    [~, id] = selectInterface(promptString);
                end
                self.interfaceId = id{1};
            else
                self.interfaceId = getInterfaceByName(interfaceName);
            end
        end

        function [propertyStruct, propertyNames, propertyValues] = listProperties(self)
            propertyStruct = getInterface(self.interfaceId);
            fnames = fieldnames(propertyStruct);
            propertyNames = {};
            propertyValues = {};
            for i = 1:length(fnames)
                propertyNames{end+1} = fnames{i};
                propertyValues{end+1} = propertyStruct.(fnames{i});
            end
        end

        function [propertyValue, tf] = getProperty(self, propertyName)
            [propertyValue, tf] = getInterfaceProperty(self.interfaceId, propertyName);
        end
        
        function [tf] = propertyExists(self, propertyName)
            [~, tf] = getInterfaceProperty(self.interfaceId, propertyName);
        end

        function previousValue = setProperty(self, propertyName, propertyValue)
            previousValue = setInterfaceProperty(self.interfaceId, propertyName, propertyValue);
        end

        function previousValue = setPropertyAndApply(self, propertyName, propertyValue)
            previousValue = self.setProperty(propertyName, propertyValue);
            self.apply();
        end

        function apply(self)
            self.redraw();
            applyInterface(self.interfaceId); 
        end
        
        function redraw(self)
            redrawInterfaces;
        end
    end
end