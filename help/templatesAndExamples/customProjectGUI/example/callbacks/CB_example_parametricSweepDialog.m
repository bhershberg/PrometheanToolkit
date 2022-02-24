function CB_example_parametricSweepDialog(source, event)

    msg = {};
    msg{end+1} = 'USAGE:';
    msg{end+1} = '';
    msg{end+1} = '[start, stop, step] = parametricSweepDialog(''Your Message'', ''Units'', start, stop, step);';
    msg{end+1} = '';
    msg{end+1} = '';
    msg{end+1} = 'DESCRIPTION:';
    msg{end+1} = '';
    msg{end+1} = 'The Parametric Sweep Dialog allows the user to graphically set up a parametric sweep. This is often very useful when building custom measurement functions for lab testing where you want to let the user interactively set up the sweep parameters.';
    msg{end+1} = '';
    msg{end+1} = '';
    msg{end+1} = 'WORKING EXAMPLE:';
    msg{end+1} = '';
    msg{end+1} = '[start, stop, step] = parametricSweepDialog(''A Handy Tool for Setting Up Sweeps'',''Volts'',-5, 10, 1);';
    msg{end+1} = '';
    msg{end+1} = '--> Click OK below to run this code...';
    textEditor(msg);

    [start, stop, step] = parametricSweepDialog('A Handy Tool for Setting Up Sweeps','Volts',-5, 10, 1);
    
end