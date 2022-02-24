function CB_FM_loadExportProfilesFromFile(source, event)

    global settings;
    global tabFileManager;
    
    if(structFieldPathExists(tabFileManager,'tabFileManager.UserData.pathname'))
        pathname = tabFileManager.UserData.pathname;
    else
        pathname = '';
    end
    [filename, pathname] = uigetfile('*.mat','Select the settings .mat file to import Execution Manager setup from...',pathname);
    
    if(~isequal(filename,0))
        otherSettings = load([pathname filename]);
        if(structFieldPathExists(otherSettings,'otherSettings.settings.export'))
            settings.export = otherSettings.settings.export;
            redrawExportProfiles;
            msgbox('Execution Manager configuration successfully loaded.');
        else
            msgbox('Operation aborted. The requested file does not appear to contain an Execution Manager setup.');
        end
    end    
    
end