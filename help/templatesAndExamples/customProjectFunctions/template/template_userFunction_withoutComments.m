% =========================================================================
% Template for making custom user functions
% =========================================================================
% Benjamin Hershberg, 2020
%
function [results, tf] = template_userFunction_withoutComments(options)

    results = struct;
    tf = 1;
    if(nargin < 1), options = struct; end
    
    parser = structFieldDefaults();
    parser.add('returnDefaults',false);
    parser.add('interactive', false);
    parser.add('debug',true);
    parser.add('saveResults',false);
    options = parser.applyDefaults(options);
    % options = mergeStruct(options,getDefaultOptions(@subFunctionName));
    
    if(options.returnDefaults), global defaultOptions; defaultOptions = options; return; end
    [options, tf] = interactiveSetup(options); if(~tf), return; end
    
    results.plotFunction = @default_plotFunction;
    results = addStateDataToResult(results, options);
        
    
    % <your code goes here>
    
    
    if(options.saveResults)
        % add results to the Result Manager:
    	addResult(results, sprintf('Result From: %s',mfilename));
    end
    
end

function [options, tf] = interactiveSetup(options)

    if(~options.interactive), tf = 1; return; end

    % <your code goes here>
    
    [options, tf] = optionsEditor(options);
    if(~tf), return; end  
    
    options.interactive = false;
    tf = 1;

end