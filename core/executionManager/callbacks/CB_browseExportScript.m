function CB_browseExportScript(source, event)

    global settings;

    try 
        fname = which(source.Parent.UserData.exportScriptName);
    catch
        fname = 'Please select the Export Specification File to use';
    end
    
    
    [filename, pathname] = uigetfile(fname);
    if(filename == 0)
        return;
    end

    source.Parent.UserData.txtScriptName.String = sprintf('Export Script to Execute: %s',filename);
    source.Parent.UserData.exportScriptName = filename;
    
    if(structFieldPathExists(source,'source.Parent.UserData.profileIndex') && source.Parent.UserData.profileIndex > 0)
        idx = source.Parent.UserData.profileIndex;
        settings.export.profiles{idx}.exportScriptName = filename;
        redrawExportProfiles;
    end

end