function CB_RM_refreshTab(source, event)

    global tabResultsManager;
    delete(tabResultsManager.Children);
    GUI_tabInit_ResultsManager(tabResultsManager);

end