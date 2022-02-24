function CB_RM_renameTrace(source, event)

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
        msgbox('No figures available.'); return;
    end
    
    [idx1,tf] = listdlg('PromptString','Select figure:','ListString',list,'SelectionMode','single','ListSize',[500 500]);
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
    
    [idx2,tf] = listdlg('PromptString','Select Trace to Rename:','ListString',traceNames,'SelectionMode','multiple','ListSize',[500 500]);
    if(~tf), return; end
    
    answer = inputdlg('New name:','Rename Trace',[1 100],{lineSource(idx2).DisplayName});
    if(~isempty(answer))
        lineSource(idx2).DisplayName = answer{1};
    end
    legend;
    
end