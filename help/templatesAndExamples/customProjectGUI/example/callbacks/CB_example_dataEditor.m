function CB_example_dataEditor(source, event)
    
    msg = {};
    msg{end+1} = 'USAGE:';
    msg{end+1} = '';
    msg{end+1} = 'dataStruct = dataEditor( dataStruct, ''dataStructName'', dataEditorOptions );';
    msg{end+1} = '';
    msg{end+1} = '';
    msg{end+1} = 'DESCRIPTION:';
    msg{end+1} = '';
    msg{end+1} = 'The Data Editor is a very useful tool that enables the user to directly edit the contents of a structure.';
    msg{end+1} = '';
    msg{end+1} = 'Notice the "Display All..." button at bottom right of the Data Editor. By default certain data elements like overly long vectors, cell arrays, nested structures, etc will not be displayed. But through this button, you can choose to override that and view everything.';
    msg{end+1} = '';
    msg{end+1} = '';
    msg{end+1} = 'WORKING EXAMPLE:';
    msg{end+1} = '';
    msg{end+1} = 'data = getDefaultOptions(@example_userFunction);';
    msg{end+1} = 'data.anExampleNestedStructure.foo = ''hello'';';
    msg{end+1} = 'data.anExampleNestedStructure.bar = ''world!'';';
    msg{end+1} = 'data.aVeryLongVector = 1:1000;';
    msg{end+1} = 'options.message = ''You can specify whatever message you want here...'';';
    msg{end+1} = 'data = dataEditor(data, ''data'', options);';
    msg{end+1} = '';
    msg{end+1} = '--> Click OK below to run this code...';
    textEditor(msg);
    
    data = getDefaultOptions(@example_userFunction);
    data.anExampleNestedStructure.foo = 'hello';
    data.anExampleNestedStructure.bar = 'world!';
    data.aVeryLongVector = 1:1000;
    
    options.message = 'You can specify whatever message you want here...';
    data = dataEditor(data, 'data', options);

end