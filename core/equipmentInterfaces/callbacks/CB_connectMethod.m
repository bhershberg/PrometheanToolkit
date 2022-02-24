function CB_connectMethod(source, event)

    global settings;
    interfacePanel = source.Parent;
    interface = settings.lab.interfaces{interfacePanel.UserData.interfaceIndex};
    
    parser = structFieldDefaults();
    parser.add('connect_method','GPIB');
    parser.add('GPIB',0);
    parser.add('IP','192.168.1.1');
    parser.add('device_name','name here');
    interface = parser.applyDefaults(interface);

    list = interfacePanel.UserData.dropdown_connectMethod.String;
    value = interfacePanel.UserData.dropdown_connectMethod.Value;
    
    switch list{value}
        case 'GPIB'
            interfacePanel.UserData.text_Connect.String = 'GPIB Address:';
            interfacePanel.UserData.edit_Connect.String = num2str(interface.GPIB);
        case 'LAN'
            interfacePanel.UserData.text_Connect.String = 'IP Address:';
            interfacePanel.UserData.edit_Connect.String = interface.IP;
        case 'Abstraction Layer'
            interfacePanel.UserData.text_Connect.String = 'Device Name:';
            interfacePanel.UserData.edit_Connect.String = interface.device_name;
    end

end