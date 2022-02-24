function CVE_copyToSelected(source, event, dataObject, breadcrumb, lvl2_listbox, lvl1_listbox)
    global settings;
    answer = questdlg('What do you want to copy?','Copy Preference','Value','Description','Cancel','Value');
    skipped = {};
    copied = {};
    if(~isequal(answer,'Cancel'))
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
                [~, info, success] = getControlVariable(str);
                if(success)
                    if(isequal(info.type,'Digital Control Variable'))
                        docuIndex = 5;
                    elseif(isequal(info.type,'Soft Variable'))
                        docuIndex = 2;
                    end
                    if(isequal(answer,'Value'))
                        if(isnumeric(dataObject{1}))
                            eval(sprintf('%s{1} = %s;',str, num2str(dataObject{1})));
                        else
                            eval(sprintf('%s{1} = ''%s'';',str, dataObject{1}));
                        end
                    end
                    if(isequal(answer,'Description'))
                        eval(sprintf('%s{%d} = ''%s'';',str, docuIndex, strrep(dataObject{docuIndex},'''','''''')));
                    end
                    copied{end+1} = getRelativeControlVariablePath(str);
                else
                    % We thought something would be at this path,
                    % but it wasn't. This can happen because we
                    % made an assumption that the hierarchy was
                    % uniform.
                    skipped{end+1} = getRelativeControlVariablePath(str);
                end
            end
        end
        exitMessage = {};
        if(~isempty(copied))
            exitMessage{end+1} = 'Successfully copied to:';
            exitMessage{end+1} = '';
            exitMessage = [exitMessage copied];
            exitMessage{end+1} = '';
            exitMessage{end+1} = '';
        end
        if(~isempty(skipped))
            exitMessage{end+1} = 'Could not copy to:';
            exitMessage{end+1} = '';
            exitMessage = [exitMessage skipped];
        end
        textEditor(exitMessage);
    end
end