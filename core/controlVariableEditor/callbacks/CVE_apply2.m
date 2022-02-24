function CVE_apply2(source, event, dataObject, breadcrumb, parentPanel, parentMenu, textValue, textDescription)

    global settings;
    
    str = breadcrumbToString(breadcrumb);
    [num, status] = str2num(textValue.String);
    if(status == 0)
        eval(sprintf('%s{1} = ''%s'';',str, textValue.String));
        eval(sprintf('%s{3} = ''%s'';',str, textValue.String));
    else
        eval(sprintf('%s{1} = %s;',str, textValue.String));
        eval(sprintf('%s{3} = %s;',str, textValue.String));
    end
    eval(sprintf('%s{2} = ''%s'';',str, strrep(textDescription.String,'''','''''')));
    updatedDataObject = CVE_fetchSubObject(breadcrumb);
    
    %destroy the current data view and build a new one with the updated values:
    delete(parentPanel.Children);
    CVE_displayDataObject(updatedDataObject, breadcrumb, parentPanel, parentMenu);

end