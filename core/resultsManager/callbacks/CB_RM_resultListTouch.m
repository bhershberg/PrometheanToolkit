function CB_RM_resultListTouch(source, event)

    if strcmp(get(gcf,'selectiontype'),'open') % black magic to detect a double-click
        CB_RM_plot(source, event);
    end
    
    CB_RM_refresh(source,event);

end