function CB_RM_mergeTraces(source, event)

    nameAllFigures;

    options.blacklist = {};
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
        msgbox('No figures available to select.'); return;
    end
    
    [idx1,tf] = listdlg('PromptString','Source figure:','ListString',list,'SelectionMode','single','ListSize',[500 500]);
    if(~tf), return; end
    hSource = handles{idx1};
    
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
    
    [idx2,tf] = listdlg('PromptString','Traces to merge:','ListString',traceNames,'SelectionMode','multiple','ListSize',[500 500]);
    if(~tf), return; end
    if(length(idx2) < 2), return; end
    
    XData = [];
    YData = [];
    for i = idx2
        hTrace = lineSource(i);
        XData = [XData hTrace.XData];
        YData = [YData hTrace.YData];
    end
    hTrace = lineSource(idx2(1));
    [~, orderedIndexes] = sort(XData);
    hTrace.XData = XData(orderedIndexes);
    hTrace.YData = YData(orderedIndexes);
    hTrace.DisplayName = 'merged trace';
    for i = idx2(2:end)
        lineSource(i).delete;
    end
   
end