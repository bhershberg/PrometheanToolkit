% Promethean Toolkit
% Benjamin Hershberg, 2020
%
function template_CB_userFunctionCallback_withoutComments(source, event)

    options.interactive = true;
    options.saveResults = true;
    
    % run the function:
    [results, tf] = YOUR_FUNCTION_HERE(options);
    if(~tf), return; end
    
    % plot results:
    results.plotFunction(results);

end