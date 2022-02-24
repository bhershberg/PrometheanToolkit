function CB_exportProfileBatchToggle(source, event)

    global settings;
    initializeGraphics;
    
    if(~structFieldPathExists(settings,'settings.export.profiles')) 
        settings.export.profiles = {}; 
    end
    
    profilePanel = source.Parent;
    index = profilePanel.UserData.profileIndex;
    
    if(~isfield(settings.export.profiles{index},'flag_batch_export'))
        settings.export.profiles{index}.flag_batch_export = 0;
    end
    
    if(settings.export.profiles{index}.flag_batch_export)
        settings.export.profiles{index}.flag_batch_export = 0;
        source.BackgroundColor = grey;
        source.String = 'Batch Execute: Skip';
    else
        settings.export.profiles{index}.flag_batch_export = 1;
        source.BackgroundColor = green;
        source.String = 'Batch Execute: Include';
    end
    
%     redrawExportProfiles;
    
end