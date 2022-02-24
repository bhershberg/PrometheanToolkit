function template_applyInterface(interfacePanel)

    global settings;
    
    idx = interfacePanel.UserData.interfaceIndex;
    interface = settings.lab.interfaces{idx};

    % PARSE INPUT FROM GUI: ----------------------------------------------
    try
        
        % Parses the basic panel controls placed by drawInterfaceBasicControls(interfacePanel); 
        interface = parseCommonControls(interfacePanel, interface);
        
        % *** STEP 1 ***
        % PARSE CUSTOM FIELDS ---------------------------------
        interface.example1 = str2double(interfacePanel.UserData.textbox_example1.String);
        interface.example2 = interfacePanel.UserData.popup_example2.String{interfacePanel.UserData.popup_example2.Value};
        interface.example3 = interfacePanel.UserData.checkbox_example3.Value;
        % -----------------------------------------------------
        
    catch
       warning('Parsing error.');
       return;
    end
    
    % *** STEP 2 ***
    % SAFETY CHECKS: -------------------------------------
    if(interface.example1 > 9000)
        answer = questdlg(sprintf('Requested power level of %0.12g is over 9000!!! Are you sure you want to apply?',interface.example1),'Power Level Check','Yes. (And this is to go even further beyond!)','Limit to 9000','Limit to 9000');
        if(strcmp(answer,'Limit to 9000'))
            interface.example1 = 9000;
            interfacePanel.UserData.textbox_example1.String = sprintf('%0.12g',interface.example1);
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
                example_driver_function('GPIB', interface.GPIB, ...
                    'ctrl1',interface.example1, ...
                    'ctrl2',interface.example2, ...
                    'ctrl3',interface.example3);
            case 'LAN'
                example_driver_function('LAN', interface.LAN, ...
                    'ctrl1',interface.example1, ...
                    'ctrl2',interface.example2, ...
                    'ctrl3',interface.example3);
            otherwise
                warning('access method ''%s'' is not supported for this interface.\nYou must update the code in %s.m to support this mode.',interface.connect_method,mfilename);
        end
    catch
        warning('Could not communicate with the instrument.\n%s\n%s',interface.name,interface.type);
    end

end