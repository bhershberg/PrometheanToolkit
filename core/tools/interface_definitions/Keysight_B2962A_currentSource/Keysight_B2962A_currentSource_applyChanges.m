function Keysight_B2962A_currentSource_applyChanges(interfacePanel)

    global settings;
    
    idx = interfacePanel.UserData.interfaceIndex;
    interface = settings.lab.interfaces{idx};

    % PARSE INPUT FROM GUI: ----------------------------------------------
    try
        
        % Parses the basic panel controls placed by drawInterfaceBasicControls(interfacePanel); 
        interface = parseCommonControls(interfacePanel, interface);
        
        % *** STEP 1 ***
        % PARSE CUSTOM FIELDS ---------------------------------
        interface.channel = str2num(interfacePanel.UserData.menu_channel.String{interfacePanel.UserData.menu_channel.Value});
        interface.current = 1e-6*str2double(interfacePanel.UserData.textbox_current.String);
        interface.voltage_limit = 1e-3*str2double(interfacePanel.UserData.textbox_voltage_limit.String);
        interface.filter = interfacePanel.UserData.checkbox_filter.Value;
        % -----------------------------------------------------
        
    catch
       warning('Parsing error.');
       return;
    end
    
    % *** STEP 2 ***
    % SAFETY CHECKS: -------------------------------------
    if(interface.current > getSafetyMaxCurrent)
        answer = questdlg(sprintf('Woah, hold on there partner. Are you really sure you want to crank this baby up to %duA?',1e6*interface.current),'Current Level Warning','How dare you question my intentions.','Oh dear god, no...','Oh dear god, no...');
        if(strcmp(answer,'Oh dear god, no...'))
            interface.current = 0;
            interfacePanel.UserData.textbox_current.String = sprintf('%d',1e6*interface.current);
        end
    end
    % -----------------------------------------------------
    
    % APPLY UPDATES TO THE INTERFACE: ------------------------------------
    settings.lab.interfaces{idx} = interface;
    
    
    % BROADCAST TO THE PHYSICAL INSTRUMENT: ------------------------------
    if(interface.filter)
        filterMode = 'HCULNF';
    else
        filterMode = 'OFF';
    end
    try
        % *** STEP 3 ***
        % setup your low-level drivers that communicate with the instrument
        switch interface.connect_method
            case 'GPIB'
%                 KS_Meas = KS_B2962_CTRL_CHSELECT('GPIB_ADDR', interface.GPIB, ...
%                     'CH',interface.channel, ...
%                     'CH_VOLTLimit', interface.voltage_limit, ...
%                     'CH_I', interface.current, ...
%                     'Use_Filter', interface.filter, ...
%                     'CH_ON', interface.enable, ...
%                     'Use_as_CS',1);
            case 'LAN'
                KstB2962A_ctrl('GPIBAddr', interface.IP, ...
                        'Node',interface.channel, ...
                        'NCset', interface.current, ...
                        'NVset', interface.voltage_limit, ...
                        'ExtFilt', filterMode, ...
                        'Non', interface.enable, ...
                        'MeasMode','4w', ...
                        'Isource', 1);
%                 Vout = KS_Meas.v{1}.value
%                 'NVget',interface.channel, ...
            otherwise
                warning('access method ''%s'' is not supported for this interface.\nYou must update the code in %s.m to support this mode.',interface.connect_method,mfilename);
        end
    catch
        warning('Could not communicate with the instrument.\n%s\n%s',interface.name,interface.type);
    end

end