function CB_exportBatchAllOn(source, event)

    global settings;
    global tabExport;
    
    for i = 1:length(settings.export.profiles)
        settings.export.profiles{i}.flag_batch_export = 1;
    end
    
    redrawExportProfiles;
    
end