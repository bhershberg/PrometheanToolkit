function CB_exportProfile( source, event, profilePanel )

    global settings;

    profile = settings.export.profiles{profilePanel.UserData.profileIndex};
    executeExportProfile(profile.id);

end

