function CB_RM_copyFigure(source, event)

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
        msgbox('No figures available to copy.');  return;
    end
    
    [idx,tf] = listdlg('PromptString','Select figure to Copy:','ListString',list,'SelectionMode','single','ListSize',[500 500]);
    if(~tf), return; end
    h = handles{idx};
    
    newName = inputdlg('New name:','Copy Figure',[1 50],{[list{idx} ' Copy']});
    if(isempty(newName))
        return;
    end

    hNew = namedFigure(newName{1});
    
    copyobj(h.Children,hNew);
    
end