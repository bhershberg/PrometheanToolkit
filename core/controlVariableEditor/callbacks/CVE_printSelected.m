function CVE_printSelected(source, event, dataObject, breadcrumb, lvl2_listbox, lvl1_listbox)
    global settings;
    printout = {};
    breadcrumb_mod = breadcrumb;
    
    onlyOneLevel = isempty(lvl2_listbox.String);
    
    if(onlyOneLevel)
        lvl1_crumbs = lvl1_listbox.String(lvl1_listbox.Value);
        for j = 1:length(lvl1_crumbs)
            breadcrumb_mod{end-1} = lvl1_crumbs{j};
            str = breadcrumbToString(breadcrumb_mod);
            eval(sprintf('value = %s{1};',str));
            printout{end+1} = {'', lvl1_crumbs{j}, num2str(value)};
        end
    else
        lvl2_crumbs = lvl2_listbox.String(lvl2_listbox.Value);
        lvl1_crumbs = lvl1_listbox.String(lvl1_listbox.Value);
        for i = 1:length(lvl2_crumbs)
            for j = 1:length(lvl1_crumbs)
                breadcrumb_mod{end-1} = lvl1_crumbs{j};
                breadcrumb_mod{end-2} = lvl2_crumbs{i};
                str = breadcrumbToString(breadcrumb_mod);
                eval(sprintf('value = %s{1};',str));
                printout{end+1} = {lvl2_crumbs{i}, lvl1_crumbs{j}, num2str(value)};
            end
        end
    end
    message = {};
    
    allNumeric = 1;
    values = [];
    for k = 1:length(printout)
        if(isscalar(str2num(printout{k}{3})))
            values(k) = str2num(printout{k}{3});
        else
            values{k} = printout{k}{3};
            allNumeric = 0;
        end
        if(onlyOneLevel)
            message{end+1} = sprintf('%s:\t%s',printout{k}{2},printout{k}{3});
        else
            message{end+1} = sprintf('%s, %s:\t%s',printout{k}{1},printout{k}{2},printout{k}{3});
        end
    end
    if(isempty(message)), message{end+1} = 'nothing selected.'; end
    message{end+1} = '';
    if(allNumeric)
        message{end+1} = 'Statistics:';
        message{end+1} = sprintf('mean: %0.4f',mean(values));
        message{end+1} = sprintf('stddev: %0.4f',std(values));
    end
    textEditor(message);
end
