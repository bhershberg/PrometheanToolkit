function CB_batchExport( source, event)

    global settings;

    if(~structFieldPathExists(settings,'settings.export.profiles'))
        settings.export.profiles = {}; 
    end
    
    h = waitbar(0,'Batch Execute...');
    for i = 1:length(settings.export.profiles)
         if(isgraphics(h))
            h = waitbar((i-1)/length(settings.export.profiles),...
                h, sprintf('Executing %s...',settings.export.profiles{i}.name));
        end
        profile = settings.export.profiles{i};
        if(profile.flag_batch_export)
            try
                executeExportProfile(profile.id);
            catch
                warning('Export of profile ''%s'' resulted in an error and failed',profile.name);
            end
        end
    end
    if(isgraphics(h))
        delete(h);
    end
    
end

