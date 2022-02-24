function CB_initializeNewInterface(source, event, interfacePanel,textbox_Name,popupInterfaceList)

    global settings;
    
    if(~structFieldPathExists(settings,'settings.lab.interfaces'))
        settings.lab.interfaces = {};
    end
    namingConflict = false;
    for i = 1:length(settings.lab.interfaces)
        if(isequal(settings.lab.interfaces{i}.name,textbox_Name.String))
            namingConflict = true;
        end
    end
    if(namingConflict)
       msgbox('This name is already being used by an interface. Please use a unique name.');
       return;
    end

    global tabEquipmentControl;

    interfaceType = popupInterfaceList.String{popupInterfaceList.Value};
    name = textbox_Name.String;
    
    interfacePanel.Title = sprintf('%s  (%s)', name, interfaceType);
    
    interfacePanel.UserData.interfaceIndex = 0;
    interfacePanel.UserData.name = name;
    
    % execute the interface's pre-defined 'create' function:
    [interfaceCreateFunction] = tabEquipmentControl.UserData.interfaceDefinitions.get(interfaceType);
    interfaceCreateFunction(interfacePanel);
    
    redrawInterfaces(tabEquipmentControl);
            
end
