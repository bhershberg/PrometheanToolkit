function CB_moveInterfaceUp(source, event, profilePanel)

    global settings;
    global tabEquipmentControl;

    idx = source.Parent.UserData.profileIndex;
    
    tabEquipmentControl.UserData.focusedTab = tabEquipmentControl.UserData.childrenTabLocations{idx};
    
    if(idx ~= 1)
        tmp = settings.lab.interfaces(idx-1);
        settings.lab.interfaces(idx-1) = settings.lab.interfaces(idx);
        settings.lab.interfaces(idx) = tmp;
    end

    redrawInterfaces;

end