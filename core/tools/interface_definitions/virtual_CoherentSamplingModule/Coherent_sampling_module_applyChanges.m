function Coherent_sampling_module_applyChanges(interfacePanel)

    global settings;
    global tabEquipmentControl;
    
    idx = interfacePanel.UserData.interfaceIndex;
    interface = settings.lab.interfaces{idx};

    % PARSE INPUT FROM GUI: ----------------------------------------------
    try
        
        % Parses the basic panel controls placed by drawInterfaceBasicControls(interfacePanel); 
        interface = parseCommonControls(interfacePanel, interface);
        
        % *** STEP 1 ***
        % PARSE CUSTOM FIELDS ---------------------------------
        Npoints = round(str2num(interfacePanel.UserData.edit_Npoints.String));
        Npoints = 2^ceil(log(Npoints)/log(2));
    
        Nprecision = round(str2num(interfacePanel.UserData.edit_Nprecision.String));
        
        sigid = interfacePanel.UserData.idlist{interfacePanel.UserData.menu_sigsource.Value};
        clkid = interfacePanel.UserData.idlist{interfacePanel.UserData.menu_clksource.Value};
        
        interface.signal_source_id = sigid;
        interface.clock_source_id = clkid;
        interface.fft_size = Npoints;
        interface.precision = Nprecision;

        interfacePanel.UserData.edit_Npoints.String = sprintf('%u',Npoints);
        interfacePanel.UserData.edit_Nprecision.String = sprintf('%u',Nprecision);
        % -----------------------------------------------------
        
    catch
       warning('Parsing error.');
       return;
    end
    
    % APPLY UPDATES TO THE INTERFACE: ------------------------------------
    settings.lab.interfaces{idx} = interface;
    
    % Try to execute the macro function of this "virtual" device module:
    try
        if(interface.enable)
            sigindex = getInterfaceIndex(sigid);
            clkindex = getInterfaceIndex(clkid); 

            fsig = settings.lab.interfaces{sigindex}.signal_frequency;
            fclk = settings.lab.interfaces{clkindex}.clock_frequency;

            [fclk_new, fsig_new] = coherent_sampling_calculator(fclk, fsig, Npoints, Nprecision);

            settings.lab.interfaces{sigindex}.signal_frequency = fsig_new;
            settings.lab.interfaces{clkindex}.clock_frequency = fclk_new;
            settings.options.fft_size = Npoints;

            sigInterfacePanel = tabEquipmentControl.UserData.childrenProfiles{sigindex};
            sigInterfacePanel.UserData.textbox_signal_frequency.String = sprintf('%0.12g',fsig_new*1e-6);
            % execute the signal generator's pre-defined 'apply' function:
            interfaceType = settings.lab.interfaces{sigindex}.type;
            [~,interfaceApplyFunction] = tabEquipmentControl.UserData.interfaceDefinitions.get(interfaceType);
            interfaceApplyFunction(sigInterfacePanel);

            clkInterfacePanel = tabEquipmentControl.UserData.childrenProfiles{clkindex};
            clkInterfacePanel.UserData.textbox_clock_frequency.String = sprintf('%0.12g',fclk_new*1e-6);
            % execute the clock generator's pre-defined 'apply' function:
            interfaceType = settings.lab.interfaces{clkindex}.type;
            [~,interfaceApplyFunction] = tabEquipmentControl.UserData.interfaceDefinitions.get(interfaceType);
            interfaceApplyFunction(clkInterfacePanel);
        end
    catch
        warning('Macro failed to execute properly. Check that you selected valid clock and signal sources');
        return;
    end
        
end