% =========================================================================
% Working Example: Using the Control Variable API
% =========================================================================
% Promethean Toolkit
% Benjamin Hershberg, 2020
%
% This function shows the basic sketch of how one can do parametric sweeps
% of control variables in the context of a user's custom measurement
% environment / setup. In partiuclar, this demos the control variable API
% that includes the functions:
%
%   [value, info, success] = getControlVariable(pathString)
%   [success] = setControlVariable(pathString, value)
%
% Notice how these two functions are used in this example.
%
% Also worth noticing here:
% + The very simple way that we restore the original control variable state
% + The various tools and ways that we do some interactive setup with the user
% + The way you can use the 2nd and 3rd outputs of getControlVariable, as
%   shown in the interactiveSetup function below.
% + The beauty of this overall GUI integration method is that you can also call 
%       your custom functions directly and they'll also work. But when it's
%       called from the GUI, it'll become auto-magically interactive. For
%       example try running:
%
%   options.sweepValues = 4:24;
%   options.parameterPath = {'digital.CH1.STG1.ringampBiasControl'};
%   example__sweepControlVariable(options);
%
% ...and see what happens. No user interaction required, so you're free to
% re-use your functions in other code, nested function, scripts, scratchpads, 
% and whatever else.
%
function [results, tf] = example__sweepControlVariable(options)

    if(nargin < 1), options = struct; end
    parser = structFieldDefaults();
    parser.add('debug',true);
    parser.add('returnDefaults',false);
    parser.add('interactive', false);
    parser.add('parameterPath',{});
    parser.add('sweepValues',[]);
    parser.add('saveResults',false);
    % let's give external access to defining the plot handle, because for 
    % different sweeps you might want to have different plotting functions or analysis:
    parser.add('plotFunctionHandle',@example__plot_sweepControlVariable); 
    options = parser.applyDefaults(options);
    if(options.returnDefaults)
        global defaultOptions; 
        defaultOptions = options; return; 
    end
    [options, tf] = interactiveSetup(options);
    if(~tf), return; end
    
    % initialize the results structure;
    results = struct;
    results = addStateDataToResult(results);
    results.plotFunction = options.plotFunctionHandle;
    results.options = options;

    % run the sweep:
    for i = 1:length(options.sweepValues)
        
        % update the control parameter:
        for j = 1:length(options.parameterPath)
            
            % set a control variable to a new value with the API:
            setControlVariable(options.parameterPath{j},options.sweepValues(i));
            
            % and for this demo, let's prove that we actually updated the
            % control variable by reading it back through the API:
            fprintf('Just set %s = %d\n',options.parameterPath{j},getControlVariable(options.parameterPath{j}));
        end
        
        % now we can do the custom measurement stuff you want to do for
        % your particular project.
        % for example, you might want to do....
        programChip;                                        % (note that this function is over-ridden locally for this example...scroll down)
        localResult = captureData(options.sweepValues(i));  % (note that this function is over-ridden locally for this example...scroll down)
        results.data(i) = localResult.data;
        results.sweepValues(i) = options.sweepValues(i);

        results.plotFunction(results,options);
        
    end
   
    % Restore original control state:
    % (note that we are simply restoring the state info that we obtained 
    % earlier when calling addStateDataToResult above)
    setControlState(results.stateData_controlVariables); 
    programChip;
    
    
    % Dummy functions to emulate real-world operations....
    % You don't need to pay close attention to these.
    function programChip()
        % Over-riding default function so that we don't create havoc.
        % Let's pretend that this programs the digital.
    end
    function results = captureData( cheatInfo )
    % Over-riding default function so that we don't create havoc.
    % Let's pretend that this captures something important
        results.data = randn + cheatInfo;
    end

    if(options.saveResults)
        if(length(options.parameterPath) > 1)
            andOthers = ' (and others)';
        else
            andOthers = '';
        end
    	addResult(results,sprintf('Ctrl Var Sweep of: %s%s',strrep(options.parameterPath{1},'.','_'),andOthers));
    end

end
function [options, tf] = interactiveSetup(options)

    if(~options.interactive), tf = 1; return; end

    % Let the user define what control variable(s) to sweep:
    msg = {};
    msg{1} = '% Paste the control variable paths that you want to sweep all together as a 1-D sweep, one per line.';
    msg{2} = '% Example:';
    msg{3} = 'digital.CH1.STG1.amplifyDuration';
    msg{4} = 'digital.CH1.STG1.quantizeDuration';
    msg = textEditor(msg);
    
    % only add valid control variable paths:
    options.parameterPath = {};
    for i = 1:length(msg)
        % Notice here how the third output of the "get" API function tells
        % us whether or not the control variable path is valid:
        [~, ~, valid] = getControlVariable(msg{i});
        if(valid)
            options.parameterPath{end+1} = msg{i};
        end
    end
    
    % Set up the parametric sweep:
    start = [];
    stop = [];
    step = 1;
    for i = 1:length(options.parameterPath)
        % Notice here how the second output of the "get" API function tells
        % us all the information about the requested variable, including
        % the min and max values that are allowed:
        [~, info] = getControlVariable(options.parameterPath{i});
        start(end+1) = info.min;
        stop(end+1) = info.max;
    end
    start = max(start);
    stop = min(stop);
    [start, stop, step] = parametricSweepDialog('Set up the sweep:','',start, stop, step);
    options.sweepValues = start:step:stop;
    
    % let the user edit final options settings:
    [options, tf] = optionsEditor(options);
    if(~tf), return; end  
    
    options.interactive = false;
    tf = 1;

end