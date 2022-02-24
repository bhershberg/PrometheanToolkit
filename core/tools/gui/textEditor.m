% GUI tools for Promethean Toolkit
% Benjamin Hershberg, 2020
% 
% USAGE:
% 
% textOut = textEditor( textIn );
% 
% 
% DESCRIPTION:
% 
% The Text Editor allows the user to create and/or edit text. Note that the 'textIn' input parameter can either be a 1D cell array or a 2D char array. The cell array option is strongly recommended because it avoids extra whitespace from being inserted.
% 
% 
% WORKING EXAMPLE:
% 
% msg = {};
% msg{end+1} = 'Logic clearly dictates that the needs of the many outweigh the needs of the few.';
% msg{end+1} = '-Spock';
% newMsg = textEditor(msg);
% 
function [text, tf, handle] = textEditor( text, parserOptions )

    if(nargin < 2), parserOptions = struct; end
    
    parser = structFieldDefaults();
    parser.add('title','Text Editor / Viewer');
    parserOptions = parser.applyDefaults(parserOptions);

    tf = false;

    numRows = 14; numCols = 3;
    d = dialog('Name',parserOptions.title);
    p = relativePosition(d,[1 numRows+1],[1 numCols+1]);
    d.Position = [0 0 p(3)+20 p(4)+20];
    movegui(d,'center');
    
   	row = 1; col = 1;
    boxHeight = numRows - 1;
    p = relativePosition(d,[row row+boxHeight],[col numCols+1]);
    txtMain = uicontrol('Parent',d,'Style','edit','String','','Units','pixels','Position',p,'HorizontalAlignment','left','Max',10000);
    if(iscell(text))
        txtMain.String = text;
    else
        txtMain.String = sprintf(text);
    end
    
    row = numRows;
    btnOK = placeButton(d,row, 1, 'OK');
    btnOK.Callback = @CB_optionsEditor_OKbutton;
    
    btnCancel = placeButton(d,row, 3, 'Cancel');
    btnCancel.Callback = @CB_optionsEditor_Cancelbutton;
    
    uiwait(d);
    
    function CB_optionsEditor_OKbutton(source, event)
        text = txtMain.String;
        tf = 1;
        delete(d);
    end

    function CB_optionsEditor_Cancelbutton(source, event)
        text = txtMain.String;
        tf = 0;
        delete(d);
    end
    
end