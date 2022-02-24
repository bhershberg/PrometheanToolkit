function dockAllFigures(options)

    if(nargin < 1), options = struct; end
    parser = structFieldDefaults();
    parser.add('debug',true);
    parser.add('returnDefaults',false);
    parser.add('blacklist',{}); % list of figures to skip (not dock)
    options = parser.applyDefaults(options);
    if(options.returnDefaults)
        global defaultOptions; 
        defaultOptions = options; return; 
    end
%     [options, tf] = interactiveSetup(options);
%     if(~tf), return; end

    list = {};
    handles = {};
    figHandles = findobj('Type', 'figure');
    for i = 1:length(figHandles)
        h = figHandles(i);
        if(~blackListed(h.Name,options.blacklist))
            h.WindowStyle = 'docked';
        end
    end

end