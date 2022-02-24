function CB_applyInterfaceChanges(source, event)

    global settings;
    global tabEquipmentControl;
    initializeGraphics;
    
    interfacePanel = source.Parent;
    index = interfacePanel.UserData.interfaceIndex;
    
    % execute the interface's pre-defined 'apply' function:
    interfaceType = settings.lab.interfaces{index}.type;
    [~,interfaceApplyFunction] = tabEquipmentControl.UserData.interfaceDefinitions.get(interfaceType);
    interfaceApplyFunction(interfacePanel);
    
end