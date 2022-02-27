% Benjamin Hershberg, 2020
%
% Template for user-defined GUI tab, with relevant usage examples
% 
% If you want to display this tab in Promethean Toolkit, add the following line of
% code to the file custom__initializeProjectGuiTab.m:
%
%   manager.placeTab(mainGuiTabs, 'Custom User Tab', @template_GUI_tabInit_customTab);
% 
function template_GUI_tabInit_customTab( tabPointer )

    textDisplayOptions.FontWeight = 'bold';
    
    % === Let's put some frequently useful buttons at the bottom:
    placeButton(tabPointer,20, 1,'Program Chip',{@CB_programNoC});
    placeButton(tabPointer,20, 2,'Refresh This Tab',{@CB_refreshTab, tabPointer.Title});
    placeButton(tabPointer, 20, 3, 'Open This Tab GUI File',{@CB_openFile,mfilename()}); % you can attach a callback function directly like this

    % === Here is an example of how to place some common UI elements:
    row = 1; col = [1 7];
    placeText(tabPointer, row, col, 'Custom User Tab', textDisplayOptions);
    placeText(tabPointer, row+1, col, 'This is just a demo. To get started on building your own custom functionality, see the ''Customization'' sub-section in the main ''Help'' tab.');
    placeText(tabPointer, row+2, col, 'You can build just about any type of GUI into this custom area, and you can use the Promethean Toolkit API to interface your custom code & tools to the functionality provided in the default tabs.');

    row = 5; col = 1;
    placeText(tabPointer,row,col,'Example Interactive Fixed Elements:',textDisplayOptions);
    row = row+1; placeText(tabPointer,[row row + 1.5],col,'These embedded elements are very useful for building your own equipment interfaces.');
    row0 = row+1.5; % note that specified rows and column can also be decimals.
    
    % example button:
    row = row0; btn = placeButton(tabPointer, row, col, 'Click to see what happens!'); % you can attach a callback function directly like this
    % example editable text:
    row = row+1; editBox = placeEdit(tabPointer, row, [col col+0.5], 'Editable text');
    % example non-editable text:
    placeText(tabPointer, row, [col+0.5 col+1], 'Fixed text');
    % example dropdown menu:
    row = row+1; dropBox = placeDropdown(tabPointer, row, col, {'dropdown item #1','dropdown item #2','dropdown item #3'});
    % example of a listbox:
    row = row+1; listBox = placeListbox(tabPointer, [row row + 4], col, {'listbox item #1', 'listbox item #2', 'listbox item #3'},[2 3]);
    % example checkbox:
    row = row+4; placeCheckbox(tabPointer, row, col, 'Checkbox (state: not checked)',0, {@CB_exampleCB2});
    
    % example of changing properties of a UI object after we've created it:
    btn.Callback = {@CB_exampleCB1, dropBox, editBox, listBox}; % you can also attach a callback function on a separate line like this
    btn.String = 'Click me and see what happens!';
    
    % Let's also add an example of a custom user function:
    row = 5; col = 3;
    placeText(tabPointer,row,col,'Example Custom Function:',textDisplayOptions);
    row = row+1; placeButton(tabPointer,row,col,'User Function Example (click me)',@example_CB_userFunctionCallback);

end