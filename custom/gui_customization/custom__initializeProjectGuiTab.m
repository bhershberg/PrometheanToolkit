function custom__initializeProjectGuiTab()

    %% SETUP (DO NOT EDIT THIS) -------------------------------------------

    global settings;
    global mainGuiTabs;     % This is the main tabGroup. Attach extra custom tab to this object
    
    % Instantiate a manager object that handles custom user-defined tabs:
    manager = manageCustomTabs();
    mainGuiTabs.UserData.customTabManager = manager;
    
        
    %% CUSTOM LOGIC (USER DEFINED) ----------------------------------------
    
    manager.placeTab(mainGuiTabs, 'Help', @example_GUI_tabInit_helpTab);
    
    % Uncomment this line to draw the custom tab template:
    manager.placeTab(mainGuiTabs, 'Custom User Tab', @template_GUI_tabInit_customTab);

end