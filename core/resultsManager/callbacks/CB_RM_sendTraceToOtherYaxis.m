function CB_RM_sendTraceToOtherYaxis(source, event)

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
    
    [idx2,tf] = listdlg('PromptString','Select Trace(s) to Move:','ListString',traceNames,'SelectionMode','multiple','ListSize',[500 500]);
    if(~tf), return; end
    
    answer = inputdlg('2nd y-axis name:','y-axis name?',[1 50]);
    if(~isempty(answer) && ~isempty(answer{1}))
        axisName = answer{1};
    else
        axisName = '';
    end
    
    axesSource = findobj(hSource,'Type','Axes');

    for i = idx2
        figure(hSource);
        hold on;
        yyaxis right
        xData = lineSource(i).XData;
        yData = lineSource(i).YData;
        p = plot(axesSource,xData,yData);
        p.DisplayName = lineSource(i).DisplayName;
        ylabel(axisName);
        yyaxis left
        hold off;
    end
    
    delete(lineSource(idx2));
    legend;
    
end