% Benjamin Hershberg, 2018
%
% Usage:
% 
%   [ handle ] = namedFigure( name, options )
% 
%   + description: Creates a figure based on a string name. This provides
%                   figure names that are much more descriptive than the
%                   default integer values in the built-in 'figure'
%                   function of Matlab.
%   + inputs:   name - string, the name of the figure
%               options - structure of options controlling how the figure
%                   is presented. Currently the only option is:
%                     + option.docked - default is 1, set to 0 to not dock
%   + outputs:  handle - the matlab graphics handle of the figure that is
%                   created.
%
function [ handle ] = namedFigure( name, options )

    hexHash = DataHash(name);
    decHash = hex2dec(hexHash(1:12)); % shortened string to meet Matlab R2020b hex2dec requirements

    figNo = round(mod(decHash,1e9));

    handle = figure(figNo);
    handle.Name = name;
    handle.NumberTitle = 'off';
    
    if(nargin > 1 && isfield(options,'docked') && ~options.docked)
        % do nothing
    else
        handle.WindowStyle = 'docked';
    end

end

