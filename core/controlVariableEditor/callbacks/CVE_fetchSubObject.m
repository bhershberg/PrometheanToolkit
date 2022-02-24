function subObject = CVE_fetchSubObject(breadcrumb)
    global settings;
    global tabControlVariableEditor;
    
    str = breadcrumbToString(breadcrumb);
    try
        subObject = eval(str);
    catch
        delete(tabControlVariableEditor.Children);
        GUI_tabInit_ControlVariableEditor(tabControlVariableEditor);
    end
end