function CB_deleteInterface( source, event, interfacePanel )

    global settings;
    
    % option to run user-defined actions before deletion:
    custom__equipmentInterface_onDelete(source, event, interfacePanel);

    settings.lab.interfaces(interfacePanel.UserData.interfaceIndex) = [];
    delete(interfacePanel);

    redrawInterfaces;

end

