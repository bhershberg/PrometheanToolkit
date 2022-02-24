    % =========================================
    %% PATH MANAGEMENT AND VISUAL CONFIG (DO NOT TOUCH)
    % =========================================   
    
    global settings; 
    settings = struct;
    
    if(isunix)
%         tmp = strfind(thisFile,'/');
        set(groot,'defaultuicontrolFontName','SansSerif');
        set(0,'DefaultUIControlFontSize',7);
    elseif(ispc)
%         tmp = strfind(thisFile,'\');
        set(groot,'defaultuicontrolFontName','MS Sans Serif');
        set(0,'DefaultUIControlFontSize',8);
    else
        warning('unsupported operating system!');
    end
    set(0, 'DefaultLineLineWidth', 1);
    set(0,'defaultTextInterpreter','none');
    set(0,'defaultLegendInterpreter','none');
    % =========================================

    % =========================================
    %% GENERAL PURPOSE TABS & SETTINGS (DO NOT TOUCH)
    % =========================================
    initializeGraphics;
    figureOptions.docked = false;
    GUI = namedFigure('Promethean Toolkit',figureOptions);
    GUI.Position = [50 50 guiW guiH];
    GUI.MenuBar = 'none';
    GUI.ToolBar = 'none';
    GUI.Resize = 'off';
    movegui(GUI,'center');
    global mainGuiTabs;
    mainGuiTabs = uitabgroup('Parent',GUI);
    mainGuiTabs.UserData.scriptsDirectory = scriptsDirectory;
    global tabFileManager;
    tabFileManager = placeTab(mainGuiTabs,'File Manager');
    tabFileManager.UserData.scriptsDirectory = scriptsDirectory;
    global tabControlVariableEditor;
    tabControlVariableEditor = placeTab(mainGuiTabs,'Control Variable Editor');
    global tabEquipmentControl;
    tabEquipmentControl = placeTab(mainGuiTabs,'Equipment Interfaces');
    global tabExport;
    tabExport = placeTab(mainGuiTabs,'Execution Manager');
    tabExport.UserData.scriptsDirectory = scriptsDirectory;
    global tabResultsManager;
    tabResultsManager = placeTab(mainGuiTabs,'Results Manager');
    
    matGuiTabs.UserData.scriptsDirectory = scriptsDirectory;
    
    GUI_tabInit_FileManager(tabFileManager);
    GUI_tabInit_ControlVariableEditor(tabControlVariableEditor);
    GUI_tabInit_EquipmentControl(tabEquipmentControl);
    GUI_tabInit_ExportControl(tabExport);
    GUI_tabInit_ResultsManager(tabResultsManager);
    
    custom__initializeProjectGuiTab;
    
    % =========================================