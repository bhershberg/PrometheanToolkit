function CVE_sweepRegister(source, event, dataObject, breadcrumb, ~, ~)
    % Allows the user to sweep this register value and look how the results
    % change
    global settings;
    printout = {};
    breadcrumb_mod = breadcrumb;

    str = breadcrumbToString(breadcrumb_mod);
    eval(['oldval = ', str,'{1};']);
    eval(['minval = ', str,'{3};']);
    eval(['maxval = ', str,'{4};']);
    
    message = [num2str(oldval),':1:',num2str(oldval)];
    
    options.title = 'start:step:stop';
    [text, tf] = textEditor(message,options);
    
    if tf
    %% Sanity check of vector
    % Kick out all values that are out of range and give warning to user if
    % the user gave a range with unrealistic values
    try
        eval(['sweepvec = ',text,';']);
        N = length(sweepvec);
        sweepvec = sweepvec(and(sweepvec>=minval,sweepvec <= maxval));
        if length(sweepvec) ~= N
            warning(['Provided vector [',text,'] for ',str,', is out of range. We reduced to the feasible range!']);
            N = length(sweepvec);
        end
    catch
        warning('Vector syntax error. Retry with the correct format => START:STEP:STOP');
        return;
    end
    
    %% Sweep the Registervalues and capture data
    P_sig = nan(1,N);
    for ii=1:N
        eval([str,'{1} = sweepvec(ii);']);
        
        compileAndProgramChip;
%         pause(2)
         %% Save data
        captureResults = captureData;
        
         options = mergeStruct(options,captureResults.options);
        [reconstructedResults, data_reconstructed] = reconstructAndOptimize(captureResults, options);
        [FFTresults, FFToptions] = fft_analysis(data_reconstructed, options);
        ENOB(ii) = FFTresults.ENOB;
        nosound = 1; Statusbar;
    end
    
   
    namedFigure('ENOB'); plot(sweepvec, ENOB); hold on;
    xlabel(str);

    
    %% Restore the old setting
    eval([str,'{1} = oldval;']);
    end
end
