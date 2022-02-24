function CB_FM_gettingStarted(source, event)

    global mainGuiTabs;
    
    selectTab('Help');
    
    CB_openFile([],[],'gettingStarted__introToPromethean Toolkit.m');
    CB_openFile([],[],'gettingStarted__fileManager.m');

end