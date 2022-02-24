function CB_RM_blankFigure(source, event)

    [answer] = inputdlg('Figure Name:','Name of Figure to Create',1,{'blank figure'});
    if(isempty(answer)), return; end
    try
        f = namedFigure(answer{1});
        line = plot(0,0);   % dummy plot so that we have axes
        legend;
        delete(line);       % delete the dummy
    catch
        msgbox('invalid name');
    end
    
end