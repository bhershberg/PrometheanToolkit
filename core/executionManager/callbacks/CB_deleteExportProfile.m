function CB_deleteExportProfile( source, event, profilePanel )

    global settings;
    global tabExport;

    idx = profilePanel.UserData.profileIndex;
    
    tabExport.UserData.focusedTab = tabExport.UserData.childrenTabLocations{idx};

    settings.export.profiles(profilePanel.UserData.profileIndex) = [];
    delete(profilePanel);

    redrawExportProfiles;

end