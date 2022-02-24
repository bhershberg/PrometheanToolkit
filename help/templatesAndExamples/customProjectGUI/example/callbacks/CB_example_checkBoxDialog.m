function CB_example_checkBoxDialog(source, event)
    
    msg = {};
    msg{end+1} = 'USAGE:';
    msg{end+1} = '';
    msg{end+1} = 'checkboxDialog( ''Your Message'', choices, values );';
    msg{end+1} = '';
    msg{end+1} = '';
    msg{end+1} = 'DESCRIPTION:';
    msg{end+1} = '';
    msg{end+1} = 'The Checkbox Dialog allows a user to interactively choose an unrestricted number of items among many.';
    msg{end+1} = '';
    msg{end+1} = '';
    msg{end+1} = 'WORKING EXAMPLE:';
    msg{end+1} = '';
    msg{end+1} = 'choices = {''choice #1'', ''choice #2'', ''choice #3''};';
    msg{end+1} = 'values = [0 1 0];';
    msg{end+1} = 'checkboxDialog( ''Choose something:'', choices, values );';
    msg{end+1} = '';
    msg{end+1} = '--> Click OK below to run this code...';
    textEditor(msg);
    
    choices = {'choice #1','choice #2','choice #3'};
    values = [1 1 0];
    checkboxDialog('A helpful tool for allowing multiple selections:',choices,values);

end