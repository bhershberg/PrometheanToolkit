function CB_example_textEditor(source, event)
    
    msg = {};
    msg{end+1} = 'USAGE:';
    msg{end+1} = '';
    msg{end+1} = 'textOut = textEditor( textIn );';
    msg{end+1} = '';
    msg{end+1} = '';
    msg{end+1} = 'DESCRIPTION:';
    msg{end+1} = '';
    msg{end+1} = 'The Text Editor allows the user to create and/or edit text. Note that the ''textIn'' input parameter can either be a 1D cell array or a 2D char array. The cell array option is strongly recommended because it avoids extra whitespace from being inserted.';
    msg{end+1} = '';
    msg{end+1} = '';
    msg{end+1} = 'WORKING EXAMPLE:';
    msg{end+1} = '';
    msg{end+1} = 'msg = {};';
    msg{end+1} = 'msg{end+1} = ''Logic clearly dictates that the needs of the many outweigh the needs of the few.'';';
    msg{end+1} = 'msg{end+1} = ''-Spock'';';
    msg{end+1} = 'newMsg = textEditor(msg);';
    msg{end+1} = '';
    msg{end+1} = '--> Click OK below to run this code...';
    textEditor(msg);
    
    msg = {};
    msg{end+1} = 'Logic clearly dictates that the needs of the many outweigh the needs of the few.';
    msg{end+1} = '-Spock';
    msg = textEditor(msg);
    
end