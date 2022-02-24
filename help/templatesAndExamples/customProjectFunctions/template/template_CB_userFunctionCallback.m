% Promethean Toolkit
% Benjamin Hershberg, 2020
%
function template_CB_userFunctionCallback(source, event)

    % If the function is called through a callback, then we can assume the
    % user wishes to operate in interactive mode:
    options.interactive = true;
    
    % In this case the function saves results inside its 
    options.saveResults = true;
    
    % run the function:
    [results, tf] = YOUR_FUNCTION_HERE(options);
    if(~tf), return; end
    
    % and also plot the results:
    results.plotFunction(results);
    
    % Note that we did not pass "options.interactivePlot = true;" into this
    % call to the plotting function. You can certainly do that if you want,
    % but often times you will find that it makes more sense to just allow 
    % the default non-interactive behavior. The user can still do 
    % interactive plotting through the Results Manager. (Because internally
    % the Results Manager always passes interactivePlot = true into the
    % plot function.)

end