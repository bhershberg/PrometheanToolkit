function CB_Ag16902B_logicAnalyzerConfigFileSelect( source, event )

    global settings;
    
    i = source.Parent.UserData.interfaceIndex;
    
    if(isfield(settings.lab.interfaces{i},'configuration_file_path'))
        filepath = settings.lab.interfaces{i}.configuration_file_path;
    else
        filepath = '.';
    end

    [filename, pathname] = uigetfile('*.ala','Select your .ala Logic Analyzer config file...',filepath);
    
    if(~isequal(filename,0) || ~isequal(pathname,0))
        settings.lab.interfaces{i}.configuration_file = [pathname filename];
        settings.lab.interfaces{i}.configuration_file_path = pathname;
    end
    
    source.Parent.UserData.text_configFile.String = settings.lab.interfaces{i}.configuration_file;

end

