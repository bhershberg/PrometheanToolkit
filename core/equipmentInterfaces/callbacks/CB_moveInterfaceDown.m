function CB_moveInterfaceDown(source, event, profilePanel)

    global settings;
    global tabEquipmentControl;

    idx = source.Parent.UserData.profileIndex;
    
    tabEquipmentControl.UserData.focusedTab = tabEquipmentControl.UserData.childrenTabLocations{idx};
    
    if(idx ~= length(settings.lab.interfaces))
        tmp = settings.lab.interfaces(idx+1);
        settings.lab.interfaces(idx+1) = settings.lab.interfaces(idx);
        settings.lab.interfaces(idx) = tmp;
    end

    redrawInterfaces;

end