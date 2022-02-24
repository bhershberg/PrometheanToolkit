% GUI tools for Promethean Toolkit
% Benjamin Hershberg, 2020
% 
% USAGE:
% 
% indexesSelected = listDialog( 'Your Message', choices, indexes, selectionMode );
% 
%     Accepted input formats:
% 
%     listDialog(message, list, options);
%     listDialog(message, list, idxSelected, options);
%     listDialog(message, list, idxSelected, selectionMode, options); 
% 
% DESCRIPTION:
% 
% The List Dialog allows a user to interactively choose item(s) from a list of items.
% 
% If the input parameter 'selectionMode' is not set, it will default to 'single'. To allow multiple items to be selected, set it to 'multiple' as shown in the working example below.
% 
% 
% WORKING EXAMPLE:
% 
% choices = {};
% for i = 1:30, choices{end+1} = sprintf('choice #%d',i); end
% indexes = 13:17;
% indexesSelected = listDialog('Your Message', choices, indexes, 'multiple');
% 
function [choiceIndex, tf, choiceName] = listDialog(message, list, idxSelected, selectionMode, options)

    if(nargin < 3), idxSelected = []; end
    if(nargin < 4), selectionMode = 'single'; end
    if(nargin < 5), options = struct; end
    if(nargin == 3 && isstruct(idxSelected))
        options = idxSelected; idxSelected = [];
    elseif(nargin == 4 && isstruct(selectionMode))
        options = selectionMode; options.idxSelected = idxSelected;
    elseif(nargin == 4 && ~isstruct(selectionMode))
        options.selectionMode = selectionMode; options.idxSelected = idxSelected;
    end

    parser = structFieldDefaults();
    parser.add('selectionMode','single');   % selectionMode can be: 'single' or 'multiple'
    parser.add('alphabetize',false);        % only *displays* alphabetically. Still adheres to the origianl ordering passed in by user.
    parser.add('idxSelected',idxSelected);
    parser.add('width',600);
    parser.add('height',500);
    options = parser.applyDefaults(options); 
    
    if(options.alphabetize)
        listOriginal = list;
        indexesOriginal = 1:length(list);
        [~, indexesOrdered] = sort(lower(list)); 
        listOrdered = listOriginal(indexesOrdered);
        list = listOrdered;
        [~, options.idxSelected] = ismember(options.idxSelected,indexesOrdered);
    end

    [choiceIndex,tf] = listdlg('PromptString',message,'ListString',list,'ListSize',[options.width options.height],'InitialValue',options.idxSelected,'SelectionMode',options.selectionMode);
    
    if(options.alphabetize)
       % remap back to original list order:
       list = listOriginal;
       choiceIndex = indexesOriginal(indexesOrdered(choiceIndex));
    end

    choiceName = list(choiceIndex);

end