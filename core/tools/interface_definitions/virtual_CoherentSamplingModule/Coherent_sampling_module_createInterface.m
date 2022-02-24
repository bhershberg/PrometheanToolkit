function interfacePanel = Coherent_sampling_module_createInterface(interfacePanel)

    global settings;

    % A special mode used to define a custom panel height: ---------------
    if(isnumeric(interfacePanel) && interfacePanel == -1)
       
        % *** STEP 1 ***
        % Specify the number of panel rows needed (max allowed = 17):
        % ----------------
        rowsRequested = 5; % EDITABLE VALUE
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
        interface.type = 'Coherent Sampling Module';
        % -----------------------------------------------------
        
        % *** STEP 3 ***
        % PLACE INTERFACE-SPECIFIC FIELDS HERE:----------------
        interface.signal_source_id = -1;
        interface.clock_source_id = -1;
        interface.fft_size = 2^14;
        interface.precision = 8;
        
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
    
    % Find the signal source and clock source, if they were already
    % specified:
    sigindex = 1;
    clkindex = 1;
    for i = 1:length(settings.lab.interfaces)
        % just in case the interface didn't make its own id, let's make one
        % for it:
        if(~isfield(settings.lab.interfaces{i},'id'))
            settings.lab.interfaces{i}.id = DataHash(now);
        end
        % check if it already matches our saved id's for the instruments:
        if(isequal(settings.lab.interfaces{i}.id,interface.signal_source_id))
            sigindex = i;
        elseif(isequal(settings.lab.interfaces{i}.id,interface.clock_source_id))
            clkindex = i;
        end
        namelist{i} = settings.lab.interfaces{i}.name;
        idlist{i} = settings.lab.interfaces{i}.id;
    end
    
    
    % Draw visuals: ------------------------------------------------------
    
    % you will probably want to setup your row/col grid with these 
    % intitial values:
    row0 = 1.4;
    row = row0;
    
    % draw the standard Up/Down/Delete/Apply/OnOff buttons
    drawInterfaceBasicControls(interfacePanel); 
        
    % you can customize the text styles and placement options for elements:
    textBoxOptions.HorizontalAlignment = 'right';
    editBoxOptions.HorizontalAlignment = 'left';
    
    
    % *** STEP 4 ***
    % add custom visual elements relevant to the specific equipment:
    col = [1 1.7];
    placeText(interfacePanel,row,col,'Signal source:',textBoxOptions);
    col = [1.7 2.3];
    menu_sigsource = placeDropdown(interfacePanel,row,col,namelist);
    menu_sigsource.Value = sigindex;

    col = [1 1.7];
    placeText(interfacePanel,row+1,col,'Clock source:',textBoxOptions);
    col = [1.7 2.3];
    menu_clksource = placeDropdown(interfacePanel,row+1,col,namelist);
    menu_clksource.Value = clkindex;

    col = [1 1.7];
    placeText(interfacePanel,row+2,col,'FFT size:',textBoxOptions);
    col = [1.7 2.3];
    edit_Npoints = placeEdit(interfacePanel,row+2,col,sprintf('%u',interface.fft_size));
   
    col = [1 1.7];
    placeText(interfacePanel,row+3,col,'Precision (digits):',textBoxOptions);
    col = [1.7 2.3];
    edit_Nprecision = placeEdit(interfacePanel,row+3,col,sprintf('%u',interface.precision));

    % *** STEP 5 ***
    % Finally, attach all user-defined element handles above to 
    % interfacePanel.UserData so that the companion applyChanges function 
    % can access them later:
    interfacePanel.UserData.menu_sigsource = menu_sigsource;
    interfacePanel.UserData.menu_clksource = menu_clksource;
    interfacePanel.UserData.edit_Npoints = edit_Npoints;
    interfacePanel.UserData.edit_Nprecision = edit_Nprecision;
    interfacePanel.UserData.idlist = idlist;
    interfacePanel.UserData.namelist = namelist;

end