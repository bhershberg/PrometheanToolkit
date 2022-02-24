% GUI tools for Promethean Toolkit
% Benjamin Hershberg, 2020
%
% Description: place a single checkbox UI element into a UI container such as a tab or panel.
%
% Usage:
%
%   [ handle ] = placeCheckbox( parent, row, col, name, value, options_or_callback_1, options_or_callback_2)
% 
% REQUIRED INPUTS:
%   parent:     UI object - the Matlab UI element to place the element into
%   row:        integer or integer pair specifying vertical placement position 
%                   on a standard grid as defined by the function 'relativePosition'.
%   col:        integer or integer pair specifying horizontal placement position 
%                   on a standard grid as defined by the function 'relativePosition'.
%   name:       string text label to display next to the checkbox
%   value:      1 if checked, 0 if unchecked
% OPTIONAL INPUTS:
%   options_or_callback_1:  either an options structure defining additional
%                           uicontrol parameters to assign to the UI element, or a callback
%                           function handle. See Matlab 'uicontrol', 'checkbox' documentation for usage.
%   options_or_callback_2:  same as options_or_callback_1 above.
% OUTPUTS:
%   handle:         handle of the created checkbox UI object
%
% WORKING EXAMPLE:
% 
% check1 = placeCheckbox(parentTab, 1, 2, 'This is checked!', 1, @callbackFcn);
%
% options.FontWeight = 'bold';
% check2 = placeCheckbox(parentTab, 2, 2, 'This is unchecked.', 0, options);
%
function [ handle ] = placeCheckbox( parent, row, col, name, value, options_or_callback_1, options_or_callback_2)

    options = struct;
    callback = [];

    if(nargin > 5)
        if(isstruct(options_or_callback_1))
            options = options_or_callback_1;
        else
            callback = options_or_callback_1;
        end
    end
    if(nargin > 6)
        if(isstruct(options_or_callback_2))
            options = options_or_callback_2;
        else
            callback = options_or_callback_2;
        end
    end

    if(nargin < 6), options = struct; end
    parser = structFieldDefaults();
    parser.add('FontWeight','normal');
    parser.add('HorizontalAlignment','left');
    parser.add('Callback',callback);
    options = parser.applyDefaults(options);
    
    handle = uicontrol('Parent',parent,'Style','checkbox','String',name,'Value',value,'Units','pixels','HorizontalAlignment','right');

    handle.Position = relativePosition(parent,row,col);
   
    % apply any and all options passed in to the UI element:
    fnames = fieldnames(options);
    for i = 1:length(fnames)
        handle.(fnames{i}) = options.(fnames{i});
    end

end

