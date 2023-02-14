function RS_SMA100B_signalSource_applyChanges(interfacePanel)

    global settings;
    
    idx = interfacePanel.UserData.interfaceIndex;
    interface = settings.lab.interfaces{idx};

    % PARSE INPUT FROM GUI: ----------------------------------------------
    try
        
        % Parses the basic panel controls placed by drawInterfaceBasicControls(interfacePanel); 
        interface = parseCommonControls(interfacePanel, interface);
        
        % *** STEP 1 ***
        % PARSE CUSTOM FIELDS ---------------------------------
        interface.signal_frequency = 1e6*str2double(interfacePanel.UserData.textbox_signal_frequency.String);
        interface.signal_power = round(1000*str2double(interfacePanel.UserData.textbox_signal_power.String))/1000;
        interface.mode = interfacePanel.UserData.menu_mode.String{interfacePanel.UserData.menu_mode.Value};
        interface.harmonic_filter = interfacePanel.UserData.checkbox_harmonic_filter.Value;
        
        mode_normal = 0;
        mode_low_Noise = 0;
        mode_low_Dist = 0;
        switch interface.mode
            case 'Normal'
                mode_normal = 1;
            case 'Low Noise'
                mode_low_Noise = 1;
            case 'Low Distortion'
                mode_low_Dist = 1;
        end
        % -----------------------------------------------------
        
    catch
       warning('Parsing error.');
       return;
    end
    
    % *** STEP 2 ***
    % SAFETY CHECKS: -------------------------------------
    if(interface.signal_power > getSafetyMaxPower)
        answer = questdlg(sprintf('Woah, hold on. Are you really sure you want to kick it up to %ddBm?',signal_power),'Power Level Warning','Sure, why not. What could possibly go wrong!?','Oh dear god, no...','Oh dear god, no...');
        if(strcmp(answer,'Oh dear god, no...'))
            signal_power = -20;
            interfacePanel.UserData.textbox_signal_power.String = sprintf('%d',signal_power);
        end
    end
    % -----------------------------------------------------
    
    % APPLY UPDATES TO THE INTERFACE: ------------------------------------
    settings.lab.interfaces{idx} = interface;
    
    
    % BROADCAST TO THE PHYSICAL INSTRUMENT: ------------------------------
    try
        % *** STEP 3 ***
        % setup your low-level drivers that communicate with the instrument
        switch interface.connect_method
            case 'GPIB'
                SMB_setSig_AllInOne('CF',interface.signal_frequency, ...
                    'PLev',interface.signal_power, ...
                    'RFOn',interface.enable, ...
                    'GPIBAddr',interface.GPIB, ...
                    'HarmRej',interface.harmonic_filter, ...
                    'NormMode',mode_normal,'LOWD',mode_low_Dist,'LOWN',mode_low_Noise);
            case 'LAN'
                SMB_setSig_AllInOne('CF',interface.signal_frequency, ...
                    'PLev',interface.signal_power, ...
                    'RFOn',interface.enable, ...
                    'GPIBAddr',interface.IP, ...
                    'HarmRej',interface.harmonic_filter, ...
                    'NormMode',mode_normal, 'LOWD',mode_low_Dist, 'LOWN', mode_low_Noise);              
            otherwise
                warning('access method ''%s'' is not supported for this interface.\nYou must update the code in %s.m to support this mode.',interface.connect_method,mfilename);
        end
    catch
        warning('Could not communicate with the instrument.\n%s\n%s',interface.name,interface.type);
    end

end