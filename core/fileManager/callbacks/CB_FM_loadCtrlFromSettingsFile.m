function CB_FM_loadCtrlFromSettingsFile(source, event)

    global settings;
    global tabFileManager;
    
    if(structFieldPathExists(tabFileManager,'tabFileManager.UserData.pathname'))
        pathname = tabFileManager.UserData.pathname;
    else
        pathname = '';
    end
    [filename, pathname] = uigetfile('*.mat','Select the settings .mat file to read the Control Variable data from...',pathname);
    
    if(~isequal(filename,0))
        otherSettings = load([pathname filename]);
        if(structFieldPathExists(otherSettings,'otherSettings.settings.ctrl'))
            if(structFieldPathExists(otherSettings,'otherSettings.settings.options.controlVariablePath'))
                cvpOther = otherSettings.settings.options.controlVariablePath;
            else
                cvpOther = 'settings.ctrl';
            end
            cvp = getGlobalOption('controlVariablePath');
            eval(sprintf('%s = otherSettings.%s;',cvp, cvpOther));
            redrawControlVariableEditorTab;
            msgbox(sprintf('Chip control structure ''%s'' successfully replaced with ''%s'' from %s.',cvp,cvpOther,filename));
        else
            msgbox('Operation aborted. Could not load control variable data from the specified file.');
        end
    end
        
end