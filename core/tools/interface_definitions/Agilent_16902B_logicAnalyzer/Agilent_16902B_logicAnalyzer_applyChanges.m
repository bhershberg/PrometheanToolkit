function Agilent_16902B_logicAnalyzer_applyChanges(interfacePanel)

    global settings;
    
    i = interfacePanel.UserData.interfaceIndex;
    settings.lab.interfaces{i}.bus_width = round(str2double(interfacePanel.UserData.textbox_buswidth.String));
    settings.lab.interfaces{i}.own_ip_address = interfacePanel.UserData.textbox_ownIP.String;
    
end