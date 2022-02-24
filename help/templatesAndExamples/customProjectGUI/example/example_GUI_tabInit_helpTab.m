% =========================================================================
% The "Help" GUI tab
% =========================================================================
% Promethean Toolkit
% Benjamin Hershberg, 2020
function example_GUI_tabInit_helpTab( tabPointer )

    textDisplayOptions.FontWeight = 'bold';
    
    placeButton(tabPointer,20, 1,'Program Chip',{@CB_programNoC});
    placeButton(tabPointer,20, 2,'Refresh This Tab',{@CB_refreshTab, tabPointer.Title});
    placeButton(tabPointer, 20, 3, 'Open This Tab GUI File',{@CB_openFile,mfilename()}); % you can attach a callback function directly like this

% === Tutorials
    panel_gettingStarted = placePanel(tabPointer, [1 14], [1 2.15], 'Tutorials',textDisplayOptions);
    col = 1; row = 1;
    row = row+1; placeButton(panel_gettingStarted,row,col,'Intro to Promethean Toolkit',{@CB_openFile, 'gettingStarted__introToPrometheanToolkit.m'});
    row = row+1; placeText(panel_gettingStarted,row,col,'Core Modules:',textDisplayOptions);
    row = row+1; placeButton(panel_gettingStarted,row,col,'File Manager',{@CB_openFile, 'gettingStarted__fileManager.m'});
    row = row+1; placeButton(panel_gettingStarted,row,col,'Control Variables',{@CB_openFile, 'gettingStarted__controlVariables.m'});
    row = row+1; placeButton(panel_gettingStarted,row,col,'Equipment Control',{@CB_openFile, 'gettingStarted__equipmentInterfaces.m'});
    row = row+1; placeButton(panel_gettingStarted,row,col,'Execution Manager',{@CB_openFile, 'gettingStarted__executionManager.m'});
    row = row+1; placeButton(panel_gettingStarted,row,col,'Results Manager',{@CB_openFile, 'gettingStarted__resultsManager.m'});
    row = row+1; placeText(panel_gettingStarted,row,col,'Customization:',textDisplayOptions);
    row = row+1; placeButton(panel_gettingStarted,row,col,'Programming Interface (API)',{@CB_openFile, 'gettingStarted__APIs.m'});
    row = row+1; placeButton(panel_gettingStarted,row,col,'Integrating Your Own Code',{@CB_openFile, 'gettingStarted__customProjectFunctions.m'});
    row = row+1; placeButton(panel_gettingStarted,row,col,'Creating Your Own GUI Tab',{@CB_openFile, 'gettingStarted__customGUI.m'});
    
% === Tools for Interactivity 
    panel_uiExamples = placePanel(tabPointer, [1 12], [3.6 5.95], 'Tools for Building GUIs and Interactivity',textDisplayOptions);
    
    % Interactive Pop-up Elements:
	col = 1; row = 1;
	row = row+1; placeText(panel_uiExamples,row,col,'Interactive Pop-up Elements:',textDisplayOptions);
    row = row+1; placeButton(panel_uiExamples,row,col,'Data Editor',{@CB_example_dataEditor});
    row = row+1; placeButton(panel_uiExamples,row,col,'Options Editor',{@CB_example_optionsEditor});
    row = row+1; placeButton(panel_uiExamples,row,col,'Text Editor',{@CB_example_textEditor});
    row = row+1; placeButton(panel_uiExamples,row,col,'Parametric Sweep Dialog',{@CB_example_parametricSweepDialog});
    row = row+1; placeButton(panel_uiExamples,row,col,'Radio Button Dialog',{@CB_example_radioButtonDialog});
    row = row+1; placeButton(panel_uiExamples,row,col,'Checkbox Dialog',{@CB_example_checkBoxDialog});
    row = row+1; placeButton(panel_uiExamples,row,col,'List Dialog',{@CB_example_listDialog});
    col = 2.2; row = 1;

    % Interactive Fixed Elements:
    row = row+1; placeText(panel_uiExamples,row,col,'Interactive Fixed Elements:',textDisplayOptions);
    row = row+1; placeText(panel_uiExamples,[row row + 1.5],col,'These embedded elements are very useful for building your own equipment interfaces.');
    row0 = row+1.5;
    % example button:
    row = row0; btn = placeButton(panel_uiExamples, row, col, 'Click to see what happens!'); % you can attach a callback function directly like this
    % example editable text:
    row = row+1; editBox = placeEdit(panel_uiExamples, row, [col col+0.5], 'Editable text');
    % example non-editable text:
    placeText(panel_uiExamples, row, [col+0.5 col+1], 'Fixed text');
    % example dropdown menu:
    row = row+1; dropBox = placeDropdown(panel_uiExamples, row, col, {'dropdown item #1','dropdown item #2','dropdown item #3'});
    % example of a listbox:
    row = row+1; listBox = placeListbox(panel_uiExamples, [row row + 2], col, {'listbox item #1', 'listbox item #2', 'listbox item #3'},[1]);
    % example checkbox:
    row = row+2; placeCheckbox(panel_uiExamples, row, col, 'Checkbox (state: not checked)',0, {@CB_exampleCB2});
    
    % here's an example of changing properties of a UI object after we've created it:
    btn.Callback = {@CB_exampleCB1, dropBox, editBox, listBox}; % you can also attach a callback function on a separate line like this
    btn.String = 'Click me and see what happens!';
    
    
% === Example: Intro to Custom Functions
    panel_userFunction = placePanel(tabPointer, [1 7], [2.3 3.45], 'Example: Intro to Custom Functions',textDisplayOptions);
    col = 1; row = 1;
    row = row+1; placeButton(panel_userFunction,row,col,'Run Example',@example_CB_userFunctionCallback);
    row = row+1; placeButton(panel_userFunction,row,col,'Open Tutorial',{@CB_openFile,'gettingStarted__customProjectFunctions.m'});
    row = row+1; placeButton(panel_userFunction,row,col,'Open All Example Files',{@CB_openFile,{'example_userFunction.m','example_userSubFunction.m','default_plotFunction.m','example_CB_userFunctionCallback.m','example_plotFunction.m','example_GUI_tabInit_helpTab.m'}});
    row = row+1; placeButton(panel_userFunction,row,col,'Open All Template Files',{@CB_openFile,{'template_userFunction.m','template_userFunction_withoutComments.m','template_CB_userFunctionCallback.m','template_CB_userFunctionCallback_withoutComments.m','template_plot_userFunction.m'}});

    
% === Example: Control Variable API
    panel_userFunction = placePanel(tabPointer, [7 11], [2.3 3.45], 'Example: Control Variable API',textDisplayOptions);
    col = 1; row = 1;
    row = row+1; placeButton(panel_userFunction,row,col,'Run Example',@example__CB_sweepControlVariable);
    row = row+1; placeButton(panel_userFunction,row,col,'Open All Example Files',{@CB_openFile,{'example__sweepControlVariable.m','example__plot_sweepControlVariable.m','example__CB_sweepControlVariable.m'}});

    
% === Example: Equipment Control API
    panel_userFunction = placePanel(tabPointer, [11 15], [2.3 3.45], 'Example: Equipment Control API',textDisplayOptions);
    col = 1; row = 1;
    row = row+1; placeButton(panel_userFunction,row,col,'Run Example');
    row = row+1; placeButton(panel_userFunction,row,col,'Open All Example Files',{@CB_openFile,{''}});
    
end