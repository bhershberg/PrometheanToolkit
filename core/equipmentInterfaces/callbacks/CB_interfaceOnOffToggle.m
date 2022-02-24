function CB_interfaceOnOffToggle(source, event)

    global settings;
    global tabEquipmentControl;
    initializeGraphics;
    
    interfacePanel = source.Parent;
    index = interfacePanel.UserData.interfaceIndex;
    
    if(settings.lab.interfaces{index}.enable)
        settings.lab.interfaces{index}.enable = 0;
        source.BackgroundColor = red;
        source.String = 'Off';
    else
        settings.lab.interfaces{index}.enable = 1;
        source.BackgroundColor = green;
        source.String = 'On';
    end
    
    % execute the interface's pre-defined 'apply' function:
    interfaceType = settings.lab.interfaces{index}.type;
    [~,interfaceApplyFunction] = tabEquipmentControl.UserData.interfaceDefinitions.get(interfaceType);
    interfaceApplyFunction(interfacePanel);
    
end