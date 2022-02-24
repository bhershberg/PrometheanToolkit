function CB_editExportOptions(source, event, profilePanel)

    global settings;

    profileIndex = profilePanel.UserData.profileIndex;
    
    profile = settings.export.profiles{profileIndex};
    
    if(~isfield(profile,'options'))
        profile.options = struct;
    end
    
    editorOptions.mergeWithOriginal = false;
    profile.options = optionsEditor(profile.options,editorOptions);
    
    settings.export.profiles{profileIndex} = profile;

end