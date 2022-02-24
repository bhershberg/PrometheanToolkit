function CB_viewDefaultOptions(source, event)

    try
        functionName = strrep(source.Parent.UserData.exportScriptName,'.m','');
        eval(sprintf('functionHandle = @%s',functionName));
        options = getDefaultOptions(functionHandle);

        editorOptions.message = 'These are the default option fields/values that were pulled from the underlying script/function:';
        dataEditor(options, 'options', editorOptions);
    catch
       msg = {};
       msg{end+1} = 'Unable to obtain script/function defaults.';
       msg{end+1} = '';
       msg{end+1} = 'Run the following lines in the Command Window to open template and example files that show how to set this up:';
       msg{end+1} = '';
       msg{end+1} = 'open template__basicExecuteScript;';
       msg{end+1} = 'open template__basicExecuteFunction;';
       msg{end+1} = 'open template_userFunction;';
       msg{end+1} = '';
       msg{end+1} = 'open example_userFunction;';
       msg{end+1} = 'open example__sweepControlVariable;';
       textEditor(msg);
    end

end