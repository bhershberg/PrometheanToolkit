function CB_example_optionsEditor(source, event)
    
    msg = {};
    msg{end+1} = 'USAGE:';
    msg{end+1} = '';
    msg{end+1} = 'options = optionsEditor( options );';
    msg{end+1} = '';
    msg{end+1} = '';
    msg{end+1} = 'DESCRIPTION:';
    msg{end+1} = '';
    msg{end+1} = 'The Options Editor is the same as the Data Editor in that it allows a user to edit the data of a structure, but it is special-purpose. The customizable parameters have been defined for you, i.e. the base structure will be named ''options''. The Options Editor is very useful for allowing the user to modify function parameters prior to code execution. If you''re using Promethean Toolkit correctly, then you will be using this tool constantly!';
    msg{end+1} = '';
    msg{end+1} = 'Notice the "Display All..." button at bottom right of the Data Editor. By default certain data elements like overly long vectors, cell arrays, nested structures, etc will not be displayed. But through this button, you can choose to override that and view everything.';
    msg{end+1} = '';
    msg{end+1} = '';
    msg{end+1} = 'WORKING EXAMPLE:';
    msg{end+1} = '';
    msg{end+1} = 'options = getDefaultOptions(@example_userFunction);';
    msg{end+1} = 'data.anExampleNestedStructure.foo = ''hello'';';
    msg{end+1} = 'data.anExampleNestedStructure.bar = ''world!'';';
    msg{end+1} = 'data.aVeryLongVector = 1:1000;';
    msg{end+1} = 'options = optionsEditor(options);';
    msg{end+1} = '';
    msg{end+1} = '--> Click OK below to run this code...';
    textEditor(msg);
    
    options = getDefaultOptions(@example_userFunction);
    options.anExampleNestedStructure.foo = 'hello';
    options.anExampleNestedStructure.bar = 'world!';
    options.aVeryLongVector = 1:1000;
    
    options = optionsEditor(options);

end