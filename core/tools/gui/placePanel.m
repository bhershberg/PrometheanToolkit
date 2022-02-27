% GUI tools for Promethean Toolkit
% Benjamin Hershberg, 2020
%
% Description: place a panel UI element into a UI container such as a tab or panel.
%
% Usage:
%
%   [ handle ] = placePanel( parent, row, col, name, options)
% 
% REQUIRED INPUTS:
%   parent:     UI object - the Matlab UI element to place the element into
%   row:        integer or integer pair specifying vertical placement position 
%                   on a standard grid as defined by the function 'relativePosition'.
%   col:        integer or integer pair specifying horizontal placement position 
%                   on a standard grid as defined by the function 'relativePosition'.
%   name:       string text label to display for the panel title
% OPTIONAL INPUTS:
%   options:  an options structure defining additional uipanel parameters to 
%               assign to the panel. See Matlab 'uipanel', documentation for usage.
% OUTPUTS:
%   handle:   handle of the created panel UI object
%
% WORKING EXAMPLE:
% 
% panel = placePanel( parentTab, [1 10], [1 3], 'Example Panel');
%
function [ handle ] = placePanel( parent, row, col, name, options)

    if(nargin < 5), options = struct; end
    if(nargin < 4), name = ''; end

    parser = structFieldDefaults();
    parser.add('Units','pixels');
    options = parser.applyDefaults(options);
       
    handle = uipanel('Parent',parent,'Title',name);
    
    % apply any and all options passed in to the UI element:
    fnames = fieldnames(options);
    for i = 1:length(fnames)
        handle.(fnames{i}) = options.(fnames{i});
    end
    
    handle.Position = relativePosition(parent,row,col);

end

