function createExportProfile(tabPointer, profileIndex, options)

    requestedRows = populateSubPanel(-1);
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
        tabPointer.UserData.profileTabs{1} = placeTab(tabGroup,'Execution Modules',tabPlacementOptions);
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
        tabPointer.UserData.profileTabs{tab} = placeTab(tabGroup,sprintf('Execution Modules (Tab %d)',tab),tabPlacementOptions);
        row = [1 1+options.rowSpan];
        col = [1 1+options.colSpan];
    end
    
    parent = tabPointer.UserData.profileTabs{tab};
    subPanel = placePanel(parent,row,col,'');
    subPanel.FontSize = 8; % pc and unix have different defaults for this
    subPanel.FontWeight = 'bold';
    subPanel.UserData.profileIndex = profileIndex;
    tabPointer.UserData.childrenProfiles{end+1} = subPanel;
    tabPointer.UserData.childrenTabLocations{end+1} = tab;
    vspace = 0.5;
    tabPointer.UserData.nextPosition = [max(row)+vspace min(col) tab];

end

function subPanel = populateSubPanel(subPanel, profileIndex, options )

    if(isnumeric(subPanel) && subPanel == -1)
       rowsRequested = 4; % Specify here the number of rows that the panel needs (max allowed = 17)
       subPanel = rowsRequested;
       return;
    end

    global settings;
    initializeGraphics;
    displayOptions.FontWeight = 'normal';
    
    row0 = 1.5; col0 = [1 3.9];
    
    if(profileIndex <= 0) % special 'create new' view
        subPanel.Title = 'Create a New Execution Module';
        row = row0; col = col0;
        placeText(subPanel,row,1,'Module Name:',displayOptions);
        subPanel.UserData.profileName = placeEdit(subPanel,row,[1.5 2.5],'New Module Name',displayOptions);
       
        subPanel.UserData.exportScriptName = '';
        subPanel.UserData.txtScriptName = placeText(subPanel,row+1,[1 4],sprintf('Script or Function to Execute: %s',subPanel.UserData.exportScriptName),displayOptions);
        btnBrowse = placeButton(subPanel,row+2,[1 1.5],'Browse...',{@CB_browseExportScript});
        
        placeButton(subPanel,row,[3.3 3.9],'Create Module',{@CB_addExportProfile});
        
    else % main profile view
    
        profile = settings.export.profiles{profileIndex};
        
        % legacy support for older versions:
        if(~isfield(profile,'exportScriptName'))
            profile.exportScriptName = profile.specificationFile;
        end

        % Draw the profile:
        subPanel.Title = sprintf('%s', profile.name);
        row = row0; col = [1 2.2];
        button_Export = placeButton(subPanel,row,col,'Execute');
        button_Modify = placeButton(subPanel,row+1,[1 1.6],'Edit Options');
        button_Pull = placeButton(subPanel,row+1,[1.6 2.2],'View Defaults');

        % File info / browse:
        btnBrowse = placeButton(subPanel,row+2,[1 1.5],'Browse...',{@CB_browseExportScript});
        subPanel.UserData.txtScriptName = placeText(subPanel,row+2,[1.5 4],sprintf('%s',profile.exportScriptName),displayOptions);
        
        % Export Control:
        row = row0; col = [2.3 3];
        button_Batch = placeButton(subPanel,row+0,col,'');
        button_ChipIO = placeButton(subPanel,row+1,col,'');
        
        row = row0; col = [3 3.5];
        btnBrowse = placeButton(subPanel,row+0,col,'Open File',{@CB_openFile, {profile.exportScriptName}});
        btnBrowse = placeButton(subPanel,row+1,col,'Rename Profile',{@CB_renameExportProfile});

        % Delete / Up / Down Controls:
        row = row0+0; col = [3.5 3.7]; button_Up = placeButton(subPanel,row,col,'Up');
        col = [3.7 3.9]; button_Down = placeButton(subPanel,row,col,'Dn');
        row = row + 1; col = [3.5 3.9]; button_Delete = placeButton(subPanel,row,col,'Delete');

        % Callbacks:
        button_Export.Callback = {@CB_exportProfile,subPanel};
        button_Modify.Callback = {@CB_editExportOptions,subPanel};
        button_Batch.Callback = {@CB_exportProfileBatchToggle};
        button_ChipIO.Callback = {@CB_exportProfileChipIOToggle};
        button_Delete.Callback = {@CB_deleteExportProfile,subPanel};
        button_Up.Callback = {@CB_moveExportProfileUp,subPanel};
        button_Down.Callback = {@CB_moveExportProfileDown,subPanel};
        button_Pull.Callback = {@CB_viewDefaultOptions};

        % Initialize the toggle buttons:
        CB_exportProfileBatchToggle(button_Batch); CB_exportProfileBatchToggle(button_Batch);
        CB_exportProfileChipIOToggle(button_ChipIO); CB_exportProfileChipIOToggle(button_ChipIO);
        
        % Other data:
        subPanel.UserData.exportScriptName = profile.exportScriptName;
    
    end
end