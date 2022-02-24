% This class is a part of the Equipment Control API
% Benjamin Hershberg, 2020
%
% Description: This class allows for the access and control of a group of 
% related equipment interfaces that share some sub-set of properties in
% common.
%
% INITIALIZE:
%
%   interfaceGroup = equipmentInterfaceGroup();
%
% To add interfaces to the group see the 'add' and 'addAllWithProperty'
% methods described below.
%
%
% METHODS:
%
%   ++ add:
%
%     [namesAdded] = interfaceGroup.add();
%       + description: behavior is identical to interfaceGroup.add('askUser')
%           as described below.
%       + inputs:   none
%       + outputs:  names, a cell list of the interface names added
% 
%     [namesAdded] = interfaceGroup.add(interfaceName);
%       + description: add named equipment interfaces to the group.
%       + inputs:   interfaceName - string or cell array of interface names
%                       to be added
%       + outputs:  names, a cell list of the interface names added
% 
%     [namesAdded] = interfaceGroup.add('askUser', promptString)
%       + description: interactively add equipment interfaces to the group.
%       + inputs:   promptString - an optional string for custom prompt to
%                       user in the interactive selection dialog.
%       + outputs:  names, a cell list of the interface names added
%
%   ++ addAllWithProperty:
%
%   [namesAdded] = interfaceGroup.addAllWithProperty(propertyName, propertyValue);
%       + description: add all interfaces registered in the system that
%           contain the property 'propertyName', and optionally also having
%           the value 'propertyValue'.
%       + inputs:   propertyName - string name of the property to look for.
%                   propertyValue - optional, value of the property to
%                       match. If this parameter is set, only interfaces
%                       matching both the name and value will be added to
%                       the group.
%       + outputs:  namesAdded - cell list of interface names that were
%                       added.
%
%   ++ apply:
%
%   interfaceGroup.apply();
%       + description: updates the GUI with the interface's properties and
%           calls the interface's apply function (same as clicking the apply
%       + inputs:   none
%       + outputs:  none
%
%   ++ getProperty:
%
%   [values, names] = interfaceGroup.getProperty(propertyName);
%       + description: fetches the values of an interface property for all
%           interfaces in the group.
%       + inputs:   propertyName - name string of the property to fetch
%       + outputs:  values - cell list of property values for each
%                       interface in the group, ordered according to the 
%                       'names' output. If the requested propertyName is
%                       not found for the given interface in the group, a
%                       null value will be returned (i.e. []).
%                   names - ordered cell list of interface names in the
%                       group indicating what values go with what interface
%                       names.
%
%   ++ listInterfaces:
%
%   [names, IDs] = interfaceGroup.listInterfaces();
%       + description: lists the the interfaces contained in the group.
%       + inputs:   none
%       + outputs:  names - cell list of interface names
%                   IDs - cell list of interface IDs ordered according to
%                       the 'names' output
%
%   ++ listProperties:
%
%   [commonProperties, differentProperties] = interfaceGroup.listProperties();
%       + description: lists all interface properties that are
%           shared/common amongst all interfaces in the group.
%       + inputs:   none
%       + outputs:  commonProperties - cell list of interface properties
%                       that are found in all interfaces in the group.
%                   differentProperties - cell list of interface properties
%                       that are only found in some interfaces of the
%                       group, but not all of them.
%
%   ++ redraw:
%
%   interfaceGroup.redraw();
%       + description: redraw the GUI. This will make any changes to the
%           interface's property values appear on-screen in the GUI.
%       + inputs:   none
%       + outputs:  none
%
%   ++ remove:
%
%   [namesRemoved] = interfaceGroup.remove(interfaceName);
%       + description: remove an interface or set of interfaces from the
%           group.
%       + inputs:   interfaceName - string or cell list of interface names
%                       to remove for one or multiple interfaces respectively.
%       + outputs:  namesRemoved - cell list of the name that was
%                       removed, which should be interfaceName at cell
%                       index 1, or if nothing was removed, then an empty
%                       cell array.
%
%   ++ removeAll:
%
%   [namesRemoved] = interfaceGroup.removeAll();
%       + description: remove all interfaces from the group.
%       + inputs:   none
%       + outputs:  namesRemoved - cell list of the interface names that
%                       were removed.
%
%   ++ removeAllWithoutProperty:
%
%   [namesRemoved] = interfaceGroup.removeAllWithoutProperty(propertyName);
%       + description: remove all interfaces that do not contain the 
%           specified property(ies) from the group.
%       + inputs:   propertyName - string name or cell list of property(ies)
%                       to test for.
%       + outputs:  namesRemoved - cell list of the interface names that
%                       were removed.
%
%   ++ removeAllWithProperty:
%
%   [namesRemoved] = interfaceGroup.removeAllWithProperty(propertyName);
%       + description: remove all interfaces that contain the specified 
%            property(ies) from the group.
%       + inputs:   propertyName - string name or cell list of property(ies)
%                       to test for.
%       + outputs:  namesRemoved - cell list of the interface names that
%                       were removed.
%
%   ++ setProperty:
%
%   [previousValues, names] = interfaceGroup.setProperty(propertyName, propertyValue, interfaceName);
%       + description: write a new value to a specified property for all
%           interfaces in the group.
%       + inputs:   propertyName - string name of the property to
%                       overwrite. If this property does not exist for a
%                       given interface in the group, that interface will be skipped.
%                   propertyValue - value to set to the property. If
%                       an 'interfaceName' cell list is also provided, then 
%                       this must be a cell list too.
%                   interfaceName - optional, ordered cell list of interfaces
%                       to update. Requires that propertyValue be a cell
%                       list of the same length matching the same order.
%                       Note that this will write to any and all interfaces
%                       specified by interfaceName list, even if they are not
%                       contained in the group.
%       + outputs:  previousValues - ordered cell list of the old values that were
%                       overwritten according to the ordering denoted by
%                       the 'names' output.
%                   names - ordered cell list of interface names that
%                       indicate the ordering of the previousValues returned.
%
%   ++ setPropertyAndApply:
%
%   [previousValues, names] = setPropertyAndApply(self, propertyName, propertyValue, interfaceName)
%       + description: a shortcut/macro that calls the 'setProperty' method
%            and then the 'apply' method. 
%       + inputs:   see 'setProperty' method
%       + outputs:  see 'setProperty' method

