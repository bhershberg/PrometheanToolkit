function CB_disableAll(source, event)

    global settings;
    
    if(structFieldPathExists(settings,'settings.lab.interfaces') && length(settings.lab.interfaces) > 1)
    
        for i = 1:length(settings.lab.interfaces)
            settings.lab.interfaces{i}.enable = 0;
        end

        spoofedSource.Parent = source.Parent; 
        spoofedEvent = {};

        redrawInterfaces;
        CB_applyAllInterfaces(spoofedSource, spoofedEvent);
    
    end
    
end