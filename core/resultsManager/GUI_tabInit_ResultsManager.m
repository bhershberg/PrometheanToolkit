function GUI_tabInit_ResultsManager( tabPointer )

    global settings;
    initializeGraphics;
    
    % only uncomment this for debug / development:
%     placeButton(tabPointer,19,6,'Refresh Tab',{@CB_RM_refreshTab});
    
    mainBoxSpan = 17;
    notesBoxSpan = 9;
    fieldsBoxSpan = 6;
    
    textDisplayOptions.FontWeight = 'bold';
    
    % Results list:
    col = 1; row = 1;
    placeText(tabPointer,row,col,'Saved Results:',textDisplayOptions);
    dropdown_sort = placeDropdown(tabPointer, row, [col+1.4 col+2.1], {'Sort By Name','Sort By Date'},@CB_RM_refresh);
    dropdown_show = placeDropdown(tabPointer, row, [col+0.7 col+1.4], {'Show All','Show Only Plottable'},@CB_RM_refresh);
    placeButton(tabPointer,row,[col+2.1 col+2.8],'Save Current State',{@saveSystemState});
    
    row = row+1; 
    resultsList = placeListbox(tabPointer,[row row+mainBoxSpan],[col col+2.8],{''});
    resultsList.Callback = {@CB_RM_resultListTouch};
    
    % Plot / Rename / Delete:
    row = row+mainBoxSpan;
    btn = placeButton(tabPointer,row,[col col+1.3],'Plot All Selected',{@CB_RM_plot});
    btn = placeButton(tabPointer,row,[col+1.3 col+2.1],'Rename Selected',{@CB_RM_renameResult});
    btn = placeButton(tabPointer,row,[col+2.1 col+2.8],'Delete All Selected',{@CB_RM_deleteResult});
       
    % Notes (and save state):
    col = 3.9; row = 1;
    placeText(tabPointer,row,[col col+2],'Result Notes:',textDisplayOptions);
    row = row+1; 
    resultsNote = placeEdit(tabPointer,[row row+notesBoxSpan], [col col+2],{''});
    resultsNote.Max = 1000;
    resultsNote.Min = 1;
    row = row + notesBoxSpan;
    placeButton(tabPointer,row,col+1,'Save Note to Selected Result(s)',{@CB_RM_attachNote});
 
    % Fields:
    row = row+1;
    placeText(tabPointer,row,[col col+2],'Result Fields:',textDisplayOptions);
    row = row + 1;
    resultsFields = placeListbox(tabPointer,[row row+fieldsBoxSpan], [col col+2],{''}, []);
    resultsFields.Callback = {@CB_RM_resultsFields};
    resultsFields.Max = 1000;
    resultsFields.Min = 1;
    
    row = row + fieldsBoxSpan;
    inspectFieldBtn = placeButton(tabPointer,row,col,'Inspect Selected Result Field(s)', @CB_RM_inspectFieldBtn);
    stateRestoreBtn = placeButton(tabPointer,row,col+1,'Restore Selected State Data(s)', @CB_RM_stateRestoreBtn);

    % REMOVED PATH SELECTION. MOST PEOPLE WON'T NEED IT, IT'S REALLY JUST A
    % LEGACY THING. AND IT CAN STILL BE DONE IN THE GLOBAL OPTIONS EDITOR
    % OF THE FILE MANAGER TAB INSTEAD...
%     % results Path selection:
%     row = 10; col = 5.5;
%     if(structFieldPathExists(settings,'settings.options.resultsPath'))
%         resultsPath = getGlobalOption('resultsPath');
%     else
%         if(~structFieldPathExists(settings,'settings.lab.results'))
%             settings.lab.results = struct;
%         end
%         resultsPath = 'settings.lab.results';
%         settings.options.resultsPath = resultsPath;
%     end
%     placeText(tabPointer,row,col,'Specify the results path to view:',textDisplayOptions);
%     row = row + 1; resultsPath = placeEdit(tabPointer,row,col,resultsPath);
%     row = row + 1; placeButton(tabPointer,row,col,'Update Result Path (Apply)',{@CB_RM_updatePath});
    
    % figure control:
    row = 1; col = 6;
    placeText(tabPointer,row,col,'Figure Control and Plot Tools:',textDisplayOptions);
	row = row+1; placeButton(tabPointer,row,col,'Export Figure(s)',{@CB_RM_exportFigure});
    row = row+1; placeButton(tabPointer,row,col,'Dock all Figures',{@CB_RM_dockAllFigures});
    row = row+1; placeButton(tabPointer,row,col,'Create Blank Figure',{@CB_RM_blankFigure});
    row = row+1; placeButton(tabPointer,row,col,'Copy a Figure',{@CB_RM_copyFigure});
    row = row+1; placeButton(tabPointer,row,col,'Rename Figure',{@CB_RM_renameFigure});
    row = row+1; placeButton(tabPointer,row,col,'Rename Trace',{@CB_RM_renameTrace});
    row = row+1; placeButton(tabPointer,row,col,'Copy Trace(s) to Other Figure',{@CB_RM_copyTracesToFigure});
    row = row+1; placeButton(tabPointer,row,col,'Move Trace(s) to Right Yaxis',{@CB_RM_sendTraceToOtherYaxis});
    row = row+1; placeButton(tabPointer,row,col,'Merge Traces',{@CB_RM_mergeTraces});
    row = row+1; placeButton(tabPointer,row,col,'Color Traces',{@CB_RM_recolorTraces});
    row = row+1; placeButton(tabPointer,row,col,'Order Traces',{@CB_RM_reorderTraces});
    
    % Set up UserData the we need to provide to the callback fuctions:
    tabPointer.UserData.resultsList = resultsList;
    tabPointer.UserData.resultsList.UserData.fieldList = {};
    tabPointer.UserData.resultsNote = resultsNote;
%     tabPointer.UserData.resultsPath = resultsPath;
    tabPointer.UserData.resultsFields = resultsFields;
    tabPointer.UserData.GUI_FigureName = tabPointer.Parent.Parent.Name;
    tabPointer.UserData.inspectFieldBtn = inspectFieldBtn;
    tabPointer.UserData.stateRestoreBtn = stateRestoreBtn;
    tabPointer.UserData.dropdown_sort = dropdown_sort;
    tabPointer.UserData.dropdown_show = dropdown_show;
    CB_RM_refresh(tabPointer.Children(1),[]);
    
    tabPointer.Parent.SelectionChangedFcn = {@CB_tabChanged};
    
end