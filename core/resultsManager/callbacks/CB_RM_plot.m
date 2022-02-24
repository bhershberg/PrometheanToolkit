function CB_RM_plot(source, event)
    global settings;

    resultsListObj = source.Parent.UserData.resultsList;
    resultsNoteObj = source.Parent.UserData.resultsNote;
    resultsFieldsObj = source.Parent.UserData.resultsFields;
    
    if(isempty(resultsListObj.String) || isequal(resultsListObj.String{1},'no results to show')), return; end
    resultsName = resultsListObj.String{resultsListObj.Value};
    resultsPath = getGlobalOption('resultsPath');

    options.interactivePlot = true;
    
    for i = 1:length(resultsListObj.Value)
        resultsName = resultsListObj.String{resultsListObj.Value(i)};
        resultsFieldName = resultsListObj.UserData.fieldList{resultsListObj.Value(i)};
        eval(sprintf('results = %s.%s;',resultsPath,resultsFieldName));
        if(isfield(results,'plotFunction'))
            results.plotFunction(results, options);
        else
            msgbox(sprintf('Could not plot result:\n\n%s\n\nbecause it does not have a plotFunction assigned',resultsName));
        end
    end
end