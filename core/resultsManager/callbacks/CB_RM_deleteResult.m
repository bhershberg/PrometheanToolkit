function CB_RM_deleteResult(source, event)

    global settings;

    resultsListObj = source.Parent.UserData.resultsList;
    resultsNoteObj = source.Parent.UserData.resultsNote;
    resultsFieldsObj = source.Parent.UserData.resultsFields;
    
    if(isempty(resultsListObj.Value))
        msgbox('No result is selected.');
    end
    if(isempty(resultsListObj.String) || isequal(resultsListObj.String{1},'no results to show')), return; end
    resultsName = resultsListObj.String{resultsListObj.Value};
    resultsPath = getGlobalOption('resultsPath');

    if(isempty(resultsListObj.Value))
        msgbox('No result is selected.');
    else
        answer = questdlg('Delete all selected results?','Delete all selected?','Delete','Cancel','Cancel');
        if(isequal(answer,'Cancel')), return; end
        for i = 1:length(resultsListObj.Value)
            resultFieldName = resultsListObj.UserData.fieldList{resultsListObj.Value(i)};
            eval(sprintf('%s = rmfield(%s,''%s'');',resultsPath,resultsPath,resultFieldName));
        end
    end
    
    resultsListObj.Value = [];
    CB_RM_refresh(source, event);

end