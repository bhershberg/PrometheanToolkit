% =========================================================================
% Overivew of APIs for Promethean Toolkit
% =========================================================================
% Promethean Toolkit
% Benjamin Hershberg, 2020

% Promethean Toolkit comes with several APIs (application programming interfaces)
% that allow you to work with Promethean Toolkit and its corresponding GUI through
% simple function calls and objects. This separates the core code from your
% user/custom code, so that you won't need to do any hacking around inside
% of the "core" folder of Promethean Toolkit's codebase. Best practice is to put
% all of your custom code in the "custom" folder of the code directory and
% not touch the "core" folder at all. This will allow you to patch the core
% folder with version updates without risking overwriting any of your own
% code.

% Familiarize yourself with the list of functions and classes below. This
% is your primary gateway into the system!


% === Graphics API ===

    % Figures and Plotting:
    help namedFigure
    help askWhatToPlot

    % Interactive Pop-up Elements:
    help dataEditor
    help optionsEditor
    help textEditor
    help parametricSweepDialog
    help radioButtonDialog
    help checkboxDialog
    help listDialog
    
    % Interactive Fixed Elements:
    help relativePosition
    help placeButton
    help placeCheckbox
    help placeDropdown
    help placeEdit
    help placeListbox
    help placePanel
    help placeTab
    help placeText
    

% === Global Options API ===

    % Functions:
    help getGlobalOption
    help setGlobalOption
    help deleteGlobalOption
    

% === Control Variable API ===

    % Functions:
    help createControlVariable
    help deleteControlVariable
    help getControlVariable
    help setControlVariable
    help listControlVariableRelatives
    help getControlHierarchy
    help getAbsoluteControlVariablePath
    help getRelativeControlVariablePath
   
% === Execution Manager API ===
    
    help programChip
    help executeModule
    help batchExecute
    
    
% === Results Manager API ===

    % Functions:
    help addResult
    help getResult
    help addStateDataToResult
    help saveSystemState
    
    % Secondary functions:
    help getControlState
    help getEquipmentState
    help getExportState
    help getGlobalOptionsState
    help setControlState
    help setEquipmentState
    help setExportState
    help setGlobalOptionsState  

    
% === Equipment Control API ===

    % Classes:
    help equipmentInterface
    help equipmentInterfaceGroup
    help interfaceDefinitionManager
    
    % Functions:
    help listAllInterfaces
    help selectInterface

    % Some other low-level functions that you shouldn't need to use...
    % (use the equipmentInterface() and equipmentInterfaceGroup() classes 
    % to do everything that these can do):
    help getInterface
    help getInterfaceByName
    help getInterfaceByType
    help getInterfaceHandle
    help getInterfaceIndex
    help getInterfaceName
    help getInterfaceProperty
    help getInterfacesWithProperty
    help setInterfaceProperty
    