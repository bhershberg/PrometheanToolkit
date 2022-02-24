% This function is intended to make figure export a bit easier and a bit
% more standardized. To begin with, I'm keeping it fairly simple, but it
% can certainly be added on to in the future. ~BH
function exportFigure(options)

    nameAllFigures;

    if(nargin < 1), options = struct; end
    parser = structFieldDefaults();
    parser.add('debug',true);
    parser.add('blacklist',{});
    options = parser.applyDefaults(options);

    list = {};
    handles = {};
    figHandles = findobj('Type', 'figure');
    for i = 1:length(figHandles)
        h = figHandles(i);
        if(~blackListed(h.Name,options.blacklist))
            list{end+1} = h.Name;
            handles{end+1} = h;
        end
    end
    
    if(isempty(list))
        msgbox('No figures available for export.');
        return;
    end

    [idx,tf] = listdlg('PromptString','Select figure:','ListString',list,'SelectionMode','multiple','ListSize',[500 500]);
    if(~tf), return; end
    h = handles(idx);

    list = {};
    dimensions = {};
    
    list{end+1} = 'Custom (Specify)';
    dimensions{end+1} = [100 100 600 300];
    customIdx = length(list);
    
    list{end+1} = 'Report (A4 wide)';
    dimensions{end+1} = [100 100 600 300];
    
    list{end+1} = 'Report (50% width)';
    dimensions{end+1} = [100 100 300 300];
    
    list{end+1} = 'Report (25% width)';
    dimensions{end+1} = [100 100 150 300];
    
    list{end+1} = 'Report (200% height)';
    dimensions{end+1} = [100 100 600 600];
    
    list{end+1} = 'PowerPoint slide (w=0.5 h=1)';
    dimensions{end+1} = [100 100 480 380];
    
    list{end+1} = 'PowerPoint slide (w=0.25 h=1)';
    dimensions{end+1} = [100 100 220 380];
    
    list{end+1} = 'PowerPoint slide (w=0.25 h=0.5)';
    dimensions{end+1} = [100 100 220 180];
    
    list{end+1} = 'PowerPoint slide (w=0.5 h=0.5)';
    dimensions{end+1} = [100 100 480 180];
    
    list{end+1} = 'Journal (Horiz Rect)';
    dimensions{end+1} = [100 100 450 300];
    
    list{end+1} = 'Journal (Horiz Rect Shorter)';
    dimensions{end+1} = [100 100 450 200];
    
    list{end+1} = 'Journal (Square)';
    dimensions{end+1} = [100 100 300 300];
    
    list{end+1} = 'Journal (Vert Rect)';
    dimensions{end+1} = [100 100 250 300];
    
    list{end+1} = 'Conference Slide';
    dimensions{end+1} = [100 100 360 285];
    
    [idx,tf] = listdlg('PromptString','Choose dimensions:','ListString',list,'SelectionMode','single','ListSize',[500 500]);
    dim = dimensions{idx};
    
    if(idx == customIdx)
        answer = inputdlg({'Width (px):','Height (px):'},'Custom dimensions');
        dim = dimensions{customIdx};
        dim(3:4) = [str2num(answer{1}) str2num(answer{2})];
    end
    
    for i = 1:length(h)
        hi = h{i};
        hi.WindowStyle = 'normal';
        drawnow; % must do this!!
        hi.Position = dim;

        figure(hi);
        hi.WindowStyle = 'normal';
        movegui(hi,'center');
    end

end