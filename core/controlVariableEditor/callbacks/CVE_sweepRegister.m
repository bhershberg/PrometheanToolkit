function CVE_sweepRegister(source, event, dataObject, breadcrumb, lvl2_listbox, lvl1_listbox)
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
        if sweepvec ~= N
            warning(['Provided vector [',text,'] for ',str,', is out of range. We reduced to the feasible range!']);
            N = length(sweepvec);
        end
    catch
        warning('Vector syntax error. Retry with the correct format => START:STEP:STOP');
        return;
    end
    
    %% Sweep the Registervalues and capture data
    for ii=1:N
        eval([str,'{1} = sweepvec(ii);']);
        
        compileAndProgramChip;
        
        results = captureData;
    end
    
    %% Save data
    
    %% Restore the old setting
    eval([str,'{1} = oldval;']);
    end
end
