function Keysight_B2962A_voltageSource_applyChanges(interfacePanel)

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
        interface.filter = interfacePanel.UserData.checkbox_filter.Value;
        interface.is_core_supply = interfacePanel.UserData.checkbox_isCore.Value;
        interface.measure_current = interfacePanel.UserData.checkbox_measureCurrent.Value;
        interface.compensate_series_resistance = interfacePanel.UserData.checkbox_Rdc.Value;
        interface.series_resistance = max(0,str2double(interfacePanel.UserData.textbox_series_resistance.String));
        if(interfacePanel.UserData.dropdown_MeasMode.Value == 1)
            interface.measure_mode = '2 wire';
            measMode = '2w';
        else
            interface.measure_mode = '4 wire';
            measMode = '4w';
        end
        % -----------------------------------------------------
        
    catch
       warning('Parsing error.');
       return;
    end
    
    % *** STEP 2 ***
    % SAFETY CHECKS: -------------------------------------
    if(interface.voltage > getSafetyMaxVoltage)
        answer = questdlg(sprintf('Are you really sure you want to go to %dmV?',1e3*interface.voltage),'Voltage Level Warning','Yeah, I''m feeling lucky today.','Oh dear god, no...','Oh dear god, no...');
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
        Rwire = interface.series_resistance;
        % *** STEP 3 ***
        % setup your low-level drivers that communicate with the instrument
        switch interface.connect_method
            case {'GPIB','LAN'}
                
                if(isequal(interface.connect_method,'GPIB'))
                    connectAddr = interface.GPIB;
                else
                    connectAddr = interface.IP;
                end
                if(interface.filter)
                    filterMode = 'HCULNF';
                else
                    filterMode = 'OFF';
                end
                
                voltageRequested = interface.voltage;

                % Step1: if resistance compensation is enabled, let's try to
                % estimate the IR we should expect to see:
                if(interface.measure_current && interface.compensate_series_resistance && interface.enable)
                    KS_Meas = KstB2962A_ctrl('GPIBAddr', connectAddr, ...
                        'Node',interface.channel, ...
                        'NCget',interface.channel);
                    pause(0.15);
                    Vwire = KS_Meas.c{1}.value * Rwire;
                    interface.voltage = voltageRequested + sign(Vwire)*min(abs(Vwire),50e-3); % max correction 50mV for safety
                end

                % Step2: Now apply all settings:
                if(interface.enable)
                    KS_Meas = KstB2962A_ctrl('GPIBAddr', connectAddr, ...
                        'Node',interface.channel, ...
                        'NCset', interface.current_limit, ...
                        'NVset', interface.voltage, ...
                        'ExtFilt', filterMode, ...
                        'Non', interface.enable, ...
                        'NCget',interface.channel, ...
                        'MeasMode', measMode);
                else
                    KstB2962A_ctrl('GPIBAddr', connectAddr, ...
                        'Node',interface.channel, ...
                        'NCset', interface.current_limit, ...
                        'NVset', interface.voltage, ...
                        'ExtFilt', filterMode, ...
                        'Non', interface.enable, ...
                        'MeasMode', measMode);
                    KS_Meas.c{1}.value = NaN;
                end

                % Step3: Now let's see how we did with the R compensation, and take
                % another attempt at fine-tuning it:
                if(interface.measure_current  && interface.enable)
                    if(interface.compensate_series_resistance && interface.enable)
                        Vwire = KS_Meas.c{1}.value * Rwire;
                        interface.voltage = voltageRequested + sign(Vwire)*min(abs(Vwire),100e-3); % max correction 50mV for safety
                        % reprogram:
                        pause(0.15);
                        KS_Meas = KstB2962A_ctrl('GPIBAddr', connectAddr, ...
                            'Node',interface.channel, ...
                            'NCset', interface.current_limit, ...
                            'NVset', interface.voltage, ...
                            'ExtFilt', filterMode, ...
                            'Non', interface.enable, ...
                            'NCget',interface.channel, ...
                            'MeasMode', measMode);
                    end
                    Idc = KS_Meas.c{1}.value;
                    % -------------------------------
                    settings.lab.interfaces{idx}.current_measured = Idc;
                    interfacePanel.UserData.textbox_measureCurrent.String = sprintf('%3.4g mA',1e3*Idc);
                else
                    interfacePanel.UserData.textbox_measureCurrent.String = '';
                end
                if(interface.measure_current && interface.compensate_series_resistance)
                    interfacePanel.UserData.text_Vfinal.String = sprintf('(%0.12g mV)',1e3*interface.voltage);
                else
                    interfacePanel.UserData.text_Vfinal.String = '';
                end
            otherwise
                warning('access method ''%s'' is not supported for this interface.\nYou must update the code in %s.m to support this mode.',interface.connect_method,mfilename);
        end
    catch
        warning('Could not communicate with the instrument.\n%s\n%s',interface.name,interface.type);
    end

end