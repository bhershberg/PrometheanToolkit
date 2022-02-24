function CB_RM_stateRestoreBtn(source, event)

    global settings;

    answer = questdlg('Are you sure you want overwrite the current state with this data?','Confirm state restoration','Yes','No','No');
    if(isequal(answer,'No'))
        return;
    end

    resultsListObj = source.Parent.UserData.resultsList;
    resultsFieldsObj = source.Parent.UserData.resultsFields;
    
    resultsPath = getGlobalOption('resultsPath');
    resultName = resultsListObj.String{resultsListObj.Value};
    resultFieldName = resultsListObj.UserData.fieldList{resultsListObj.Value};
    resultField = resultsFieldsObj.String(resultsFieldsObj.Value);
    
    if(~isempty(resultField))
        eval(sprintf('result = %s.%s;',resultsPath,resultFieldName))
        msg = {};
        for i = 1:length(resultField)
            try
               nextField = result.(resultField{i});
               if(isstruct(nextField) && isfield(nextField,'stateType') && isfield(nextField,'restoreFunction'))
                   nextField.restoreFunction(nextField.stateData);
               end
               msg{end+1} = sprintf('Sucessfully restored %s state data.',nextField.stateType);
            catch
               msg{end+1} = sprintf('Failed to restore %s state data.',nextField.stateType);
            end
        end
        msgbox(msg);
    end

end