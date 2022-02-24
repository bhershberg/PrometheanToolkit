function CB_moveExportProfileUp(source, event, profilePanel)

    global settings;
    global tabExport;

    idx = profilePanel.UserData.profileIndex;
    
    tabExport.UserData.focusedTab = tabExport.UserData.childrenTabLocations{idx};
    
    if(idx ~= 1)
        tmp = settings.export.profiles(idx-1);
        settings.export.profiles(idx-1) = settings.export.profiles(idx);
        settings.export.profiles(idx) = tmp;
    end

    redrawExportProfiles;

end