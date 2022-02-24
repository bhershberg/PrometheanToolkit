function CB_tabChanged(source, event)

    if(isequal(source.SelectedTab.Title,'File Manager'))
        % nothing here yet
    end

    if(isequal(source.SelectedTab.Title,'Control Variable Editor'))
        % nothing here yet
    end
    
    if(isequal(source.SelectedTab.Title,'Equipment Control'))
        % nothing here yet
    end
    
    if(isequal(source.SelectedTab.Title,'Export Control'))
%         redrawExportControlTab;
    end

    if(isequal(source.SelectedTab.Title,'Results Manager'))
        refreshResultsManagerTab;
    end
    
end