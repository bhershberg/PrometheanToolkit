function drawInterfaceAccessMethod(interfacePanel, options)

    global settings;
    initializeGraphics;
    
    if(nargin < 2), options = struct; end
    parser = structFieldDefaults();
    parser.add('placementRow',2.4);
    options = parser.applyDefaults(options);
    
    modesSupported = {'GPIB','LAN','Abstraction Layer'};

    interface = settings.lab.interfaces{interfacePanel.UserData.interfaceIndex};

    % make sure all required fields have something in them:
    parser = structFieldDefaults();
    parser.add('connect_method','GPIB');
    parser.add('GPIB',0);
    parser.add('IP','192.168.1.1');
    parser.add('instrument_name','unknown');
    interface = parser.applyDefaults(interface);

    row = options.placementRow; 
    col = [2.8 3.3];
    placeText(interfacePanel,row,col,'Connect Via:');
    col = [3.3 3.9];
    dropdown_connectMethod = placeDropdown(interfacePanel,row,col,modesSupported);
    dropdown_connectMethod.Callback = {@CB_connectMethod};
    for i = 1:length(modesSupported)
        if(isequal(interface.connect_method,modesSupported{i}))
            dropdown_connectMethod.Value = i;
            break;
        end
    end
    
    col = [2.8 3.3];
    text_Connect = placeText(interfacePanel,row+1,col,'');
    col = [3.3 3.9];
    edit_Connect = placeEdit(interfacePanel,row+1,col,'');
    
    interfacePanel.UserData.dropdown_connectMethod = dropdown_connectMethod;
    interfacePanel.UserData.text_Connect = text_Connect;
    interfacePanel.UserData.edit_Connect = edit_Connect;
    
    CB_connectMethod(dropdown_connectMethod);
    
end