function redrawExportProfiles(tabPointer)

    global settings;
    global tabExport;
    
    if(nargin < 1)
        tabPointer = tabExport;
    end
    
    if(structFieldPathExists(tabPointer,'tabPointer.UserData.profilePanel.Children'))
        delete(tabPointer.UserData.profilePanel.Children);
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
    
    tabPointer.UserData.profilePanel = profilePanel;
    tabPointer.UserData.tabGroup = tabGroup;
    tabPointer.UserData.profileTabs = {};
    tabPointer.UserData.nextPosition = [1 1 1]; % row, col, tab
    tabPointer.UserData.childrenProfiles = {};
    tabPointer.UserData.childrenTabLocations = {};
    
    options.colSpan = 3;
    options.rowSpan = 3;

    for i = 1:length(settings.export.profiles)
        createExportProfile(tabPointer, i, options);
    end
    
    createExportProfile(tabPointer, -1, options);
    
    % Keep the tab that the user is interacting with focused:
    if(isfield(tabExport.UserData,'focusedTab'))
        focusedTab = tabExport.UserData.focusedTab;
        if(focusedTab <= length(tabExport.UserData.profileTabs))
            tabExport.UserData.tabGroup.SelectedTab = tabExport.UserData.profileTabs{focusedTab};
        else
            tabExport.UserData.tabGroup.SelectedTab = tabExport.UserData.profileTabs{end};
        end
    end
    
end