function CB_RM_exportFigure(source, event)

    options.blacklist{1} = source.Parent.UserData.GUI_FigureName;
    exportFigure(options);

end