function CB_RM_dockAllFigures(source, event)
    
    options.blacklist{1} = source.Parent.UserData.GUI_FigureName;
    dockAllFigures(options);
    
end