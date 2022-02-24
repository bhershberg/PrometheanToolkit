function CB_FM_loadFile(source,event,filepathTextBox,textEdit_Readme)
    global settings;
    
    try
        load(filepathTextBox.String);
    catch
        msgbox('Error loading file. Check that filepath string is correct.','Cannot load file');
    end

    % pull the readme from the settings structure and display:
    if((iscell(settings.readme) && length(settings.readme) == 1))
        settings.readme = settings.readme{1};
    end
    if(ischar(settings.readme))
        readme = {};
        for i = 1:size(settings.readme,1)
            readme{i} = deblank(settings.readme(i,:));
        end
    elseif(iscell(settings.readme))
        readme = settings.readme;
    else
        warning('unknown readme format. could not load');
        readme = {};
    end
    textEdit_Readme.String = readme;
    settings.readme = readme;

    % legacy results check:
    if(structFieldPathExists(settings,'settings.lab.measurements'))
        settings.lab.results = settings.lab.measurements;
        settings.lab = rmfield(settings.lab,'measurements');
        fprintf('Found legacy results stored in setting.lab.measurements. Moving to settings.lab.results.');
    end
    % legacy global options check:
    if(structFieldPathExists(settings,'settings.lab.options'))
        settings.options = settings.lab.options;
        settings.lab = rmfield(settings.lab,'options');
        fprintf('Found legacy options stored in settings.lab.options. Moving them to settings.options.\n');
    end

    % control structure consistency check:
    if(isempty(getGlobalOption('controlVariablePath')))
        setGlobalOption('controlVariablePath','settings.ctrl');
    end
    basePath = getGlobalOption('controlVariablePath');
    eval(sprintf('ctrlStruct = %s;',basePath));
    ctrlStruct = controlStructureConsistencyCheck(ctrlStruct);
    eval(sprintf('%s = ctrlStruct;',basePath));

    GUI_redrawTabs(); % rebuild the GUI to reflect the new settings

    fprintf('File loaded.\n');
    
end