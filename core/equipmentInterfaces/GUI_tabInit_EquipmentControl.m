% Benjamin Hershberg
% imec, 2018
function GUI_tabInit_EquipmentControl( tabPointer )

    global settings;
    initializeGraphics;

    delete(tabPointer.Children);
    if(~structFieldPathExists(settings,'settings.lab.interfaces')), settings.lab.interfaces = {}; end
    if(~structFieldPathExists(settings,'settings.options')), settings.options = {}; end
    
    initializeEquipmentInterfaceDefinitions(tabPointer);

    button_applyAll = placeButton(tabPointer,1,1,'Apply All',{@CB_applyAllInterfaces});
    button_enableAll = placeButton(tabPointer,1,2,'All On',{@CB_enableAll});
    button_enableAll.BackgroundColor = green;
    button_disableAll = placeButton(tabPointer,1,3,'All Off',{@CB_disableAll});
    button_disableAll.BackgroundColor = red;
    button_resetInstruments = placeButton(tabPointer,1,4,'Reset All Connections',{@CB_instrreset});
    placeButton(tabPointer,1,6,'Help & Getting Started',{@CB_openFile, 'gettingStarted__equipmentInterfaces.m'});
    
    redrawInterfaces(tabPointer);
    
end