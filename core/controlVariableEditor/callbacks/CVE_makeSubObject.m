function CVE_makeSubObject(source, event)

    px = 0; py = 0; pw = 0; ph = 0;
    initializeGraphics;
    
    % delete any old menus lying around (recursive because they are linked to parents):
    if(~isempty(source.UserData.childMenu))
        delete(source.UserData.childMenu);
    end
    
    if(~strcmp(source.String{source.Value},'choose...') && ~strcmp(source.String{source.Value},'no settings loaded...'))
        breadcrumb = source.UserData.breadcrumb;
        breadcrumb{end+1} = source.String{source.Value};
        try
            subObject = CVE_fetchSubObject(breadcrumb);
        catch 
            warning('Control Variable Structure has changed unexpectedly');
            return;
        end
        
        % if we're at a branch node, make another sub-menu:
        if(isstruct(subObject))
            fnames = fieldnames(subObject);
            [~, alpha_idx] = sort(lower(fnames));
            menu_options = fnames(alpha_idx);
            menu_options = {'choose...' menu_options{1:end}};
            p = source.Position;
            menu_subMenu = uicontrol('Parent',source.Parent,'Style','popupmenu','String',menu_options,'Callback',@CVE_makeSubObject,'DeleteFcn',@CVE_deleteSubObject,'Units','normalized','Position',[p(1)+dfx+p(3) p(2) p(3) p(4)]);
            source.UserData.childMenu = menu_subMenu;
            menu_subMenu.UserData.breadcrumb = breadcrumb;
            menu_subMenu.UserData.childMenu = [];
            menu_subMenu.UserData.parentPanel = source.UserData.parentPanel;
            
        % if we're at a leaf node, display the data:
        else                    
            panel_dataObject = placePanel(source.UserData.parentPanel,[2.5 18.5],[1 6.95],'Data Object');
            source.UserData.childMenu = panel_dataObject;
            CVE_displayDataObject(subObject, breadcrumb, panel_dataObject, source);
            uicontrol(source); % focus back on the menu, this is convenient for quickly flipping through variables
        end
    else
        source.UserData.childMenu = [];
    end
end