function selectTab(tabName)

    global mainGuiTabs;
    
    for i = 1:length(mainGuiTabs.Children)
        if(isequal(mainGuiTabs.Children(i).Title,tabName))
           mainGuiTabs.SelectedTab = mainGuiTabs.Children(i);
           break;
        end
    end

end