function CB_FM_loadInterfacesFromFile(source, event)

    global settings;
    global tabFileManager;
    
    if(structFieldPathExists(tabFileManager,'tabFileManager.UserData.pathname'))
        pathname = tabFileManager.UserData.pathname;
    else
        pathname = '';
    end
    [filename, pathname] = uigetfile('*.mat','Select the settings .mat file to read the Equipment Interface configuration from...',pathname);
    
    if(~isequal(filename,0))
        otherSettings = load([pathname filename]);
        if(structFieldPathExists(otherSettings,'otherSettings.settings.lab.interfaces'))
            settings.lab.interfaces = otherSettings.settings.lab.interfaces;
            redrawInterfaces;
            msgbox('Equipment interface configuration loaded, but not sent to intstruments. Check manually first to be safe!');
        else
            msgbox('Operation aborted. The requested file does not appear to contain equipment interface configuration data.');
        end
    end    
    
end