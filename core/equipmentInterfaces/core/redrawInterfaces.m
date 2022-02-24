function redrawInterfaces( tabPointer )

    global settings;
    global tabEquipmentControl;
    
    if(nargin < 1)
        tabPointer = tabEquipmentControl;
    end
    
    if(structFieldPathExists(tabPointer,'tabPointer.UserData.interfacePanel'))
        delete(tabPointer.UserData.interfacePanel);
    end
      
    profilePanel = placePanel(tabPointer,[2 21],[1 6],'');
    pParent = getpixelposition(tabPointer);
    profilePanel.Position(1) = pParent(1);              % make it as wide as possible
    profilePanel.Position(3) = pParent(3);              % make it as wide as possible
    p1 = relativePosition(tabPointer,2,1);
    p2 = relativePosition(tabPointer,3,1);
    rowSpan = p1(2) - p2(2);
    profilePanel.Position(2) = 0;                       % make it as tall as possible
    profilePanel.Position(4) = pParent(4) - rowSpan - 10;    % make it as tall as possible
    tabGroup = uitabgroup('Parent',profilePanel);
    
    tabPointer.UserData.interfacePanel = profilePanel;
    tabPointer.UserData.tabGroup = tabGroup;
    tabPointer.UserData.profileTabs = {};
    tabPointer.UserData.nextPosition = [1 1 1]; % row, col, tab
    tabPointer.UserData.childrenProfiles = {};
    tabPointer.UserData.childrenTabLocations = {};
    
    options.colSpan = 3;
    options.rowSpan = 4;

    for i = 1:length(settings.lab.interfaces)
        createEquipmentInterface(tabPointer, i, options);
    end
    
    createEquipmentInterface(tabPointer, -1, options);
    
    % Keep the tab that the user is interacting with focused:
    if(isfield(tabEquipmentControl.UserData,'focusedTab'))
        focusedTab = tabEquipmentControl.UserData.focusedTab;
        if(focusedTab <= length(tabEquipmentControl.UserData.profileTabs))
            tabEquipmentControl.UserData.tabGroup.SelectedTab = tabEquipmentControl.UserData.profileTabs{focusedTab};
        else
            tabEquipmentControl.UserData.tabGroup.SelectedTab = tabEquipmentControl.UserData.profileTabs{end};
        end
    else
        tabEquipmentControl.UserData.tabGroup.SelectedTab = tabEquipmentControl.UserData.profileTabs{1};
    end

end