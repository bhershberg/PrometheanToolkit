% Benjamin Hershberg
% imec, 2018
function GUI_tabInit_ControlVariableEditor( tabPointer )

global settings;

px = 0; py = 0; pw = 0; ph = 0;
initializeGraphics;

% panel_ChipControl = uipanel('Parent',tabPointer,'Title','Chip Control','Position',[dfx dfy 0.98 0.28]);
panel_SettingsBrowser  = placePanel(tabPointer,[1 20], [1 7.1],'Settings Browser and Editor');
placeButton(tabPointer,20,1,'Program Chip',{@CB_programNoC});
placeButton(tabPointer,20,2,'Refresh',{@CB_CVE_refresh});
placeButton(tabPointer,20,6,'Help & Getting Started',{@CB_openFile, 'gettingStarted__controlVariables.m'});

if(isempty(getGlobalOption('controlVariablePath')))
    setGlobalOption('controlVariablePath','settings.ctrl');
end
rootPath = getGlobalOption('controlVariablePath');
breadcrumb = strsplit(rootPath,'.');

if(structFieldPathExists(settings,rootPath) && isstruct(eval(rootPath)) && ~isempty(fieldnames(eval(rootPath))))
    fnames = fieldnames(eval(rootPath));
    [~, alpha_idx] = sort(lower(fnames));
    menu_options = fnames(alpha_idx);
else
    menu_options = {};
end
if(isempty(menu_options))
    menu_options = {'no settings loaded...'};
else
    menu_options = {'choose...' menu_options{1:end}};
end
menu_settings = uicontrol('Parent',panel_SettingsBrowser,'Style','popupmenu','String',menu_options,'Callback',@CVE_makeSubObject,'Units','normalized','Position',[dfx 1-2*dfy-dfh 1.5*dfw dfh]);
menu_settings.UserData.breadcrumb = breadcrumb;
menu_settings.UserData.childMenu = [];
menu_settings.UserData.parentPanel = panel_SettingsBrowser;

end