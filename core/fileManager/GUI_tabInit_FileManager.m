% Benjamin Hershberg
% imec, 2018
function GUI_tabInit_FileManager( tabPointer )

    textStyleOptions.FontWeight = 'bold';

    panel_FileManager = uipanel('Parent',tabPointer,'Title','Load / Save A State File','Units','normalized','Position',[0.01 0.7 0.98 0.28]);
    panel_Readme = uipanel('Parent',tabPointer,'Title','Readme of Current State','Units','normalized','Position',[0.01 0.01 0.79 0.68]);
    panel_Tools = uipanel('Parent',tabPointer,'Title','Tools','Units','normalized','Position',[0.81 0.01 0.18 0.68]);

    % Settings Readme Text:
%     textEdit_Readme = uicontrol('Parent',panel_Readme,'Style','edit','String','','Units','normalized','Position',[dfx dfy 1-2*dfx 1-2*dfx],'HorizontalAlignment','left');
    textEdit_Readme = uicontrol('Parent',panel_Readme,'Style','edit','String','','Units','normalized','Position',[0.01 0.01 0.98 0.98],'HorizontalAlignment','left');
    textEdit_Readme.Max = 10000; % number of lines allowed

    % File Load:
    row = 1.5; col = 1;
    placeText(panel_FileManager,row,col,'Load state from file:',textStyleOptions);
    row = row+1; 
    textEdit_LoadSettingsFile = uicontrol('Parent',panel_FileManager,'Style','edit','String','','Units','pixels','HorizontalAlignment','left');
    textEdit_LoadSettingsFile.Position = relativePosition(panel_FileManager,row,[col+1 col+4.9]);
    btn = uicontrol('Parent',panel_FileManager,'Style','pushbutton','String','Browse...','Callback',{@CB_FM_selectFile,textEdit_LoadSettingsFile},'Units','pixels');
    btn.Position = relativePosition(panel_FileManager,row,col);
    btn = placeButton(panel_FileManager, row, [col+4.9 col+5.9],'Load',{@CB_FM_loadFile,textEdit_LoadSettingsFile,textEdit_Readme});
    
    % File Save:
    row = row+1; col = 1;
    placeText(panel_FileManager,row,col,'Save current state to:',textStyleOptions);
    row = row+1;
    checkbox_PrependDate = placeCheckbox(panel_FileManager,row,[col+1 col+2.5],'Prepend date & time to file name when saving.',0);
    checkbox_useLoadFilePath = placeCheckbox(panel_FileManager,row,[col+2.3 col+4],'Browse from same folder as load path.',1);
    btn = placeButton(panel_FileManager,row,col,'Save As...',{@CB_FM_saveFile, checkbox_PrependDate,textEdit_Readme,checkbox_useLoadFilePath,textEdit_LoadSettingsFile});
    
    % More File Management Tools:
    col = 1; row = 0.5;
    row = row+1; placeText(panel_Tools,row,col,'Edit Global Options:',textStyleOptions);
    row = row+1; btn = placeButton(panel_Tools,row,col,'Edit Global Options',@CB_FM_editGlobalOptions);
    row = row+1; placeText(panel_Tools,row,col,'Load Data From Another File:',textStyleOptions);
    row = row+1; btn = placeButton(panel_Tools,row,col,'Load Control Variables',{@CB_FM_loadCtrlFromSettingsFile});
    row = row+1; btn = placeButton(panel_Tools,row,col,'Load Equipment Interfaces',{@CB_FM_loadInterfacesFromFile});
    row = row+1; btn = placeButton(panel_Tools,row,col,'Load Execution Modules',{@CB_FM_loadExportProfilesFromFile});
    row = row+1; placeText(panel_Tools,row,col,'About:',textStyleOptions);
    row = row+1; btn = placeButton(panel_Tools,row,col,'Getting Started', {@CB_FM_gettingStarted});
    row = row+1; btn = placeButton(panel_Tools,row,col,'About',{@CB_FM_about});
       
    % Only un-comment to make life easier for development:
%     row = row+1; btn = placeButton(panel_Tools,row,col,'Refresh',{@CB_FM_refreshTab});
    
    % Imec logo:
    row = row+1;
    logo = imread(fullfile(tabPointer.UserData.scriptsDirectory,'core/common/logo.jpg'));
    logoAxes = axes('Parent',panel_Tools,'Units','pixels');
    imshow(logo,'Parent',logoAxes);
    logoAxes.Position = relativePosition(panel_Tools,row:row+4,col);

    tabPointer.UserData.textEdit_LoadSettingsFile = textEdit_LoadSettingsFile;
    tabPointer.UserData.textEdit_Readme = textEdit_Readme;
end