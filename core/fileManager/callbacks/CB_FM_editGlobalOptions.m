function CB_FM_editGlobalOptions(~, ~)

    global settings;
    originalResultsPath = getGlobalOption('resultsPath','settings.lab.results');
    originalControlVariablePath = getGlobalOption('controlVariablePath','settings.ctrl');
    
    % make sure it exists:
    if(~structFieldPathExists(settings,'settings.options'))
        settings.options = struct;
    end
    
    % alphabetize the options to make things more readable:
    list = fieldnames(settings.options);
    [~, alphaOrdered] = sort(lower(list));
    optionsFull = orderfields(settings.options,alphaOrdered);
    
    % special cases (this is legacy from old custom projects):
    optionsPruned = optionsFull;
    if(isfield(optionsFull,'regReturnCapSettings'))
        optionsPruned = rmfield(optionsPruned,'regReturnCapSettings')';
    end
    
    % Allow the user the chance to modify:
    editorOptions.mergeWithOriginal = false;
    [modifiedOptions, tf] = optionsEditor(optionsPruned, editorOptions);
    if(~tf), return; end
    
    globalOptions = mergeStruct(modifiedOptions,optionsFull);
    
    % If any fields were deleted, we should delete them in the final output
    % too, since that's probably what the user wants:
    changes = setdiff(fieldnames(optionsPruned),fieldnames(modifiedOptions));
    for i = 1:length(changes)
       if(isfield(optionsPruned,changes{i}) && ~isfield(modifiedOptions,changes{i}))
          globalOptions = rmfield(globalOptions,changes{i}); 
       end
    end
    
    settings.options = globalOptions;
    
    % Some checks for modification of the results destination path:
    newResultsPath = getGlobalOption('resultsPath');
    if(~isequal(originalResultsPath,newResultsPath))
        if(~structFieldPathExists(settings,newResultsPath))
           answer = questdlg('The new results destination path you specified does not exist yet. Do you want to create it now?','Create Path?','Yes','Cancel','Cancel');
           if(isequal(answer,'Yes'))
               eval(sprintf('%s = struct();',newResultsPath));
               redrawResultsManagerTab;
           else
               setGlobalOption('resultsPath',originalResultsPath);
           end
        end
    end
    
    % Some checks for modification of the control variable root path:
    newControlVariablePath = getGlobalOption('controlVariablePath');
    if(~isequal(originalControlVariablePath,newControlVariablePath))
        if(~structFieldPathExists(settings,newControlVariablePath))
           answer = questdlg('The new control variable root path you specified does not exist yet. Do you want to create it now?','Create Path?','Yes','Cancel','Cancel');
           if(isequal(answer,'Yes'))
               eval(sprintf('%s = struct();',newControlVariablePath));
               redrawControlVariableEditorTab;
           else
               setGlobalOption('controlVariablePath',originalControlVariablePath);
           end
        end
    end

end