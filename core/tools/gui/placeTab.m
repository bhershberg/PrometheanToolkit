% GUI tools for Promethean Toolkit
% Benjamin Hershberg, 2020
%
% Description: place a tab UI element into a tabgroup UI container object.
%
% Usage:
%
%   [ handle ] = placeTab( parent, name, options_or_callback_1, options_or_callback_2)
% 
% REQUIRED INPUTS:
%   parent:     UI object - the Matlab UI 'uitabgroup' object to attach the
%                   tab to.
%   name:       string text label to display for the tab name
% OPTIONAL INPUTS:
%   options_or_callback_1:  either an options structure defining additional
%                           uicontrol parameters to assign to the UI element, or a callback
%                           function handle. See Matlab 'uicontrol', 'pushbutton' documentation for usage.
%   options_or_callback_2:  same as options_or_callback_1 above.
% OUTPUTS:
%   handle:   handle of the created tab UI object
%
% WORKING EXAMPLE:
% 
% panel = placeTab( parentTabGroup, 'Example Tab');
%
function [ handle ] = placeTab( parent, name, options_or_callback_1, options_or_callback_2)

    options = struct;
    callback = [];

    if(nargin > 2)
        if(isstruct(options_or_callback_1))
            options = options_or_callback_1;
        else
            callback = options_or_callback_1;
        end
    end
    if(nargin > 3)
        if(isstruct(options_or_callback_2))
            options = options_or_callback_2;
        else
            callback = options_or_callback_2;
        end
    end

    parser = structFieldDefaults();
    parser.add('forceRefresh',true);
    parser.add('Callback',callback);
    options = parser.applyDefaults(options);

    handle = uitab('Parent',parent,'Title',name); 

    % apply any and all options passed in to the UI element:
    fnames = fieldnames(options);
    for i = 1:length(fnames)
        if(isprop(handle,fnames{i}))
            handle.(fnames{i}) = options.(fnames{i});
        end
    end
    
    % Matlab has a bug that if you populate elements into a newly created
    % Tab before the tab is drawn, the vertical pixel position values are
    % all shifted incorrectly. I'm not sure how best to address this yet,
    % perhaps just forcing a 'drawnow'?...
    if(options.forceRefresh)
        drawnow; % this is key to include! (otherwise getpixelposition may return the wrong values when populating the tab)
    end
    pause(0.001) % drawnow doesn't seem to be sufficient in many cases. For some reason, this hack does work as far as I can tell. ¯\_(ツ)_/¯

end

