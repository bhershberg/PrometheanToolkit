function interfacePanel = template_createInterface(interfacePanel)

    global settings;

    % A special mode used to define a custom panel height: ---------------
    if(isnumeric(interfacePanel) && interfacePanel == -1)
       
        % *** STEP 1 ***
        % Specify the number of panel rows needed (max allowed = 17):
        % ----------------
        rowsRequested = 4; % EDITABLE VALUE
        % ----------------
        interfacePanel = rowsRequested;
        return;
    else
        initializeGraphics;
        delete(interfacePanel.Children);
    end

    % Create the interface data structure if it doesn't already exist:
    if(interfacePanel.UserData.interfaceIndex <= 0) 
        
        % *** STEP 2 ***
        % DEFINE THE INTERFACE 'TYPE' NAME---------------------
        % (must exactly match the name used in the interface definition 
        % declaration file (e.g. custom__interfaceDefinitionsInclude.m)
        interface.type = 'Tyrell Corp. Nexus-6';
        % -----------------------------------------------------
        
        % *** STEP 3 ***
        % PLACE INTERFACE-SPECIFIC FIELDS HERE:----------------
        interface.example1 = 9876.54321;
        interface.example2 = 'S21';
        interface.example3 = true;
        
        % -----------------------------------------------------
        
        % DO NOT EDIT THIS ------------------------------------
        interface.name = interfacePanel.UserData.name;
        interface.id = DataHash(now); 
        settings.lab.interfaces{end+1} = interface;
        interfacePanel.UserData.interfaceIndex = length(settings.lab.interfaces);
        % -----------------------------------------------------
        
    % Otherwise, load the pre-existing interface data:
    else 
        interface =  settings.lab.interfaces{interfacePanel.UserData.interfaceIndex};
    end
    
    
    % Draw visuals: ------------------------------------------------------
    
    % you will probably want to setup your row/col grid with these 
    % intitial values:
    row0 = 1.4;
    row = row0;
    
    % draw the standard Up/Down/Delete/Apply/OnOff buttons
    drawInterfaceBasicControls(interfacePanel); 
    
    % draw the standard access method controls (e.g. GPIB, LAN, ...)
    drawInterfaceAccessMethod(interfacePanel);
        
    % you can customize the text styles and placement options for elements:
    textBoxOptions.HorizontalAlignment = 'right';
    editBoxOptions.HorizontalAlignment = 'left';
    
    
    % *** STEP 4 ***
    % add custom visual elements relevant to the specific equipment:
    col = [1 1.4];
    placeText(interfacePanel,row, col, 'Example 1:',textBoxOptions);
    col = [1.4 2.0];
    textbox_example1 = placeEdit(interfacePanel, row, col, sprintf('%0.12g',interface.example1),editBoxOptions);
    
    col = [1 1.4];
    placeText(interfacePanel,row+1,col,'Example 2:',textBoxOptions);
    col = [1.4 2.0];
    popup_example2 = placeDropdown(interfacePanel,row+1,col,{'S11','S12','S21','S22'});
    popup_example2.Value = find(strcmp(popup_example2.String,interface.example2));
    
    col = [2.2 2.8];
    placeText(interfacePanel,row,col,'Example 3:',editBoxOptions);
    col = [2.2 2.8];
    checkbox_example3 = placeCheckbox(interfacePanel,row+1,col,'example3',interface.example3,editBoxOptions);


    % *** STEP 5 ***
    % Finally, attach all user-defined element handles above to 
    % interfacePanel.UserData so that the companion applyChanges function 
    % can access them later:
    interfacePanel.UserData.textbox_example1 = textbox_example1;
    interfacePanel.UserData.popup_example2 = popup_example2;
    interfacePanel.UserData.checkbox_example3 = checkbox_example3;

end