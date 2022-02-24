% This function is a part of the Execution Manager API
% Benjamin Hershberg, 2020
%
% Usage:
% 
%   programChip();
% 
%   + description: Executes all scripts in the Execution Manager that
%                   have the "Chip Programmer" designation set to true.
%                   Note that there can be multiple execution modules flagged
%                   for this at once. This will execute any/all that are
%                   flagged in the order that they are listed in the
%                   Execution Manager tab of the GUI.
%   + inputs:   none
%   + outputs:  none
%
function programChip()

    global settings;
    
    if(structFieldPathExists(settings,'settings.export.profiles'))
        for i = 1:length(settings.export.profiles)
            if(settings.export.profiles{i}.flag_chip_io)
                profile = settings.export.profiles{i};
                executeExportProfile(profile.id);
            end
        end
    end

end

