% =========================================================================
% Template for making a function that can be run in the Export Control tab
% =========================================================================
% Benjamin Hershberg, 2020
%
function template__basicExecuteFunction(options)
    
    % Setup your option defaults:
    parser = structFieldDefaults();
    parser.add('returnDefaults',false);             % do not remove
    parser.add('exportFile','./outputs/file.txt');	% example
    parser.add('example','Hello world.');
    options = parser.applyDefaults(options);
    
    if(options.returnDefaults), global defaultOptions; defaultOptions = options; return; end  % do not remove
    
    % <your code here>
    fprintf('(Example) Export File: %s\n', options.exportFile); % example
    fprintf('(Example) Message: %s\n', options.example);        % example

end