% =========================================================================
% Example of a custom user function with integration into Promethean Toolkit
% =========================================================================
% Benjamin Hershberg, 2020
%
function [results, tf] = example_userFunction(options)

    % DO NOT EDIT ---------------------------------------------------------
    results = struct;                       % Return any/all function outputs with a single 'results' structure
    tf = 1;                                 % Function exit status (tf=1 --> success, tf=0 --> failure/canceled)
    if(nargin < 1), options = struct; end   % All inputs are provided to the function through an 'options' structure
    parser = structFieldDefaults();         % Instantiate the options parser
    parser.add('returnDefaults',false);     % Required options field, do not edit
    parser.add('interactive', false);       % Required options field, strongly advised to set to 'false'
    % ---------------------------------------------------------------------
    
    % define default values for the options parameters that will be used:
    parser.add('debug',true);
    parser.add('characterList', {'Wookie','Ewok','Jawa','Tauntaun'});
    parser.add('characterIndex', 1);
    parser.add('saveResults', false);
    options = parser.applyDefaults(options); % DO NOT EDIT/REMOVE THIS LINE
    
    % optionally, include more defaults from relevant sub-functions:
    options = mergeStruct(options,getDefaultOptions(@example_userSubFunction));

    % DO NOT EDIT ---------------------------------------------------------
    if(options.returnDefaults), global defaultOptions; defaultOptions = options; return; end
    [options, tf] = interactiveSetup(options); 
    if(~tf), return; end
    % ---------------------------------------------------------------------
    
    % define a plotting function that can interpret the results output:
    results.plotFunction = @example_plotFunction;
    
    % including this will allow you to restore your current system state
    % through the results manager later on (full reproducability):
    results = addStateDataToResult(results, options);
    
    
    
    % main function code begins:
    
    % let's simulate a common measurement environment where we're looping
    % through a parameter sweep and want to see results as they are
    % collected:
    results.character = options.characterList{options.characterIndex};
    for i = 1:20
        options.indexesToReturn = 1:i;
        subResults = example_userSubFunction(options);
        results = mergeStruct(subResults, results);
    
        % we can already plot intermediate results during the sweep:
        pause(0.2);
        results.plotFunction(results);
    end
    
    if(options.saveResults)
        % save the results into the settings structure:
        % (they can now be viewed from the "Results Manager" tab)
        addResult(results,sprintf('Example: Population Dynamics of the %s.',results.character));
    end
    
end

function [options, tf] = interactiveSetup(options)
% Local function that defines the behavior when options.interactive = true

    % DO NOT EDIT ---------------------------------------------------------
    if(~options.interactive), tf = 1; return; end
    % ---------------------------------------------------------------------
    
    % function-specific interactivity:
    [idx, tf] = listDialog('Choose your character:',options.characterList);
    if(~tf), return; end 
    options.characterIndex = idx;
    
    % let the user view and edit the options before executing main code:
    [options, tf] = optionsEditor(options);
    if(~tf), return; end  

    % DO NOT EDIT --------------------------------------------------------
    options.interactive = false; % will be passed along to sub-functions, so should be set to 'false'
    tf = 1;
    % ---------------------------------------------------------------------
    
end