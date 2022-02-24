function CB_RM_updatePath(source, event)

    global settings;

    resultsPath = source.Parent.UserData.resultsPath;
    newPath = resultsPath.String;
    
    if(structFieldPathExists(settings,newPath))
        setGlobalOption('resultsPath',newPath); 
        CB_RM_refresh(source, event);
    else
        msgbox('Could not apply. There is nothing at that location');
        resultsPath.String = getGlobalOption('resultsPath');
    end

end