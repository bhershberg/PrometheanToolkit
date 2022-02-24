function CVE_apply5(source, event, dataObject, breadcrumb, parentPanel, parentMenu, textValue, textDescription)

    global settings;
    
    str = breadcrumbToString(breadcrumb);
    eval(sprintf('%s{1} = %s;',str, textValue.String));
    eval(sprintf('%s{5} = ''%s'';',str, strrep(textDescription.String,'''','''''')));
    updatedDataObject = CVE_fetchSubObject(breadcrumb);
    
    %destroy the current data view and build a new one with the updated values:
    delete(parentPanel.Children);
    CVE_displayDataObject(updatedDataObject, breadcrumb, parentPanel, parentMenu);

end
