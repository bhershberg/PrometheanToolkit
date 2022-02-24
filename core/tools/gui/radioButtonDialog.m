% GUI tools for Promethean Toolkit
% Benjamin Hershberg, 2020
% 
% USAGE:
% 
% radioButtonDialog( 'Your Message', choices, values );
% 
% 
% DESCRIPTION:
% 
% The Radio Button Dialog allows a user to interactively choose one item among many.
% 
% 
% WORKING EXAMPLE:
% 
% choices = {'choice #1', 'choice #2', 'choice #3'};
% values = [0 1 0];
% radioButtonDialog( 'Choose something:', choices, values );
% 
function [ choices_selected, tf ] = radioButtonDialog( message, choices, values, options)

    % in the future, we might want to use the options input to allow the
    % user to adjust some display options, e.g. the number of columns.
    
    choices_selected = {};
    tf = 0;

    if(nargin < 3)
        values = zeros(1,length(choices));
        values(1) = 1;
    end
    numChoices = length(choices);

    d = dialog('Name','Select one:');
    p = relativePosition(d,[1 numChoices+4],[1 3]);
    d.Position = p + [0 0 20 20];
    movegui(d,'center');
    
    row = 1; col = [1 3];
    txtStart = placeText(d,row, col, message);
   
    row = row + 1;
    bg = uibuttongroup('Parent',d,'Units','pixels');
    bg.Position = relativePosition(d,[row row + numChoices+1],col);
    bgRow = 0;
    for i = 1:length(choices)
        bgRow = bgRow + 1;
        pBG = relativePosition(bg,bgRow, col);
        button{i} = uicontrol('Parent',bg,'Style','radio','String',choices{i},'Value',values(i),'Units','pixels','Position',pBG,'HorizontalAlignment','right');
    end
    
    row = row + bgRow + 1;
    btnOK = placeButton(d,row,1,'OK');
    btnOK.Callback = @CB_radiobuttonDialog_OKbutton;
    
    btnCANCEL = placeButton(d,row,2,'Cancel');
    btnCANCEL.Callback = @CB_radiobuttonDialog_Cancelbutton;
    
    uiwait(d);
    
    function CB_radiobuttonDialog_OKbutton(source, event)
        choices_selected = {};
        for j = 1:length(button)
            if(button{j}.Value == 1)
                choices_selected{end+1} = button{j}.String;
            end
        end
        tf = 1;
        delete(d);
    end
    function CB_radiobuttonDialog_Cancelbutton(source, event)
        choices_selected = {};
        tf = 0;
        delete(d);
    end
    
end



