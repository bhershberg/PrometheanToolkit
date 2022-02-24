function index = getExportProfileIndex(id)

    global settings;
    
    index = -1;
    if(isfield(settings,'export') && isfield(settings.export,'profiles'))
        for i = 1:length(settings.export.profiles)
           if(settings.export.profiles{i}.id == id)
               index = i;
               return;
           end
        end
    end

end