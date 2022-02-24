function interface = parseCommonControls(interfacePanel,interface)

    GUIhandles = interfacePanel.UserData;
    
    if(isfield(GUIhandles,'button_OnOff'))
       if(isequal(GUIhandles.button_OnOff.String,'On'))
           interface.enable = 1;
       else
           interface.enable = 0;
       end
    end
    
    if(isfield(GUIhandles,'dropdown_connectMethod'))
        
        list = GUIhandles.dropdown_connectMethod.String;
        value = GUIhandles.dropdown_connectMethod.Value;
        
        interface.connect_method = list{value};
    
        switch list{value}
            case 'GPIB'
                interfacePanel.UserData.text_Connect.String = 'GPIB Address:';
                interface.GPIB = str2num(GUIhandles.edit_Connect.String);
            case 'LAN'
                interfacePanel.UserData.text_Connect.String = 'IP Address:';
                interface.IP = GUIhandles.edit_Connect.String;
            case 'Abstraction Layer'
                interfacePanel.UserData.text_Connect.String = 'Device Name:';
                interface.device_name = GUIhandles.edit_Connect.String;
        end
        
    end

end