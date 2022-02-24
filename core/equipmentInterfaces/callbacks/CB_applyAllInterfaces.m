function CB_applyAllInterfaces(source, event)

    global settings;
    
    source.Enable = 'off';
    
    
    try
    
        if(structFieldPathExists(settings,'settings.lab.interfaces') && length(settings.lab.interfaces) > 1)

            applyAllInterfaces;
        
        end
        
    catch
        
        warning ('Could not apply to all. Unknown error');
        
    end
    
    source.Enable = 'on';
    
end