function applyInterface( id )

    global settings;
    global tabEquipmentControl;
    
    if(~isfield(settings,'lab')) settings.lab.interfaces = {}; end

    interfacePanel = getInterfaceHandle(id);
    index = interfacePanel.UserData.interfaceIndex;
    
    % execute the interface's pre-defined 'apply' function:
    interfaceType = settings.lab.interfaces{index}.type;
    [~,interfaceApplyFunction] = tabEquipmentControl.UserData.interfaceDefinitions.get(interfaceType);
    interfaceApplyFunction(interfacePanel);

end

