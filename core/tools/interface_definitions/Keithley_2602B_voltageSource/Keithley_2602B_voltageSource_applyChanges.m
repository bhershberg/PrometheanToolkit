function Keithley_2602B_voltageSource_applyChanges(interfacePanel)

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
        interface.voltage = 1e-3*str2double(interfacePanel.UserData.textbox_voltage.String);
        interface.current_limit = 1e-3*str2double(interfacePanel.UserData.textbox_current_limit.String);
        interface.is_core_supply = interfacePanel.UserData.checkbox_isCore.Value;
        % -----------------------------------------------------

    catch
       warning('Parsing error.');
       return;
    end
    
    % *** STEP 2 ***
    % SAFETY CHECKS: -------------------------------------
    if(interface.voltage > getSafetyMaxVoltage)
        answer = questdlg(sprintf('Are you really sure you want to go to %dmV?',1e3*interface.voltage),'Voltage Level Warning','Yeah, I''m feeling lucky today.','Oh Sweet Betsy Jane, no...','Oh Sweet Betsy Jane, no...');
        if(strcmp(answer,'Oh dear god, no...'))
            interface.voltage = 0;
            interfacePanel.UserData.textbox_voltage.String = sprintf('%d',interface.voltage);
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
                    'NVset',interface.voltage, ...
                    'NCset',interface.current_limit, ...
                    'Isource',0);
            otherwise
                warning('access method ''%s'' is not supported for this interface.\nYou must update the code in %s.m to support this mode.',interface.connect_method,mfilename);
        end
    catch
        warning('Could not communicate with the instrument.\n%s\n%s',interface.name,interface.type);
    end

end