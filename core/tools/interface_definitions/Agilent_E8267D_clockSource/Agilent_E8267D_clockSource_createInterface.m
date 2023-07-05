function interfacePanel = Agilent_E8267D_clockSource_createInterface(interfacePanel)

    global settings;
    
    % *** STEP 1 ***
    % Specify the number of panel rows needed (max allowed = 17):
    % ----------------
    rowsRequested = 4; % EDITABLE VALUE
    % ----------------

    % A special mode used to define a custom panel height: ---------------
    if(isnumeric(interfacePanel) && interfacePanel == -1)
        interfacePanel = rowsRequested;
        return;
    else
        initializeGraphics;
        delete(interfacePanel.Children);
    end

    % Create the interface data structure if it doesn't already exist:
    if(interfacePanel.UserData.interfaceIndex <= 0) 
        
        % PLACE CUSTOM FIELDS HERE: --------------
        interface.clock_frequency = 1e6;
        interface.clock_power = -20;
        % -----------------------------------------
        
        % DO NOT EDIT THIS: -----------------------
        interface.type = 'Agilent E8267D Clock Source';
        interface.name = interfacePanel.UserData.name;
        interface.id = DataHash(now); 
        settings.lab.interfaces{end+1} = interface;
        interfacePanel.UserData.interfaceIndex = length(settings.lab.interfaces);
        % -----------------------------------------
        
    % Otherwise, load the pre-existing interface data:
    else 
        interface =  settings.lab.interfaces{interfacePanel.UserData.interfaceIndex};
    end
    
    
    %% Draw visuals: ------------------------------------------------------
    
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

    % now add the visual elements:
    col = [1 1.7];
    placeText(interfacePanel,row, col, 'Clock Frequency (MHz):',textBoxOptions);
    col = [1.7 2.3];
    textbox_Frequency = placeEdit(interfacePanel, row, col, sprintf('%0.12g',interface.clock_frequency*1e-6),editBoxOptions);
    
    col = [1 1.7];
    placeText(interfacePanel,row+1,col,'Power (dBm):',textBoxOptions);
    col = [1.7 2.3];
    textbox_Power = placeEdit(interfacePanel,row+1,col,sprintf('%0.12g',interface.clock_power),editBoxOptions);

% % % % %     col = [1 1.7];
% % % % %     placeText(interfacePanel,row+2,col,'Mode:',textBoxOptions);
% % % % %     col = [1.7 2.3];
% % % % %     popup_clockType = placeDropdown(interfacePanel,row+2,col,{'Single Sine','Differential Sine','Differential Square'},editBoxOptions);
% % % % %     popup_clockType.Value = find(strcmp(popup_clockType.String,interface.clock_type));
   
    % Finally, all of your user-defined element handles to 
    % interfacePanel.UserData so that your applyChanges function can access
    % them later:
    interfacePanel.UserData.textbox_clock_frequency = textbox_Frequency;
    interfacePanel.UserData.textbox_clock_power = textbox_Power;
% % % % %     interfacePanel.UserData.menu_clockType = popup_clockType;

end