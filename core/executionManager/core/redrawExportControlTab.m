function tabPointer = redrawExportControlTab()

    global tabExport;
    delete(tabExport.Children);
    tabPointer = GUI_tabInit_ExportControl(tabExport);

end