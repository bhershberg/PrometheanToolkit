function Keithley_2602B_currentSource_applyChanges(interfacePanel)

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
        % -----------------------------------------------------
        
    catch
       warning('Parsing error.');
       return;
    end
    
    % *** STEP 2 ***
    % SAFETY CHECKS: -------------------------------------
    if(interface.current > getSafetyMaxCurrent)
        answer = questdlg(sprintf('Woah, hold on there partner. Are you really sure you want to crank this baby up to %duA?',1e6*interface.current),'Current Level Warning','Yes. How dare you question my intentions.','Oh dear god, no...','Oh dear god, no...');
        if(strcmp(answer,'Oh dear god, no...'))
            interface.current = 0;
            interfacePanel.UserData.textbox_current.String = sprintf('%d',1e6*interface.current);
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
            case {'GPIB','LAN'}
                
                if(isequal(interface.connect_method,'GPIB'))
                    connectAddr = interface.GPIB;
                else
                    connectAddr = interface.IP;
                end
                
                Ktly2602B_ctrl('GPIBAddr',connectAddr, ...
                    'Node',interface.channel, ...
                    'Non',interface.enable, ...
                    'NVset',interface.voltage_limit, ...
                    'NCset',interface.current, ...
                    'Isource',1);
            otherwise
                warning('access method ''%s'' is not supported for this interface.\nYou must update the code in %s.m to support this mode.',interface.connect_method,mfilename);
        end
    catch
        warning('Could not communicate with the instrument.\n%s\n%s',interface.name,interface.type);
    end

end