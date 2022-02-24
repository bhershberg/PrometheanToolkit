function CB_addExportProfile(source, event)

    global settings;
    
    if(~structFieldPathExists(settings,'settings.export.profiles')), settings.export.profiles = {}; end

    
    if(isempty(source.Parent.UserData.profileName.String))
       msgbox('Please enter a profile name.');
       return;
    end
    if(isempty(source.Parent.UserData.exportScriptName))
       msgbox('You must first attach an export script to this profile.');
       return;
    end
    
    profile = struct;
    profile.id = DataHash(now); 
    profile.name = source.Parent.UserData.profileName.String;
    profile.exportScriptName = source.Parent.UserData.exportScriptName;
    profile.options = struct;
    profile.options.example = 'This will be passed into to your script or function.';
    
    settings.export.profiles{end+1} = profile;
    
    redrawExportProfiles;
    
end