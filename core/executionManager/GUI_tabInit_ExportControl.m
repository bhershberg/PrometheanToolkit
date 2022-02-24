function tabPointer = GUI_tabInit_ExportControl( tabPointer )

    global settings;
    initializeGraphics;

    delete(tabPointer.Children);
    if(~structFieldPathExists(settings,'settings.export.profiles')), settings.export.profiles = {}; end
    if(~structFieldPathExists(settings,'settings.export.options')), settings.export.options = {}; end
    
%     button_createNewProfile = placeButton(tabPointer,1,1,'Create New Export Profile',{@CB_addExportProfile});
    button_exportAll = placeButton(tabPointer,1,1,'Batch Execute',{@CB_batchExport});
    button_exportAll.BackgroundColor = green;
    button_batchAllOn = placeButton(tabPointer,1,2,'Batch Execute: Select All',{@CB_exportBatchAllOn});
    button_batchAllOff = placeButton(tabPointer,1,3,'Batch Execute: Clear All',{@CB_exportBatchAllOff});
    button_programChip = placeButton(tabPointer,1,4,'Program Chip',{@CB_programNoC});
    button_programChip.BackgroundColor = blue;
    placeButton(tabPointer,1,6,'Help & Getting Started',{@CB_openFile, 'gettingStarted__executionManager.m'});
    
    redrawExportProfiles(tabPointer);

end