% EXAMPLE USE:
%
% % create an interface group object:
%   iGroup = equipmentInterfaceGroup();
% 
% % add all of the Keysight B2962A voltage sources to the group:
%   iGroup.addAllWithProperty('type','Keysight B2962A Voltage Source');
%
% % ask the user if there is anything else they want to add:
%   iGroup.add('askUser','Add anything else?');
% 
% % make sure that all the interfaces in the group have the properties that
% % we need to modify:
%   iGroup.removeAllWithoutProperty({'voltage','measure_current','enable','filter'});
%
% % update some values to be sent to the physical instrument:
%   iGroup.setProperty('enable',true);
%   iGroup.setProperty('filter',true);
%   iGroup.setProperty('measure_mode','4 wire');
%   iGroup.setProperty('measure_current',true);
% 
% % redraw the GUI panel and update the physical instrument:
%   iGroup.apply;
% 
% % fetch some information returned by the phsyical instrument:
%   [I_vdda, names] = iGroup.getProperty('current_measured');
% 
classdef equipmentInterfaceGroup < handle

    properties
        interfaceId;
    end
    
    methods
        
        function [self] = equipmentInterfaceGroup()
            self.interfaceId = {};
        end

        function [namesAdded] = add(self, interfaceName, promptString)
            namesAdded = {};
            if(nargin < 2)
                interfaceName = 'askUser';
            end
            if(nargin < 3)
                promptString = 'Select the equipment interface(s):'; 
            end
            idList = {};
            if(isequal(interfaceName,'askUser'))
                [~,idList] = selectInterface(promptString, true);
                while(isempty(idList))
                    uiwait(msgbox('You must select something. Let''s try again..'));
                    [~,idList] = selectInterface(promptString, true);
                end
            elseif(ischar(interfaceName))
                idList{1} = getInterfaceByName(interfaceName);
            elseif(iscell(interfaceName))
                for i = 1:length(interfaceName)
                    idList = getInterfaceByName(interfaceName{i});
                end
            else
                warning('Unknown input type. Nothing added.');
                return;
            end
            if(ischar(idList))
                tmp = idList;
                idList = {};
                idList{1} = tmp;
            end
            for i = 1:length(idList)
                self.interfaceId{end+1} = idList{i};
                namesAdded{i} = getInterfaceName(idList{i});
            end
            self.interfaceId = unique(self.interfaceId);
        end

        function [namesAdded] = addAllWithProperty(self, propertyName, propertyValue)
            namesAdded = {};
            if(nargin > 2)
                idList = getInterfacesWithProperty(propertyName, propertyValue);
            else
                idList = getInterfacesWithProperty(propertyName);
            end
            for i = 1:length(idList)
                self.interfaceId{end+1} = idList{i};
                namesAdded{i} = getInterfaceName(idList{i});
            end
            self.interfaceId = unique(self.interfaceId);
        end

        function [namesRemoved] = remove(self, interfaceName)
            originalNames = self.listInterfaces;
            if(ischar(interfaceName))
                i = 1;
                id = getInterfaceByName(interfaceName);
                while i <= length(self.interfaceId)
                    if(isequal(self.interfaceId{i}, id))
                        self.interfaceId(i) = [];
                        i = i-1;
                    end
                    i = i+1;
                end
            elseif(iscell(interfaceName))
                for i = 1:length(interfaceName)
                    self.remove(interfaceName{i});
                end
            end
            namesRemoved = setdiff(originalNames,self.listInterfaces);
        end

        function [namesRemoved] = removeAll(self)
            namesRemoved = self.listInterfaces;
            self.interfaceId = {}; 
        end
        
        function [namesRemoved] = removeAllWithoutProperty(self, propertyName)
            originalNames = self.listInterfaces;
            if(iscell(propertyName))
                for i = 1:length(propertyName)
                    self.removeAllWithoutProperty(propertyName{i});
                end
            else
                i = 1;
                while i <= length(self.interfaceId)
                    [~, tf] = getInterfaceProperty(self.interfaceId{i}, propertyName);
                    if(~tf)
                        self.interfaceId(i) = [];
                        i = i-1;
                    end
                    i = i+1;
                end
            end
            namesRemoved = setdiff(originalNames,self.listInterfaces);
        end
        
        function [namesRemoved] = removeAllWithProperty(self, propertyName)
            originalNames = self.listInterfaces;
            if(iscell(propertyName))
                for i = 1:length(propertyName)
                    self.removeAllWithProperty(propertyName{i});
                end
            else
                i = 1;
                while i <= length(self.interfaceId)
                    [~, tf] = getInterfaceProperty(self.interfaceId{i}, propertyName);
                    if(tf)
                        self.interfaceId(i) = [];
                        i = i-1;
                    end
                    i = i+1;
                end
            end
            namesRemoved = setdiff(originalNames,self.listInterfaces);
        end
        
        function [commonProperties, differentProperties] = listProperties(self)
            commonProperties = {};
            differentProperties = {};
            if(length(self.interfaceId) < 1)
                return;
            else
                firstInterface = getInterface(self.interfaceId{1});
                commonProperties = fieldnames(firstInterface);
                allProperties = commonProperties;
            end
            if(length(self.interfaceId) > 1)
                for i = 2:length(self.interfaceId)
                    nextInterface = getInterface(self.interfaceId{i});
                    nextFnames = fieldnames(nextInterface);
                    commonProperties = intersect(commonProperties,nextFnames);
                    allProperties = union(allProperties, nextFnames);
                end
            end
            differentProperties = setxor(commonProperties,allProperties);
        end
        
        function [names, IDs] = listInterfaces(self)
            names = {};
            for i = 1:length(self.interfaceId)
               names{i} = getInterfaceName(self.interfaceId{i}); 
            end
            IDs = self.interfaceId;
        end
        
        function [previousValues, names] = setProperty(self, propertyName, propertyValue, interfaceName)
           previousValues = {};
           names = {};
           if(nargin > 3 && iscell(propertyValue) && length(propertyValue) == length(interfaceName))
               for i = 1:length(interfaceName)
                   id = getInterfaceByName(interfaceName{i});
                   [previousValues{i},tf] = getInterfaceProperty(id,propertyName);
                   if(tf)
                        setInterfaceProperty(id,propertyName,propertyValue{i}); 
                   end
               end
               names = interfaceName;
           else
                for i = 1:length(self.interfaceId)
                    [previousValues{i},tf] = getInterfaceProperty(self.interfaceId{i},propertyName);
                    names{i} = getInterfaceName(self.interfaceId{i});
                    if(tf)
                        setInterfaceProperty(self.interfaceId{i},propertyName,propertyValue); 
                    end
                end
           end
        end
        
        function [previousValues, names] = setPropertyAndApply(self, propertyName, propertyValue, interfaceName)
            previousValues = {};
            if(nargin > 3)
                [previousValues, names] = self.setProperty(propertyName, propertyValue, interfaceName);
            else
                [previousValues, names] = self.setProperty(propertyName, propertyValue);
            end
            self.apply();
        end
        
        function [values, names] = getProperty(self, propertyName)
           values = {};
           names = {};
            for i = 1:length(self.interfaceId)
              values{i} = getInterfaceProperty(self.interfaceId{i},propertyName);
              names{i} = getInterfaceName(self.interfaceId{i}); 
            end
        end
        
        function apply(self)
            self.redraw();
            for i = 1:length(self.interfaceId)
                applyInterface(self.interfaceId{i}); 
            end
        end
        
        function redraw(self)
            redrawInterfaces;
        end

    end
end
