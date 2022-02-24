function CB_RM_reorderTraces(source, event)

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
    legSource = findobj(hSource,'Type','Legend');
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
    
    [idx2,tf] = listdlg('PromptString','Trace to reorder:','ListString',traceNames,'SelectionMode','single','ListSize',[500 500]);
    if(~tf), return; end
    
    idx2 = length(lineSource) + 1 - idx2;
    
    answer = questdlg('Move to where?','Change ordering','Top','Bottom','Top');
    
    order = 1:length(lineSource);
    if(isequal(answer, 'Top'))
        neworder = [order(order ~= idx2) idx2];
    elseif(isequal(answer,'Bottom'))
        neworder = [idx2 order(order ~= idx2)];
    end

    axSource.Children = axSource.Children(neworder);
    delete(legSource);
    legend(axSource);
end