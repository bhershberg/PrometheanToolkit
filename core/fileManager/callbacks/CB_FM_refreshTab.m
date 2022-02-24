function CB_FM_refreshTab(source, event)

    global tabFileManager;
    delete(tabFileManager.Children);
    GUI_tabInit_FileManager(tabFileManager);

end