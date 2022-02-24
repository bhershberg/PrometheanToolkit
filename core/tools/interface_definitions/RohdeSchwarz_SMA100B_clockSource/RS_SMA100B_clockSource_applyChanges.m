function RS_SMA100B_clockSource_applyChanges(interfacePanel)

    global settings;
    
    idx = interfacePanel.UserData.interfaceIndex;
    interface = settings.lab.interfaces{idx};

    %% PARSE INPUT FROM GUI: ----------------------------------------------
    try
        
        interface = parseCommonControls(interfacePanel, interface);
        
        interface.clock_frequency = 1e6*str2double(interfacePanel.UserData.textbox_clock_frequency.String);
        interface.clock_power = round(1000*str2double(interfacePanel.UserData.textbox_clock_power.String))/1000;
        interface.clock_type = interfacePanel.UserData.menu_clockType.String{interfacePanel.UserData.menu_clockType.Value};
        
        switch interface.clock_type
            case 'Single Sine'
                clkSquare = 0;
                clkSE = 1;
            case 'Differential Sine'
                clkSquare = 0;
                clkSE = 0;
            case 'Differential Square'
                clkSquare = 1;
                clkSE = 0;
        end
        
    catch
       warning('Parsing error.');
       return;
    end
    
    %% SAFETY CHECKS: -----------------------------------------------------
    if(interface.clock_power > getSafetyMaxPower)
        answer = questdlg(sprintf('Woah, hold on. Are you really sure you want to kick it up to %ddBm?',interface.clock_power),'Power Level Warning','Sure, why not. What could possibly go wrong!?','Oh dear god, no...','Oh dear god, no...');
        if(strcmp(answer,'Oh dear god, no...'))
            interface.clock_power = -20;
            interfacePanel.UserData.textbox_clock_power.String = sprintf('%d',interface.clock_power);
        end
    end
    
    %% APPLY UPDATES TO THE INTERFACE: ------------------------------------
    settings.lab.interfaces{idx} = interface;
    
    

    %% BROADCAST TO THE PHYSICAL INSTRUMENT: ------------------------------
    try
        switch interface.connect_method
            case 'GPIB'
                SMB_setSig_AllInOne('GPIBAddr', interface.GPIB, ...
                    'clkOn',interface.enable, ...
                    'clkSQnotSN', clkSquare, ...
                    'clkSEnotDF',clkSE, ...
                    'clkPow', interface.clock_power, ...
                    'clkFrq', interface.clock_frequency);
            case 'LAN'
                SMB_setSig_AllInOne('GPIBAddr', interface.IP, ...
                    'clkOn',interface.enable, ...
                    'clkSQnotSN', clkSquare, ...
                    'clkSEnotDF',clkSE, ...
                    'clkPow', interface.clock_power, ...
                    'clkFrq', interface.clock_frequency);
            otherwise
                warning('access method ''%s'' is not supported for this interface.\nYou must update the code in %s.m to support this mode.',interface.connect_method,mfilename);
        end
    catch
        warning('Could not communicate with the instrument.\n%s\n%s',interface.name,interface.type);
    end

end