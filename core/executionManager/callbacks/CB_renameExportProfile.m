function CB_renameExportProfile(source, event)

    global settings;

    idx = source.Parent.UserData.profileIndex;
    
    oldName = settings.export.profiles{idx}.name;
    
    answer = inputdlg('New name:','Rename Export Profile',[1 60],{oldName});
    
    if(~isempty(answer) && ~isequal(answer{1},''))
        settings.export.profiles{idx}.name = answer{1};
        redrawExportProfiles;
    end

end