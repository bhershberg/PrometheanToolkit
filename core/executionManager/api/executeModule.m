% This function is a part of the Execution Manager API
% Benjamin Hershberg, 2020
%
% Usage:
% 
%   tf = executeModule(moduleName);
% 
%   + description: Executes any and all modules in the Execution Manager
%                   with a given module name.
%   + inputs:   moduleName: string - the name of the module in the
%                               Execution Manager to execute.
%   + outputs:  results:    optional results structure that might be
%                               returned from the user function that is
%                               executed. If nothing is returned by the user, 
%                               this will just be an empty structure.
%               tf:         1 if module was successfully executed, 0 otherwise
%
function [results, tf] = executeModule( moduleName )

    global settings;
    
    if(structFieldPathExists(settings,'settings.export.profiles'))
        for i = 1:length(settings.export.profiles)
            if(isequal(settings.export.profiles{i}.name,moduleName))
                profile = settings.export.profiles{i};
                try
                    results = executeExportProfile(profile.id);
                    tf = 1;
                catch
                    tf = 0;
                    warning('Failed to execute module: %s',moduleName);
                end
            end
        end
    end

end