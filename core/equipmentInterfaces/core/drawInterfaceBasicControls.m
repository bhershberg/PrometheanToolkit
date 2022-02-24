function drawInterfaceBasicControls(interfacePanel)

    global settings;
    initializeGraphics;

    interface = settings.lab.interfaces{interfacePanel.UserData.interfaceIndex};
    
    parser = structFieldDefaults();
    parser.add('enable',false);
    interface = parser.applyDefaults(interface);

    % Place the standard UP/DN, Delete, Apply, ON/OFF buttons:

    row = 1.4; 
    col = [2.8 3.0];
    button_moveUp = placeButton(interfacePanel,row,col,'Up');
    col = [3.0 3.2];
    button_moveDown = placeButton(interfacePanel,row,col,'Dn');
    col = [3.2 3.4];
    button_Delete = placeButton(interfacePanel,row,col,'Del');

    col = [3.4 3.6];
    button_OnOff = placeButton(interfacePanel,row,col,'');
    col = [3.6 3.9];
    button_Apply = placeButton(interfacePanel,row,col,'Apply');
    if(interface.enable)
        button_OnOff.String = 'On';
        button_OnOff.BackgroundColor = green;
    else
        button_OnOff.String = 'Off';
        button_OnOff.BackgroundColor = red;
    end

    button_moveUp.Callback = {@CB_moveInterfaceUp};
    button_moveDown.Callback = {@CB_moveInterfaceDown};
    button_Apply.Callback = {@CB_applyInterfaceChanges};
    button_OnOff.Callback = {@CB_interfaceOnOffToggle};
    button_Delete.Callback = {@CB_deleteInterface,interfacePanel};

    interfacePanel.UserData.button_enable = button_OnOff;
    interfacePanel.UserData.button_Apply = button_Apply;
    interfacePanel.UserData.button_Delete = button_Delete;
    interfacePanel.UserData.button_moveUp = button_moveUp;
    interfacePanel.UserData.button_moveDown = button_moveDown;
    
    settings.lab.interfaces{interfacePanel.UserData.interfaceIndex} = interface;
    
end