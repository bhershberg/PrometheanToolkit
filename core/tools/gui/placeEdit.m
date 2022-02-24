% GUI tools for Promethean Toolkit
% Benjamin Hershberg, 2020
%
% Description: place an editable text UI element into a UI container such as a tab or panel.
%
% Usage:
%
%   [ handle ] = placeEdit( parent, row, col, string, options_or_callback_1, options_or_callback_2)
% 
% REQUIRED INPUTS:
%   parent:     UI object - the Matlab UI element to place the element into
%   row:        integer or integer pair specifying vertical placement position 
%               	on a standard grid as defined by the function 'relativePosition'.
%   col:        integer or integer pair specifying horizontal placement position 
%                   on a standard grid as defined by the function 'relativePosition'.
%   string:       string text label to display in the editable box
% OPTIONAL INPUTS:
%   options_or_callback_1:  either an options structure defining additional
%                           uicontrol parameters to assign to the UI element, or a callback
%                           function handle. See Matlab 'uicontrol', 'edit' documentation for usage.
%   options_or_callback_2:  same as options_or_callback_1 above.
% OUTPUTS:
%   handle:         handle of the created editable text UI object
%
% WORKING EXAMPLE:
% 
% options.HorizontalAlignment = 'right';
% txtbox = placeEdit(parentTab, 2, 4, 'edit me!', @callbackFcn, options);
%
function [ handle ] = placeEdit( parent, row, col, string, options_or_callback_1, options_or_callback_2)

    options = struct;
    callback = [];

    if(nargin > 4)
        if(isstruct(options_or_callback_1))
            options = options_or_callback_1;
        else
            callback = options_or_callback_1;
        end
    end
    if(nargin > 5)
        if(isstruct(options_or_callback_2))
            options = options_or_callback_2;
        else
            callback = options_or_callback_2;
        end
    end           

    if(nargin < 4), string = ''; end
    parser = structFieldDefaults();
    parser.add('FontWeight','normal');
    parser.add('HorizontalAlignment','left');
    parser.add('Callback',callback);
    options = parser.applyDefaults(options);

    handle = uicontrol('Parent',parent,'Style','edit','String',string,'Units','pixels');

    handle.Position = relativePosition(parent,row,col);
    
    % apply any and all options passed in to the UI element:
    fnames = fieldnames(options);
    for i = 1:length(fnames)
        handle.(fnames{i}) = options.(fnames{i});
    end

end

