function createEquipmentInterface(tabPointer, profileIndex, options)


    requestedRows = populateSubPanel(-1, profileIndex, options);
    options.rowSpan = min(requestedRows,17);

    subPanel = placeSubPanel(tabPointer, profileIndex, options);
    
    populateSubPanel(subPanel, profileIndex, options);
    

end
function subPanel = placeSubPanel(tabPointer, profileIndex, options)

    px = 0; py = 0;
    initializeGraphics;
    
    tabGroup = tabPointer.UserData.tabGroup;
    if(isempty(tabPointer.UserData.profileTabs))
        tabPlacementOptions.forceRefresh = true;
        tabPointer.UserData.profileTabs{1} = placeTab(tabGroup,'Equipment Interfaces',tabPlacementOptions);
    end
    
    % calculate the position to place the sub-Panel:
    pNext = tabPointer.UserData.nextPosition;
    row = [pNext(1) pNext(1)+options.rowSpan];
    col = [pNext(2) pNext(2)+options.colSpan];
    tab = pNext(3);
    
    parent = tabPointer.UserData.profileTabs{tab};
    
    % check for vertical overflow:
    pTest = relativePosition(parent,row,col);
    if(pTest(2) < 0)
       row = [1 1+options.rowSpan];
       col = col + options.colSpan;
    end
    
    % check for horizontal overflow:
    pContainer = getpixelposition(parent);
    pTest = relativePosition(parent,row,col);
    if(pTest(1) + pTest(3) > pContainer(3))
        tab = tab + 1;
        tabPlacementOptions.forceRefresh = true;
        tabPointer.UserData.profileTabs{tab} = placeTab(tabGroup,sprintf('Equipment Interfaces (Tab %d)',tab),tabPlacementOptions);
        row = [1 1+options.rowSpan];
        col = [1 1+options.colSpan];
    end
    
    parent = tabPointer.UserData.profileTabs{tab};
    subPanel = placePanel(parent,row,col,'');
    subPanel.FontSize = 8; % pc and unix have different defaults for this
    subPanel.FontWeight = 'bold';
    subPanel.UserData.profileIndex = profileIndex;
    subPanel.UserData.interfaceIndex = profileIndex;
    tabPointer.UserData.childrenProfiles{end+1} = subPanel;
    tabPointer.UserData.childrenTabLocations{end+1} = tab;
    tabPointer.UserData.nextPosition = [max(row) min(col) tab];

end

function subPanel = populateSubPanel(subPanel, profileIndex, options )

    global settings;
    global tabEquipmentControl;
    initializeGraphics;
    
%     delete(subPanel.Children);
    
    row0 = 1.5; col0 = [1 3.9];
    
    if(profileIndex <= 0) % special 'create new' view
        
        if(isnumeric(subPanel) && subPanel == -1)
           rowsRequested = 3; % Specify here the number of rows that the panel needs (max allowed = 17)
           subPanel = rowsRequested;
           return;
        end
        
        subPanel.Title = 'Create a New Equipment Interface Profile';
        row = row0; col = col0;
        
        placeText(subPanel,row,1,'Interface Type:');
        p = relativePosition(subPanel,row,[1.5 3]);
        popupInterfaceList = uicontrol('Parent',subPanel,'Style','popupmenu','String',tabEquipmentControl.UserData.interfaceDefinitions.list(),'Units','pixels','Position',p);
        placeText(subPanel,row+1,1,'Interface Name:');
        textbox_Name = placeEdit(subPanel,row+1,[1.5 3],'New Equipment Interface');
        button_createInterface = placeButton(subPanel,row,[3.3 3.9],'Create Interface',{@CB_initializeNewInterface,subPanel,textbox_Name,popupInterfaceList});  

        
    else % main profile view      
        
        interface = settings.lab.interfaces{profileIndex};
        
        [interfaceCreateFunction] = tabEquipmentControl.UserData.interfaceDefinitions.get(interface.type);
        
        if(isnumeric(subPanel) && subPanel == -1)
           try
               rowsRequested = interfaceCreateFunction(-1);
           catch
               rowsRequested = 3; % Specify here the number of rows that the panel needs (max allowed = 17)
           end
           subPanel = rowsRequested;
           return;
        end
        
        subPanel.Title = sprintf('%s  (%s)', interface.name, interface.type);
        subPanel.UserData.interfaceIndex = profileIndex;
        subPanel.UserData.name = interface.name;
        interfaceCreateFunction(subPanel);

    end
end