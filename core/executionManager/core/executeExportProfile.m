% Author: Benjamin Hershberg
% Date Created: September 2020
function results = executeExportProfile(exportProfileId)

    global settings;
    results = struct; % If the user wishes, they can return something in a 'results' structure to the calling function (e.g. a custom user Macro function)

    exportProfileIndex = getExportProfileIndex(exportProfileId);
    profile = settings.export.profiles{exportProfileIndex};
    options = profile.options;
    
    % run in a 'sandbox' so that the user can't accidentally corrupt the
    % global settings structure if they happen to have a naming conflict.
    % The user will see the export profile and options sub-scructures in 
    % their execution environment. 
    executeProfileInSandbox(profile, options);
    
end
function executeProfileInSandbox(profile, options)

    % determine if we're trying to execute a function or a script:
    try
        nargs = nargin(profile.exportScriptName);
        isFunction = true;
    catch 
        isFunction = false;
    end

    if(isFunction) 
        % if it is a function, pass the options in as the first argument:
        functionName = strrep(profile.exportScriptName,'.m','');
        eval(sprintf('functionHandle = @%s;',functionName));
        functionHandle(options);
        
    else
        % if it is a script, run in local environment, making the options also available to the script:
        eval(strrep(profile.exportScriptName,'.m',''));
    end

end