function CB_RM_copyTracesToFigure(source, event)

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
    
    [idx2,tf] = listdlg('PromptString','Traces to copy:','ListString',traceNames,'SelectionMode','multiple','ListSize',[500 500]);
    if(~tf), return; end
    
    [idx3,tf] = listdlg('PromptString','Destination figure:','ListString',list,'SelectionMode','single','ListSize',[500 500]);
    if(~tf), return; end
    hDest = handles{idx3};
    axDest = findobj(hDest,'Type','Axes');
    
    
    if(length(idx2) == 1)
        answer = inputdlg('Copied Trace Name:','Name Trace',[1 100],{sprintf('%s (copy)',lineSource(i).DisplayName)});
        if(isempty(answer{1}))
            newName = sprintf('%s (copy)',lineSource(i).DisplayName);
        else
            newName = answer{1};
        end
        copyobj(lineSource(idx2), axDest);
        axDest.Children(1).DisplayName = newName;
    else
        for i = idx2
            copyobj(lineSource(i), axDest);
            axDest.Children(1).DisplayName = sprintf('%s (copy)',lineSource(i).DisplayName);
        end
    end
    
    figure(hDest);
    
end