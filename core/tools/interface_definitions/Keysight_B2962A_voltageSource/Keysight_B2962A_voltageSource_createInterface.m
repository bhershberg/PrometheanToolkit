function interfacePanel = Keysight_B2962A_voltageSource_createInterface(interfacePanel)

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
        interface.type = 'Keysight B2962A Voltage Source';
        % -----------------------------------------------------
        
        % *** STEP 3 ***
        % PLACE INTERFACE-SPECIFIC FIELDS HERE:----------------
        interface.channel = 1; %1, 2
        interface.voltage = 0;
        interface.current_limit = 1e-3;
        interface.filter = 0;
        interface.current_measured = 0; % last measurement value
        interface.measure_current = 0; % 0 or 1 toggle
        interface.is_core_supply = 0; % 0 or 1 toggle
        interface.compensate_series_resistance = 0;
        interface.series_resistance = 0;
        
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
    
    % legacy support:
    if(~isfield(interface,'measure_current')), interface.measure_current = 0; end
    if(~isfield(interface,'is_core_supply')), interface.is_core_supply = 0; end
    if(~isfield(interface,'series_resistance')), interface.series_resistance = 0; end
    if(~isfield(interface,'compensate_series_resistance')), interface.compensate_series_resistance = 0; end
    if(~isfield(interface,'measure_mode')), interface.measure_mode = '4 wire'; end
    settings.lab.interfaces{interfacePanel.UserData.interfaceIndex} = interface;
    
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
    col = [1 1.5];
    placeText(interfacePanel,row,col,'CH:',textBoxOptions);
    col = [1.5 1.8];
    menu_channel = placeDropdown(interfacePanel,row,col,{'1','2'});
    menu_channel.Value = interface.channel;
    
    col = [1 1.5];
    placeText(interfacePanel,row+1,col,'Voltage (mV):',textBoxOptions);
    col = [1.5 1.8];
    textbox_voltage = placeEdit(interfacePanel,row+1,col,sprintf('%0.12g',1e3*interface.voltage));

    col = [1 1.5];
    placeText(interfacePanel,row+2,col,'Idc Limit (mA):',textBoxOptions);
    col = [1.5 1.8];
    textbox_currentLimit = placeEdit(interfacePanel,row+2,col,sprintf('%0.12g',interface.current_limit*1e3),editBoxOptions);

    col = [1.8 2.2];
    checkbox_Filter = placeCheckbox(interfacePanel,row,col,'Noise Filter',interface.filter);
    col = [1 1.35];
    dropdown_MeasMode = placeDropdown(interfacePanel,row,col,{'2 wire','4 wire'});
    if(isequal(interface.measure_mode,'2 wire'))
        dropdown_MeasMode.Value = 1;
    else
        dropdown_MeasMode.Value = 2;
    end
    col = [2.2 2.8];
    checkbox_isCore = placeCheckbox(interfacePanel,row,col,'Is Core Vdd',interface.is_core_supply);
    
    col = [1.8 2.2];
    checkbox_Rdc = placeCheckbox(interfacePanel,row+1,col,'Series R:',interface.compensate_series_resistance);
    col = [2.2 2.4];
    textbox_Rdc = placeEdit(interfacePanel,row+1,col,sprintf('%0.12g',interface.series_resistance));
    col = [2.4 2.8];
    text_Vfinal = placeText(interfacePanel,row+1,col,'');
    
    col = [1.8 2.3];
    checkbox_measureCurrent = placeCheckbox(interfacePanel,row+2,col,'Measure Idc:',interface.measure_current);
    if(interface.measure_current)
        str = sprintf('%3.3g mA',1e3*interface.current_measured);
    else
        str = '';
    end
    col = [2.2 2.8];
    textbox_measureCurrent = placeText(interfacePanel,row+2,col,str);


    % *** STEP 5 ***
    % Finally, attach all user-defined element handles above to 
    % interfacePanel.UserData so that the companion applyChanges function 
    % can access them later:
    interfacePanel.UserData.textbox_voltage = textbox_voltage;
    interfacePanel.UserData.textbox_current_limit = textbox_currentLimit;
    interfacePanel.UserData.menu_channel = menu_channel;
    interfacePanel.UserData.checkbox_filter = checkbox_Filter;
    interfacePanel.UserData.checkbox_isCore = checkbox_isCore;
    interfacePanel.UserData.checkbox_measureCurrent = checkbox_measureCurrent;
    interfacePanel.UserData.textbox_measureCurrent = textbox_measureCurrent;
    interfacePanel.UserData.checkbox_Rdc = checkbox_Rdc;
    interfacePanel.UserData.textbox_series_resistance = textbox_Rdc;
    interfacePanel.UserData.text_Vfinal = text_Vfinal;
    interfacePanel.UserData.dropdown_MeasMode = dropdown_MeasMode;

end