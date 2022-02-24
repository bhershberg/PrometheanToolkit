function CB_exportProfileChipIOToggle(source, event)

    global settings;
    initializeGraphics;
    if(~isfield(settings,'export')) settings.export.profiles = {}; end
    
    profilePanel = source.Parent;
    index = profilePanel.UserData.profileIndex;
    profile = settings.export.profiles{index};
    
    % legacy. make sure the field actually exists:
    if(~isfield(profile,'flag_chip_io'))
        settings.export.profiles{index}.flag_chip_io = 0;
    end
    
    if(settings.export.profiles{index}.flag_chip_io)
        settings.export.profiles{index}.flag_chip_io = 0;
        source.BackgroundColor = grey;
        source.String = 'Chip Programmer: No';
    else
        settings.export.profiles{index}.flag_chip_io = 1;
        source.BackgroundColor = blue;
        source.String = 'Chip Programmer: Yes';
    end
    
%     redrawExportProfiles;
    
end