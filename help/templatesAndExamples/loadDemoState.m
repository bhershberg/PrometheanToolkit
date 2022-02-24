function tf = loadDemoState(dummy1, dummy2)

    tf = 1;
    
    global tabFileManager;
    global settings;
    
    settings = struct;
    PrometheanToolkit;
    
    try
        
        source = [];
        event = [];

        tabFileManager.UserData.textEdit_LoadSettingsFile.String = which('PrometheanToolkit_demoStateFile.mat');

        CB_FM_loadFile(source,event,tabFileManager.UserData.textEdit_LoadSettingsFile,tabFileManager.UserData.textEdit_Readme);
        
    catch
        tf = 0;
    end

end