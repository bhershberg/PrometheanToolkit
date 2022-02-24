function CB_RM_recolorTraces(source, event)

    nameAllFigures;

    options.blacklist{1} = source.Parent.UserData.GUI_FigureName;

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
        msgbox('No figures available to copy from.'); return;
    end
    
    [idx1,tf] = listdlg('PromptString','Source figure:','ListString',list,'SelectionMode','single','ListSize',[500 500]);
    if(~tf), return; end
    hSource = handles{idx1};
    
    axSource = findobj(hSource,'Type','Axes');
    lineSource = flip(findobj(hSource,'Type','Line'));
    if(isempty(lineSource))
       msgbox('No ''line'' traces found in that figure.');
       return;
    end
    for i = 1:length(lineSource)
        traceNames{i} = lineSource(i).DisplayName;
        if(isempty(traceNames{i}))
            traceNames{i} = '(no name)';
        end
    end
    
    [idx2,tf] = listdlg('PromptString','Traces to recolor:','ListString',traceNames,'SelectionMode','multiple','ListSize',[500 500]);
    if(~tf), return; end
    
    answer = questdlg('Coloring scheme to use:','Choose coloring scheme','Matlab Coloring','Default Gradient','Custom Gradient','Matlab Coloring');
    if(isempty(answer)), return; end
    
    if(isequal(answer,'Matlab Coloring'))
        idxC = 1;
        for i = 1:length(idx2)
            cmap(i,:) = axSource.ColorOrder(idxC,:);
            if(length(axSource.ColorOrder) == idxC)
                idxC = 1;
            else
                idxC = idxC + 1;
            end
        end
    elseif(isequal(answer,'Default Gradient'))
        cStart = [0    0.4510    0.7412];
        cEnd = [0.9294    0.6902    0.1294];
        cmap = interp1([1; length(idx2)],[cStart;cEnd],(1:length(idx2))');
    elseif(isequal(answer,'Custom Gradient'))
        cStart = uisetcolor([0 0 1],'Select a start color');
        cEnd = uisetcolor([1 0 0],'Select an end color');
        cmap = interp1([1; length(idx2)],[cStart;cEnd],(1:length(idx2))');
    end

    
    for i = 1:length(idx2)
        lineSource(idx2(i)).Color = cmap(i,:);
    end
    
end