% Customize the Equipment Interfaces that display in the GUI
% Benjamin Hershberg, 2020
%
% Add your own equipment interfaces to the system by declaring them in this
% file. 
%
% Declare new interface items like this:
%
% interfaceDefinitions.add('Equpment Model Name/Number Here', ...
%     @functionNameThatCreatesTheInterface, ...
%     @functionNameThatAppliesTheInterface);
%
% See the file 'initializeEquipmentInterfaceDefinitions.m' for more
% examples.
%
% You can then access the pre-loaded interface definition data using:
%
% global tabEquipmentControl;
% [createFunction, applyFunction] = tabEquipmentControl.UserData.interfaceDefinitions.get('interface name');
% interfaceNames = tabEquipmentControl.UserData.interfaceDefinitions.list();



% Comment out this line if you do not want to include the default
% equipement interface defintions in the GUI listing:
includeDefaultDefinitions = true;


% An example equipment interface declaration:
interfaceDefinitions.add('Tyrell Corp. Nexus-6', ...
    @template_createInterface, ...
    @template_applyInterface);

% repeat this example for each interface you wish to include...

