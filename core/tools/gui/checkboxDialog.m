% GUI tools for Promethean Toolkit
% Benjamin Hershberg, 2020
% 
% USAGE:
% 
% checkboxDialog( 'Your Message', choices, values );
% 
% 
% DESCRIPTION:
% 
% The Checkbox Dialog allows a user to interactively choose an unrestricted number of items among many.
% 
% 
% WORKING EXAMPLE:
% 
% choices = {'choice #1', 'choice #2', 'choice #3'};
% values = [0 1 0];
% checkboxDialog( 'Choose something:', choices, values );
% 
function [ choices_selected, tf, values ] = checkboxDialog( message, choices, values, options)
    
    % in the future, we might want to use the options input to allow the
    % user to adjust some display options, e.g. the number of columns.

    choices_selected = {};
    tf = 0;

    if(nargin < 3)
        values = ones(1,length(choices));
    end
    numChoices = length(choices);

    d = dialog('Position',[0 0 0 0],'Name','Select one or more');
    p = relativePosition(d,[1 numChoices+3],[1 3]);
    d.Position = p + [0 0 20 20];
    movegui(d,'center');
    
    row = 1; col = [1 3];
    txtStart = placeText(d,row, col, message);
   
    for i = 1:length(choices)
        row = row + 1;
        checkbox{i} = placeCheckbox(d,row,col,choices{i},values(i));
    end

    row = row + 1;
    btnOK = placeButton(d,row,1,'OK');
    btnOK.Callback = @CB_checkboxDialog_OKbutton;
    
    btnCANCEL = placeButton(d,row,2,'Cancel');
    btnCANCEL.Callback = @CB_checkboxDialog_CANCELbutton;
    
    uiwait(d);
    
    function CB_checkboxDialog_OKbutton(source, event)
        choices_selected = {};
        for j = 1:length(checkbox)
            if(checkbox{j}.Value == 1)
                choices_selected{end+1} = checkbox{j}.String;
                values(j) = 1;
            else
                values(j) = 0;
            end
        end
        tf = 1;
        delete(d);
    end

    function CB_checkboxDialog_CANCELbutton(source, event)
        choices_selected = {};
        tf = 0;
        delete(d);
    end
    
end



