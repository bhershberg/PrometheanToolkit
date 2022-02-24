% =========================================================================
% Template for making custom user functions
% =========================================================================
% Benjamin Hershberg, 2020
%
function [results, tf] = template_userFunction(options)

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
    parser.add('saveResults',false);
    options = parser.applyDefaults(options); % DO NOT EDIT/REMOVE THIS LINE
    
    % optionally, include more defaults from relevant sub-functions:
    options = mergeStruct(options,getDefaultOptions(@example_userSubFunction));

    % DO NOT EDIT ---------------------------------------------------------
    if(options.returnDefaults), global defaultOptions; defaultOptions = options; return; end
    [options, tf] = interactiveSetup(options); if(~tf), return; end
    % ---------------------------------------------------------------------
    
    % define a plotting function that can interpret the results output:
    results.plotFunction = @default_plotFunction;
    
    % including this will allow you to restore your current system state
    % through the results manager later on (full reproducability):
    results = addStateDataToResult(results, options);
    
    
    % main function code begins:
    
    % <your code goes here>
    
    
    if(options.saveResults)
        % add results to the Result Manager:
    	addResult(results, sprintf('Result From: %s',mfilename));
    end
    
end

function [options, tf] = interactiveSetup(options)
% Local function that defines the behavior when options.interactive = true

    % DO NOT EDIT ---------------------------------------------------------
    if(~options.interactive), tf = 1; return; end
    % ---------------------------------------------------------------------
    
    % function-specific interactivity:
    % <your code goes here>
    
    % let the user view and edit the options before executing main code:
    [options, tf] = optionsEditor(options);
    if(~tf), return; end  

    % DO NOT EDIT --------------------------------------------------------
    options.interactive = false; % will be passed along to sub-functions, so should be set to 'false'
    tf = 1;
    % ---------------------------------------------------------------------
    
end