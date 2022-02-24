function CB_RM_resultsFields(source, event)

    global settings;

    resultsListObj = source.Parent.UserData.resultsList;
    resultsFieldsObj = source.Parent.UserData.resultsFields;
    
    resultsPath = getGlobalOption('resultsPath');
    resultName = resultsListObj.String{resultsListObj.Value};
    resultFieldName = resultsListObj.UserData.fieldList{resultsListObj.Value};
    resultField = resultsFieldsObj.String(resultsFieldsObj.Value);
    
    if(~isempty(resultField))
        source.Parent.UserData.inspectFieldBtn.Enable = 'on';
        
        eval(sprintf('result = %s.%s;',resultsPath,resultFieldName))
        stateDataFound = false;
        for i = 1:length(resultField)
           nextField = result.(resultField{i});
           if(isstruct(nextField) && isfield(nextField,'stateType') && isfield(nextField,'restoreFunction'))
               stateDataFound = true;
           end
        end
        if(stateDataFound)
            source.Parent.UserData.stateRestoreBtn.Enable = 'on';
        else
            source.Parent.UserData.stateRestoreBtn.Enable = 'off';
        end
    end

end