% Benjamin Hershberg, 2020
%
% For more info about setting up the callback layer that connects 
% Promethean Toolkit GUI to underlying custom user functions, take a look at the
% comments in: example_CB_userFunctionCallback.m
%
function example__CB_sweepControlVariable(source, event)

    % for this demo, let's make sure we have the demo state file loaded up:
    answer = questdlg('For this demo, the demo.mat state file needs to be loaded.','Load demo.mat file?','Yes, load it','Skip, it is already loaded','No, cancel demo','No, cancel demo');
    if(isequal(answer,'Yes, load it'))
        loadDemoState;
    elseif(isequal(answer,'No, cancel demo'))
        return;
    end
    
    options.interactive = true;
    options.saveResults = true;
    
    % run the function:
    [results, tf] = example__sweepControlVariable(options);
    if(~tf), return; end
    
    % and also plot the final results:
    results.plotFunction(results);

end