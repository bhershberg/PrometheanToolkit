function CB_refreshTab(source, event, tabName)

    global mainGuiTabs;
    mainGuiTabs.UserData.customTabManager.deleteAllTabs();
    custom__initializeProjectGuiTab();
    
    selectTab(tabName);

end