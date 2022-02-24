function CB_RM_attachNote(source, event)

    global settings;

    resultsListObj = source.Parent.UserData.resultsList;
    resultsNoteObj = source.Parent.UserData.resultsNote;
    resultsFieldsObj = source.Parent.UserData.resultsFields;
    
    resultsPath = getGlobalOption('resultsPath');
    if(~structFieldPathExists(settings,resultsPath)), return; end
    results = eval(sprintf('%s;',resultsPath));
    
    if(isempty(resultsListObj.Value))
        msgbox('No result selected.'); return;
    end
    
    if(length(resultsListObj.Value) > 1)
       answer = questdlg('Apply to all Results selected?','Apply to all?','Apply to All','Cancel','Cancel');
       if(isequal(answer,'Cancel'))
           return;
       end
    end
    
    for i = 1:length(resultsListObj.Value)
    	selectedResultFieldName = resultsListObj.UserData.fieldList{resultsListObj.Value(i)};
        eval(sprintf('%s.%s.notes = resultsNoteObj.String;',resultsPath,selectedResultFieldName));
    end
    
end