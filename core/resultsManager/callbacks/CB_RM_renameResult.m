function CB_RM_renameResult(source, event)

    global settings;

    resultsListObj = source.Parent.UserData.resultsList;
    resultsNoteObj = source.Parent.UserData.resultsNote;
    resultsFieldsObj = source.Parent.UserData.resultsFields;
    
    if(isempty(resultsListObj.String) || isequal(resultsListObj.String{1},'no results to show'))
        return;
    elseif(isempty(resultsListObj.Value))
        msgbox('No result is selected.');
    elseif(length(resultsListObj.Value) > 1)
        msgbox('Multiple results selected (choose only one)');
    else
        resultsName = resultsListObj.String{resultsListObj.Value};
        resultsFieldName = resultsListObj.UserData.fieldList{resultsListObj.Value};
        resultsPath = getGlobalOption('resultsPath');
        
        answer = inputdlg('Rename to:','Rename a Result',[1 100],{resultsName});
        if(~isempty(answer) && ~isempty(answer{1}) && ~isequal(resultsName,answer{1}))
            newName = answer{1};
            eval(sprintf('result = %s.%s;',resultsPath,resultsFieldName));
            eval(sprintf('%s = rmfield(%s,''%s'');',resultsPath,resultsPath,resultsFieldName));
            addResult(result, newName);
        end
    end
    
    resultsListObj.Value = [];
    CB_RM_refresh(source, event);

end

%         oldName = resultsListObj.String{resultsListObj.Value(1)};
%         answer = inputdlg('Rename to:','Rename a Result',[1 100],{oldName});
%         if(~isempty(answer) && ~isempty(answer{1}))
%             newName = answer{1};
%             eval(sprintf('result = %s.%s;',resultsPath,oldName));
%             if(isfield(result, 'resultName'))
%                 
%             end
%             if(~isvarname(newName))
%                 if(length(newName) > namelengthmax)
%                     msgbox(sprintf('Name exceeds max length of %d. Rename canceled.',namelengthmax),'Invalid Name');
%                 else
%                     msgbox('New name contains forbidden characters. Rename canceled.','Invalid Name');
%                 end
%             elseif(~isequal(newName,oldName))
%                 eval(sprintf('%s.%s = %s.%s;',resultsPath,newName,resultsPath,oldName));
%                 eval(sprintf('%s = rmfield(%s,''%s'');',resultsPath,resultsPath,oldName));
%             end
%         end
