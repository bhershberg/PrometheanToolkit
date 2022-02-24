function interfacePanel = Agilent_16902B_logicAnalyzer_createInterface(interfacePanel)

    global settings;

    % A special mode used to define a custom panel height: ---------------
    if(isnumeric(interfacePanel) && interfacePanel == -1)
       
        % *** STEP 1 ***
        % Specify the number of panel rows needed (max allowed = 17):
        % ----------------
        rowsRequested = 5.5; % EDITABLE VALUE
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
        interface.type = 'Agilent 16902B Logic Analyzer';
        % -----------------------------------------------------
        
        % *** STEP 3 ***
        % PLACE INTERFACE-SPECIFIC FIELDS HERE:----------------
        interface.type = 'Agilent 16902B Logic Analyzer';
        interface.handle = [];
        interface.captured_data = [];
        interface.configuration_file = [];
        interface.own_ip_address = '0.0.0.0';
        interface.bus_width = 14;
        interface.capture_function = @Agilent_16902B_logicAnalyzer_capture;
        
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
    if(~isfield(interface,'own_ip_address')), interface.own_ip_address = '10.90.1.37'; end
    if(~isfield(interface,'capture_function')), interface.capture_function = @Agilent_16902B_logicAnalyzer_capture; end
    settings.lab.interfaces{interfacePanel.UserData.interfaceIndex} = interface;
    
    % Draw visuals: ------------------------------------------------------
    
    % you will probably want to setup your row/col grid with these 
    % intitial values:
    row0 = 1.4;
    row = row0;
    
    % draw the standard Up/Down/Delete/Apply/OnOff buttons
    drawInterfaceBasicControls(interfacePanel); 
    
    % draw the standard access method controls (e.g. GPIB, LAN, ...)
%     drawInterfaceAccessMethod(interfacePanel);
        
    % you can customize the text styles and placement options for elements:
    textBoxOptions.HorizontalAlignment = 'right';
    editBoxOptions.HorizontalAlignment = 'left';
    
    
    % *** STEP 4 ***
    % add custom visual elements relevant to the specific equipment:

    col = [1 2.0];
    placeText(interfacePanel,row,col,'Capture Output Bit Width:');
    col = [2.0 2.4];
    textbox_buswidth = placeEdit(interfacePanel,row,col,sprintf('%0.12g',interface.bus_width),editBoxOptions);

    col = [1 2.0];
    placeText(interfacePanel,[row+1 row+3],col,sprintf('Local IP (matlab machine):'));
    col = [2.0 2.4];
    textbox_ownIP = placeEdit(interfacePanel,row+1,col,interface.own_ip_address,editBoxOptions);

    col = [1 1.6];
    button_select = placeButton(interfacePanel,row+2,col,'Select Config File...');
    col = [1.6 2.2];
    button_open = placeButton(interfacePanel,row+2,col,'Open / Connect');
    col = [2.2 2.8];
    button_close = placeButton(interfacePanel,row+2,col,'Close / Reset');
    col = [2.8 3.4];
    button_capture = placeButton(interfacePanel,row+2,col,'Capture');
    
    col = [1 1.5];
    placeText(interfacePanel, row+3, col, 'Current Config File:');
    col = [1.5 3.9];
    text_configFile = placeText(interfacePanel,[row+3 row+5],col,interface.configuration_file);


    % *** STEP 5 ***
    % Finally, attach all user-defined element handles above to 
    % interfacePanel.UserData so that the companion applyChanges function 
    % can access them later:
    button_select.Callback = @CB_Ag16902B_logicAnalyzerConfigFileSelect;
    button_capture.Callback = {@CB_Ag16902B_logicAnalyzerCaptureConnect,1};
    button_close.Callback = @CB_Ag16902B_logicAnalyzerCloseConnection;
    button_open.Callback = {@CB_Ag16902B_logicAnalyzerCaptureConnect,0};
    
    interfacePanel.UserData.textbox_buswidth = textbox_buswidth;
    interfacePanel.UserData.textbox_ownIP = textbox_ownIP;
    interfacePanel.UserData.text_configFile = text_configFile;
    interfacePanel.UserData.interfaceName = interface.name;

end