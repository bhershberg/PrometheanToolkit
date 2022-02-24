function CB_RM_refresh(source, event)

    global settings;
    global tabResultsManager;
    
    if(nargin == 0)
        source = tabResultsManager.Children(1);
    end

    resultsListObj = source.Parent.UserData.resultsList;
    resultsNoteObj = source.Parent.UserData.resultsNote;
    resultsFieldsObj = source.Parent.UserData.resultsFields;
    showMode = source.Parent.UserData.dropdown_show.String{source.Parent.UserData.dropdown_show.Value};
    sortMode = source.Parent.UserData.dropdown_sort.String{source.Parent.UserData.dropdown_sort.Value};
    
    % only show the fields that contain a 'plotFunction' field
    resultsPath = getGlobalOption('resultsPath','settings.lab.results');
    if(~structFieldPathExists(settings,resultsPath))
        resultsListObj.String = {'no results to show'};
        return;
    end
    results = eval(sprintf('%s;',resultsPath));
    fnames = fieldnames(results);
    resultsNameList = {};
    resultsFieldList = {};
    resultsTimestamp = [];
    noResults = true;
    timestamp = now;
    datestr = sprintf('%s',datetime);
    for i = 1:length(fnames)
       if(isstruct(results.(fnames{i})) && ~isfield(results.(fnames{i}),'resultName'))
           % struct is missting the "name" field, so let's add it:
           eval(sprintf('%s.%s.resultName = ''%s'';',resultsPath,fnames{i}, fnames{i}))
           eval(sprintf('results.%s.resultName = ''%s'';',fnames{i}, fnames{i}))
       end
       if(isstruct(results.(fnames{i})) && ~isfield(results.(fnames{i}),'timestampCreated'))
           % struct is missting the "timestampCreated" field, so let's add it:
           eval(sprintf('%s.%s.timestampCreated = %12.12g;',resultsPath,fnames{i}, timestamp))
           eval(sprintf('%s.%s.dateCreated = ''%s'';',resultsPath,fnames{i}, datestr))
           eval(sprintf('results.%s.timestampCreated = %12.12g;',fnames{i}, timestamp))
           eval(sprintf('results.%s.dateCreated = ''%s'';',fnames{i}, datestr))
       end
       if(structFieldPathExists(results,sprintf('results.%s.plotFunction',fnames{i})))
           % if it is a plottable result, grab the internal resultName:
           resultsNameList{end+1} = results.(fnames{i}).resultName;
           resultsFieldList{end+1} = fnames{i};
           resultsTimestamp(end+1) = results.(fnames{i}).timestampCreated;
       elseif(isstruct(results.(fnames{i})) && isequal(showMode, 'Show All'))
           % if it is some unknown structure data, grab the internal resultName:
           resultsNameList{end+1} = results.(fnames{i}).resultName;
           resultsFieldList{end+1} = fnames{i};
           resultsTimestamp(end+1) = results.(fnames{i}).timestampCreated;
       elseif(isequal(showMode, 'Show All'))
           % if it is some other unkonwn format altogether, just use the field name:
           resultsNameList{end+1} = fnames{i};
           resultsFieldList{end+1} = fnames{i};
           resultsTimestamp(end+1) = 0;
       end
    end
    if(~isempty(resultsNameList))
        noResults = false;
        
        % order / sort the list:
        if(isequal(sortMode,'Sort By Name'))
            [~, ordering] = sort(lower(resultsNameList));
            resultsNameList = resultsNameList(ordering);
            resultsFieldList = resultsFieldList(ordering);
        elseif(isequal(sortMode,'Sort By Date'))
            [~, ordering] = sort(resultsTimestamp,'descend');
            resultsNameList = resultsNameList(ordering);
            resultsFieldList = resultsFieldList(ordering);
        end        
    end
    resultsListObj.String = resultsNameList;
    resultsListObj.UserData.fieldList = resultsFieldList;
    if(noResults)
        resultsListObj.String = {'no results to show'};  
        resultsListObj.Value = [];
    elseif(length(resultsNameList) < resultsListObj.Value)
       resultsListObj.Value = []; 
    end
    
    
    % also populate the results note box:
    if(noResults)
        resultsNoteObj.String = {''};
    elseif(length(resultsListObj.Value) == 1)
    	selectedResultName = resultsFieldList{resultsListObj.Value};
        if(structFieldPathExists(results,sprintf('results.%s.notes',selectedResultName)))
            resultsNoteObj.String = results.(selectedResultName).notes;
        else
            resultsNoteObj.String = {''};
        end
    elseif(isempty(resultsListObj.Value))
        resultsNoteObj.String = {'no result selected'};
    else
        resultsNoteObj.String = {};
        resultsNoteObj.String = {'Multiple results selected.','','(But you can still write a note here and apply to all selected.)'};
    end
    
    
    % also populate the results fields list:
    source.Parent.UserData.inspectFieldBtn.Enable = 'off';
    source.Parent.UserData.stateRestoreBtn.Enable = 'off';
    if(noResults)
        resultsFieldsObj.String = {''};
    elseif(length(resultsListObj.Value) == 1)
    	selectedResultName = resultsFieldList{resultsListObj.Value};
        if(isstruct(results.(selectedResultName)))
            selectedResultFields = fieldnames(results.(selectedResultName));
            resultsFieldsObj.Value = [];
            resultsFieldsObj.String = selectedResultFields;
        else
            resultsFieldsObj.String = '';
        end
    elseif(isempty(resultsListObj.Value))
        resultsFieldsObj.String = {'no result selected'};
    else
        resultsFieldsObj.String = {'multiple results selected'};
    end

end