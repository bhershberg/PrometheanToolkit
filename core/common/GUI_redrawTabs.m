% Benjamin Hershberg
% imec, 2018
function GUI_redrawTabs(  )

    global tabControlVariableEditor;
    delete(tabControlVariableEditor.Children);
    GUI_tabInit_ControlVariableEditor(tabControlVariableEditor);

    global tabEquipmentControl;
    delete(tabEquipmentControl.Children);
    tabEquipmentControl.UserData.focusedTab = 1;
    GUI_tabInit_EquipmentControl(tabEquipmentControl);
    
    global tabResultsManager;
    delete(tabResultsManager.Children);
    GUI_tabInit_ResultsManager(tabResultsManager);
    
    global tabExport;
    delete(tabExport.Children);
    tabExport.UserData.focusedTab = 1;
    GUI_tabInit_ExportControl(tabExport);

    % If a user-defined refresh function exists, execute it:
    global mainGuiTabs;
    if(structFieldPathExists(mainGuiTabs,'mainGuiTabs.UserData.customTabManager'))
        mainGuiTabs.UserData.customTabManager.deleteAllTabs();
    end  
    custom__initializeProjectGuiTab();

end

