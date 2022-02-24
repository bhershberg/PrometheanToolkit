function CB_RM_inspectFieldBtn(source, event)

    global settings;
    
    editorOptions.printSubStructures = true;
    editorOptions.printLongVectors = false;
    editorOptions.printCells = true;
    editorOptions.lengthLimit = 1001;

    resultsListObj = source.Parent.UserData.resultsList;
    resultsFieldsObj = source.Parent.UserData.resultsFields;
    
    resultsPath = getGlobalOption('resultsPath');
    resultName = resultsListObj.String{resultsListObj.Value};
    resultFieldName = resultsListObj.UserData.fieldList{resultsListObj.Value};
    resultField = resultsFieldsObj.String(resultsFieldsObj.Value);
    
    data = struct;
    for i = 1:length(resultField)
        eval(sprintf('data.%s = %s.%s.%s;',resultField{i},resultsPath,resultFieldName,resultField{i}));
    end
    
    try
        dataEditor(data, 'result', editorOptions);
    catch
        msgbox('Could not determine data type.');
    end
end