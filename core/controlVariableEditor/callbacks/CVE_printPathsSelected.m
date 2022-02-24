function CVE_printPathsSelected(source, event, dataObject, breadcrumb, lvl2_listbox, lvl1_listbox)
    global settings;
    message = {};
    list_1D = {};
    list_2D = {};
    breadcrumb_mod = breadcrumb;
    
    onlyOneLevel = isempty(lvl2_listbox.String);
    
    if(onlyOneLevel)
        lvl2_crumbs = {'dummy'};
    else
        lvl2_crumbs = lvl2_listbox.String(lvl2_listbox.Value);
    end
    
    lvl1_crumbs = lvl1_listbox.String(lvl1_listbox.Value);
    for i = 1:length(lvl2_crumbs)
        for j = 1:length(lvl1_crumbs)
            breadcrumb_mod{end-1} = lvl1_crumbs{j};
            if(~onlyOneLevel)
                breadcrumb_mod{end-2} = lvl2_crumbs{i};
            end
            str = breadcrumbToString(breadcrumb_mod);
            str = getRelativeControlVariablePath(str);
            message{end+1} = str;
            list_1D{end+1} = sprintf('pathList{end+1} = ''%s'';',str);
            tmpBreadcrumb = strsplit(str,'.');
            tmpStr = '';
            for k = 1:length(tmpBreadcrumb)
                if(k == 1)
                    tmpStr = [tmpStr sprintf('pathList{end+1,%d} = ''%s''; ',k,tmpBreadcrumb{k})];
                else
                    tmpStr = [tmpStr sprintf('pathList{end,%d} = ''%s''; ',k,tmpBreadcrumb{k})];
                end
            end
            list_2D{end+1} = tmpStr;
        end
    end
    
    fullMessage = {};
    fullMessage{end+1} = 'Requested paths:';
    fullMessage{end+1} = '';
    fullMessage = [fullMessage message];
    fullMessage{end+1} = '';
    fullMessage{end+1} = '';
    fullMessage{end+1} = '';
    fullMessage{end+1} = 'Requested paths written as a 1D cell list:';
    fullMessage{end+1} = '';
    fullMessage{end+1} = 'pathList = {};';
    fullMessage = [fullMessage list_1D];
    fullMessage{end+1} = '';
    fullMessage{end+1} = '';
    fullMessage{end+1} = '';
    fullMessage{end+1} = 'Requested paths written as a 2D cell list:';
    fullMessage{end+1} = '';
    fullMessage{end+1} = 'pathList = {};';
    fullMessage = [fullMessage list_2D];
    fullMessage{end+1} = '';
    
    textEditor(fullMessage);
end
