function CB_example_listDialog(source, event)

    msg = {};
    msg{end+1} = 'USAGE:';
    msg{end+1} = '';
    msg{end+1} = 'indexesSelected = listDialog( ''Your Message'', choices, indexes, selectionMode );';
    msg{end+1} = '';
    msg{end+1} = '';
    msg{end+1} = 'DESCRIPTION:';
    msg{end+1} = '';
    msg{end+1} = 'The List Dialog allows a user to interactively choose item(s) from a list of items.';
    msg{end+1} = '';
    msg{end+1} = 'If the input parameter ''selectionMode'' is not set, it will default to ''single''. To allow multiple items to be selected, set it to ''multiple'' as shown in the working example below.';
    msg{end+1} = '';
    msg{end+1} = '';
    msg{end+1} = 'WORKING EXAMPLE:';
    msg{end+1} = '';
    msg{end+1} = 'choices = {};';
    msg{end+1} = 'for i = 1:30, choices{end+1} = sprintf(''choice #%d'',i); end';
    msg{end+1} = 'indexes = 13:17;';
    msg{end+1} = 'indexesSelected = listDialog(''Your Message'', choices, indexes, ''multiple'');';
    msg{end+1} = '';
    msg{end+1} = '--> Click OK below to run this code...';
    textEditor(msg);
    
    choices = {};
    for i = 1:30, choices{end+1} = sprintf('choice #%d',i); end
    indexes = 13:17;
    indexesSelected = listDialog('Your Message', choices, indexes, 'multiple');

end