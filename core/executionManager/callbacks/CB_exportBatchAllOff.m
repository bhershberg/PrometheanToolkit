function CB_exportBatchAllOff(source, event)

    global settings;
    
    for i = 1:length(settings.export.profiles)
        settings.export.profiles{i}.flag_batch_export = 0;
    end
    
    redrawExportProfiles;
    
end