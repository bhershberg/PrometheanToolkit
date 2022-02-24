function newSettings = loadSettingsFile(options)

    global settings;
    
    if(nargin < 1), options = struct; end
    parser = structFieldDefaults();
    parser.add('debug',true);
    parser.add('returnDefaults',false);
    parser.add('fileName','');
    parser.add('filePath','');
    parser.add('applySettings',true);
    options = parser.applyDefaults(options);
    if(options.returnDefaults)
        global defaultOptions; 
        defaultOptions = options; return; 
    end
    
    if(strcmp(options.filePath(end),'/') || strcmp(options.filePath(end),'\'))
        options.filePath = options.filePath(1:end-1);
    end

    if(~isempty(options.filePath))
        stateFile = load(fullfile(options.filePath,options.fileName));
    else
        stateFile = load(options.fileName);
    end
    
    newSettings = stateFile.settings;
    if(options.applySettings)
        settings = newSettings;
        redrawInterfaces;
        applyAllInterfaces;
        compileAndProgramChip;
    end

end