function redrawControlVariableEditorTab()

    global tabControlVariableEditor;
    delete(tabControlVariableEditor.Children);
    GUI_tabInit_ControlVariableEditor(tabControlVariableEditor);
    
end